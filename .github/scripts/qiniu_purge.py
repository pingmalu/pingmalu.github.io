#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""根据 git push 删除七牛镜像对象，并刷新 CDN。

规则对齐 m1 的 QiniuController::GithubhookAction：
- 文章被修改：按文件名里的标题删除对象，并刷新对应 URL（带 / 与不带 /）。
- 有文件新增、删除或重命名：额外清理首页和 page2–page8。
- 新增或删除的文章，也会按标题清理，避免旧文章页留在镜像里。
"""

import base64
import hashlib
import hmac
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone

BUCKET = "pingmalu-github-io"
CDN_ORIGIN = "http://git.malu.me"
RS_HOST = "rs.qiniuapi.com"
CDN_HOST = "fusion.qiniuapi.com"

# 与 PHP 里新增/删除时刷新的页面一致
HOME_KEYS = ["", "index.html"] + ["page%d" % i for i in range(2, 9)]
POST_RE = re.compile(r"-\d{2}-\d{2}-(.*?)\.md$")

# 对象不存在时七牛返回 612，镜像里本来就没有，不算失败
DELETE_OK_CODES = {200, 612}


def php_urlencode(text):
    """对齐 PHP urlencode：只保留 ASCII 字母数字和 -_.，空格变 +。"""
    out = []
    for byte in text.encode("utf-8"):
        if byte in b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.":
            out.append(chr(byte))
        elif byte == 32:
            out.append("+")
        else:
            out.append("%%%02X" % byte)
    return "".join(out)


def urlsafe_b64(raw):
    """七牛 URL 安全 Base64，保留末尾 =。"""
    return base64.urlsafe_b64encode(raw).decode("ascii")


def sign_qiniu(method, host, path, content_type, body, qiniu_date, secret_key):
    """对象存储管理凭证。文档：https://developer.qiniu.com/kodo/1201/access-token"""
    signing = "\n".join([
        "%s %s" % (method, path),
        "Host: %s" % host,
        "Content-Type: %s" % content_type,
        "X-Qiniu-Date: %s" % qiniu_date,
        "",
        body,
    ])
    digest = hmac.new(secret_key.encode("utf-8"), signing.encode("utf-8"), hashlib.sha1).digest()
    return urlsafe_b64(digest)


def sign_qbox(path, secret_key):
    """CDN 使用 QBox，只签路径加换行，JSON 正文不参与签名。"""
    signing = path + "\n"
    digest = hmac.new(secret_key.encode("utf-8"), signing.encode("utf-8"), hashlib.sha1).digest()
    return urlsafe_b64(digest)


def http_json(url, method, headers, body):
    data = body.encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            raw = resp.read().decode("utf-8")
            return resp.status, raw
    except urllib.error.HTTPError as exc:
        raw = exc.read().decode("utf-8", errors="replace")
        return exc.code, raw


def post_title(path):
    name = path.replace("\\", "/").split("/")[-1]
    matched = POST_RE.search(name)
    if not matched:
        return None
    return matched.group(1)


def unquote_git_path(path):
    """core.quotepath=true 时，git 会把中文路径包进引号并转义。"""
    if len(path) >= 2 and path[0] == '"' and path[-1] == '"':
        return path[1:-1].encode("utf-8").decode("unicode_escape").encode("latin1").decode("utf-8")
    return path


def changed_paths(before, after):
    """返回 (是否有新增/删除/重命名, 需要提取标题的路径列表)。无法对比时返回 None。"""
    if not before or set(before) <= {"0"}:
        return None
    proc = subprocess.run(
        ["git", "-c", "core.quotepath=false", "diff", "--name-status", "--find-renames", before, after],
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if proc.returncode != 0:
        sys.stderr.write(proc.stderr or "")
        return None

    structural = False
    paths = []
    for line in proc.stdout.splitlines():
        if not line.strip():
            continue
        parts = [unquote_git_path(part) for part in line.split("\t")]
        status = parts[0]
        if status.startswith(("A", "D", "R", "C")):
            structural = True
            paths.extend(parts[1:])
        elif status.startswith(("M", "T")):
            paths.extend(parts[1:])
    return structural, paths


def with_slash_variants(keys):
    """非空 key 再补一个以 / 结尾的版本，顺序与 PHP 一致。"""
    ordered = []
    seen = set()
    for key in list(keys):
        if key not in seen:
            seen.add(key)
            ordered.append(key)
    for key in list(ordered):
        if key != "" and (key + "/") not in seen:
            seen.add(key + "/")
            ordered.append(key + "/")
    return ordered


def keys_from_push(before, after):
    changed = changed_paths(before, after)
    if changed is None:
        print("无法对比前后提交，改为清理首页和分页")
        return with_slash_variants(HOME_KEYS)

    structural, paths = changed
    keys = []
    if structural:
        keys.extend(HOME_KEYS)
    for path in paths:
        title = post_title(path)
        if title:
            keys.append(title)
    return with_slash_variants(keys)


def keys_from_manual(mode, titles):
    if mode == "titles":
        items = [item.strip() for item in titles.replace("，", ",").split(",")]
        items = [item for item in items if item]
        if not items:
            raise SystemExit("手动刷新 titles 模式需要填写文章标题")
        return with_slash_variants(items)
    return with_slash_variants(HOME_KEYS)


def cdn_urls(keys):
    urls = []
    for key in keys:
        if key.endswith("/"):
            urls.append(CDN_ORIGIN + "/" + php_urlencode(key[:-1]) + "/")
        else:
            urls.append(CDN_ORIGIN + "/" + php_urlencode(key))
    return urls


def chunked(items, size):
    for start in range(0, len(items), size):
        yield items[start:start + size]


def delete_objects(keys, access_key, secret_key):
    for group in chunked(keys, 1000):
        ops = []
        for key in group:
            entry = urlsafe_b64(("%s:%s" % (BUCKET, key)).encode("utf-8"))
            ops.append("/delete/" + entry)
        body = "&".join("op=" + op for op in ops)
        qiniu_date = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        token = sign_qiniu("POST", RS_HOST, "/batch", "application/x-www-form-urlencoded", body, qiniu_date, secret_key)
        status, raw = http_json(
            "https://%s/batch" % RS_HOST,
            "POST",
            {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Qiniu %s:%s" % (access_key, token),
                "X-Qiniu-Date": qiniu_date,
            },
            body,
        )
        print("删除对象 HTTP %s" % status)
        print(raw)
        if status not in (200, 298):
            raise SystemExit("删除七牛对象失败")
        try:
            result = json.loads(raw)
        except json.JSONDecodeError:
            raise SystemExit("删除接口返回的不是 JSON")
        if not isinstance(result, list):
            raise SystemExit("删除接口返回格式异常")
        for item in result:
            code = item.get("code") if isinstance(item, dict) else None
            if code not in DELETE_OK_CODES:
                raise SystemExit("有对象删除失败，code=%s" % code)


def refresh_cdn(urls, access_key, secret_key):
    for group in chunked(urls, 50):
        body = json.dumps({"urls": group}, ensure_ascii=False, separators=(",", ":"))
        token = sign_qbox("/v2/tune/refresh", secret_key)
        status, raw = http_json(
            "https://%s/v2/tune/refresh" % CDN_HOST,
            "POST",
            {
                "Content-Type": "application/json",
                "Authorization": "QBox %s:%s" % (access_key, token),
            },
            body,
        )
        print("刷新 CDN HTTP %s" % status)
        print(raw)
        if status != 200:
            raise SystemExit("刷新 CDN 失败")
        try:
            result = json.loads(raw)
        except json.JSONDecodeError:
            raise SystemExit("CDN 接口返回的不是 JSON")
        code = result.get("code") if isinstance(result, dict) else None
        if code not in (200, None):
            raise SystemExit("刷新 CDN 失败，code=%s" % code)


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")

    event_name = os.environ.get("EVENT_NAME", "push")
    if event_name == "workflow_dispatch":
        keys = keys_from_manual(os.environ.get("INPUT_MODE", "home"), os.environ.get("INPUT_TITLES", ""))
    else:
        keys = keys_from_push(os.environ.get("BEFORE_SHA", ""), os.environ.get("AFTER_SHA", "HEAD"))

    if not keys:
        print("这次提交没有需要清理的页面，跳过")
        return

    urls = cdn_urls(keys)
    print("将删除 Bucket %s 中的对象：" % BUCKET)
    for key in keys:
        print("  %s" % (key if key != "" else "(首页空 key)"))
    print("将刷新 CDN：")
    for url in urls:
        print("  %s" % url)

    if os.environ.get("DRY_RUN") == "1":
        print("DRY_RUN=1，未调用七牛接口")
        return

    access_key = os.environ.get("QINIU_ACCESS_KEY", "")
    secret_key = os.environ.get("QINIU_SECRET_KEY", "")
    if not access_key or not secret_key:
        raise SystemExit("缺少 GitHub Secrets：QINIU_ACCESS_KEY / QINIU_SECRET_KEY")

    delete_objects(keys, access_key, secret_key)
    refresh_cdn(urls, access_key, secret_key)
    print("完成")


if __name__ == "__main__":
    main()
