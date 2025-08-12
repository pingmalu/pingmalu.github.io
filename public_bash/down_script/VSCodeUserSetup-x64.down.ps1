param(
  [ValidateSet('auto','x64','arm64')]
  [string]$Arch = 'auto',

  [ValidateSet('user','system','zip')]
  [string]$Installer = 'user',

  [string]$OutDir = '.',

  [switch]$NoProgress
)

# 设置代理（如果不需要代理可以注释或删除下面一行）
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')


# 1) 启用 TLS1.2，避免某些环境握手失败
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2) 自动检测架构
if ($Arch -eq 'auto') {
  $isArm = $false
  try {
    $isArm = $env:PROCESSOR_ARCHITECTURE -match 'ARM64'
  } catch {}
  $Arch = if ($isArm) { 'arm64' } else { 'x64' }
}

# 3) 选择 VS Code 下载通道（稳定版）与目标包类型
#    user   -> 无需管理员权限的用户安装包
#    system -> 需要管理员权限的系统安装包
#    zip    -> 免安装 ZIP 包
switch ($Installer) {
  'user'   { $osSlug = "win32-$Arch-user"; $ext = 'exe' }
  'system' { $osSlug = "win32-$Arch";      $ext = 'exe' }
  'zip'    { $osSlug = "win32-$Arch-zip";  $ext = 'zip' }
}

$downloadUrl = "https://code.visualstudio.com/sha/download?build=stable&os=$osSlug"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

# 4) 输出文件名（可按需改成带时间戳/版本号）
# $outFile = Join-Path $OutDir ("VSCode-$Installer-$Arch.$ext")

# 4) 【核心修改】通过网络请求获取服务器建议的文件名
Write-Host "正在获取下载信息..."
try {
    $response = Invoke-WebRequest -Uri $downloadUrl -Method Head -UseBasicParsing
    
    $contentDisposition = $response.Headers['Content-Disposition']
    $serverFileName = '' # 初始化变量

    # 优先从 Content-Disposition 响应头中解析文件名
    # 使用更健壮的正则表达式，只匹配 filename="..." 或 filename=... 的值
    if ($contentDisposition -and $contentDisposition -match 'filename\*?="?([^"]+)"?') {
        $serverFileName = $Matches[1]
    } else {
        # 如果无法从 Header 获取，则尝试从最终的重定向 URL 中解析
        $serverFileName = [System.IO.Path]::GetFileName($response.BaseResponse.ResponseUri.LocalPath)
    }

    # 【关键修复】清理文件名，移除分号及其之后的所有内容，并修剪两边的引号和空格
    if ($serverFileName) {
        $serverFileName = $serverFileName.Split(';')[0].Trim('" ')
    }

    if (-not $serverFileName) {
        throw "无法从服务器响应中确定文件名。"
    }

    $outFile = Join-Path $OutDir $serverFileName

} catch {
    Write-Error "获取下载信息失败: $($_.Exception.Message)"
    pause # 在出错时暂停，方便查看错误信息
    exit 1
}


# ========= 新增：判断文件是否已存在 =========
if (Test-Path $outFile) {
    Write-Host "文件已存在，跳过下载: $outFile"
    pause
    exit 0
}
# ==========================================

# 5) 可选：关闭进度条以提升下载性能
if ($NoProgress) { $global:ProgressPreference = 'SilentlyContinue' }

Write-Host "开始下载 VS Code ($Installer, $Arch) ..."
Write-Host "URL: $downloadUrl"
Write-Host "保存到: $outFile"

try {
  Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile
  Write-Host "下载完成: $outFile"
} catch {
  Write-Error "下载失败：$($_.Exception.Message)"
  exit 1
}


pause