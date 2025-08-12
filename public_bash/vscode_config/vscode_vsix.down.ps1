# 批量下载 VS Code 扩展 VSIX（最新版本）
# 输出目录：当前目录下的 "vsix" 文件夹
# ### 查询 VSCode 插件最新正式版本（非预发布）
# POST https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=7.1-preview.1
# Content-Type: application/json
# {
#   "filters": [
#     {
#       "criteria": [
#         {
#           "filterType": 7,
#           "value": "continue.continue"
#         }
#       ]
#     }
#   ],
#   "flags": 17
# }




Write-Host ""
Write-Host "[*] 正在准备下载 VSIX（将保存到 .\vsix\）..." -ForegroundColor Cyan
Write-Host ""

# 在这里增删扩展 ID（publisher.extensionName）
$extIds = @(
    "ms-python.python",
    "ms-python.debugpy",
    "ms-python.vscode-pylance",
    "ms-python.vscode-python-envs",
    "ms-python.black-formatter",
    "anweber.vscode-httpyac",
    "vscodevim.vim",
    "ms-vscode.remote-explorer",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-ceintl.vscode-language-pack-zh-hans",
    "continue.continue",
    "saoudrizwan.claude-dev"
)

# 设置代理（如果不需要代理可以注释或删除下面一行）
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')

# 确保使用 TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 输出目录
$outDir = Join-Path -Path (Get-Location) -ChildPath "vsix"
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

function Get-LatestVersion([string]$id) {
    $body = @{
        filters = @(@{
            criteria = @(@{
                filterType = 7
                value = $id
            })
        })
        flags = 17
    } | ConvertTo-Json -Depth 10

    $uri = "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=7.1-preview.1"
    $resp = Invoke-RestMethod -Method Post -Uri $uri -ContentType "application/json" -Body $body

    $ext = $resp.results[0].extensions[0]
    if (-not $ext) {
        throw "无法获取扩展信息: $id"
    }
    # Write-Host "$ext.versions[0]"


    # 遍历 $ext.versions
    foreach ($version in $ext.versions) {
        # 检查 properties 是否包含特定结构
        $hasPreRelease = $false
        foreach ($property in $version.properties) {
            if ($property.key -eq "Microsoft.VisualStudio.Code.PreRelease" -and $property.value -eq "true") {
                $hasPreRelease = $true
                break
            }
        }
        
        # 如果没有找到这个结构，返回对应的 version
        if (-not $hasPreRelease) {
            return $version.version
        }
    }

    # 如果所有版本都包含该结构，返回 null 或其他默认值
    return $null

    # 返回最新版本号
    # return $ext.versions[0].version
}

foreach ($id in $extIds) {
    $parts = $id -split '\.', 2
    if ($parts.Length -ne 2) {
        Write-Host "[!] 扩展 ID 无效: $id" -ForegroundColor Yellow
        continue
    }
    $publisher = $parts[0]
    $name = $parts[1]

    try {
        $version = Get-LatestVersion $id
    } catch {
        Write-Host "[x] 获取版本失败: $id -> $_" -ForegroundColor Red
        continue
    }

    $url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$version/vspackage"
    Write-Host "[URL] $url" -ForegroundColor Yellow

    $file = Join-Path $outDir "$id-$version.vsix"
    if (-not (Test-Path $file)) {
        try {
            Write-Host "[*] 正在下载 $id (v$version) ..." -ForegroundColor Cyan
            Invoke-RestMethod -Uri $url -OutFile $file
            Write-Host "[?] 已保存: $file" -ForegroundColor Green
        } catch {
            Write-Host "[x] 下载失败 $id -> $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[跳过] 文件已存在: $file" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "[完成] 所有任务已结束。VSIX 文件位于: $(Resolve-Path $outDir)" -ForegroundColor Green

# 等待用户按键
Write-Host ""
Write-Host "按任意键退出..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
