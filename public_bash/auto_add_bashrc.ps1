# 自动搜索 Git Bash 路径
$gitBashPath = Get-Command bash.exe -ErrorAction SilentlyContinue | Where-Object {
    $_.Source -match "Git[\\/](bin|usr[\\/]bin)[\\/]bash\.exe$"
} | Select-Object -First 1 -ExpandProperty Source

if (-not $gitBashPath) {
    Write-Host "警告：未在 PATH 中找到 Git Bash"
    
    # 检查默认 Git 安装路径
    $defaultGitBinPath = "C:\Program Files\Git\bin"
    $defaultGitBashExe = Join-Path $defaultGitBinPath "bash.exe"
    
    if (Test-Path $defaultGitBashExe) {
        Write-Host "在默认路径找到 Git Bash: $defaultGitBashExe"
        Write-Host "正在将 $defaultGitBinPath 添加到用户环境变量 PATH..."
        
        try {
            # 获取当前用户的 PATH 环境变量
            $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
            
            # 检查路径是否已存在
            if ($userPath -notlike "*$defaultGitBinPath*") {
                # 添加新路径（使用分号分隔）
                $newPath = if ($userPath) { "$userPath;$defaultGitBinPath" } else { $defaultGitBinPath }
                [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
                
                # 更新当前会话的 PATH
                $env:Path = "$env:Path;$defaultGitBinPath"
                
                Write-Host "已成功将 Git Bash 路径添加到用户环境变量 PATH"
                $gitBashPath = $defaultGitBashExe
            } else {
                Write-Host "Git Bash 路径已存在于用户 PATH 中"
                $gitBashPath = $defaultGitBashExe
            }
        } catch {
            Write-Host "错误：无法修改环境变量 PATH - $_"
            pause
            exit 1
        }
    } else {
        Write-Host "错误：未找到 Git Bash，请确认 Git 已安装在 $defaultGitBinPath"
        pause
        exit 1
    }
}

# 检测并创建 .bash_profile
$bashProfile = Join-Path $HOME ".bash_profile"
if (-not (Test-Path $bashProfile)) {
    New-Item -Path $bashProfile -ItemType File -Force | Out-Null
    Write-Host "已创建 $bashProfile"
}

# 检查 .bash_profile 是否包含 .bashrc 关键字
$profileContent = Get-Content $bashProfile -Raw -ErrorAction SilentlyContinue
# 如果文件为空或不包含 .bashrc 关键字，则添加
if ([string]::IsNullOrWhiteSpace($profileContent) -or $profileContent -notmatch '\.bashrc') {
    Add-Content -Path $bashProfile -Value 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi'
    Write-Host "已追加加载 .bashrc 的代码到 $bashProfile"
}

# 检测并创建 .bashrc
$bashRc = Join-Path $HOME ".bashrc"
if (-not (Test-Path $bashRc)) {
    New-Item -Path $bashRc -ItemType File -Force | Out-Null
    Write-Host "已创建 $bashRc"
}

# 检查 .bashrc 是否包含 .bash_aliases 关键字
$rcContent = Get-Content $bashRc -Raw -ErrorAction SilentlyContinue
# 如果文件为空或不包含 .bash_aliases 关键字，则添加
if ([string]::IsNullOrWhiteSpace($rcContent) -or $rcContent -notmatch '\.bash_aliases') {
    Add-Content -Path $bashRc -Value 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi'
    Add-Content -Path $bashRc -Value 'export PS1="\W > "'
    Write-Host "已追加加载 .bash_aliases 的代码到 $bashRc"
}

# 调用 Git Bash 执行 add_base_aliases.sh
$scriptToRun = Join-Path (Get-Location) "add_base_aliases.sh"

if (Test-Path $scriptToRun -PathType Leaf) {
    & "$gitBashPath" "$scriptToRun"
    Write-Host "已执行 $scriptToRun"
} else {
    Write-Host "错误：找不到 $scriptToRun"
}

pause