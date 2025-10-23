# �Զ����� Git Bash ·��
$gitBashPath = Get-Command bash.exe -ErrorAction SilentlyContinue | Where-Object {
    $_.Source -match "Git[\\/](bin|usr[\\/]bin)[\\/]bash\.exe$"
} | Select-Object -First 1 -ExpandProperty Source

if (-not $gitBashPath) {
    Write-Host "���棺δ�� PATH ���ҵ� Git Bash"
    
    # ���Ĭ�� Git ��װ·��
    $defaultGitBinPath = "C:\Program Files\Git\bin"
    $defaultGitBashExe = Join-Path $defaultGitBinPath "bash.exe"
    
    if (Test-Path $defaultGitBashExe) {
        Write-Host "��Ĭ��·���ҵ� Git Bash: $defaultGitBashExe"
        Write-Host "���ڽ� $defaultGitBinPath ��ӵ��û��������� PATH..."
        
        try {
            # ��ȡ��ǰ�û��� PATH ��������
            $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
            
            # ���·���Ƿ��Ѵ���
            if ($userPath -notlike "*$defaultGitBinPath*") {
                # �����·����ʹ�÷ֺŷָ���
                $newPath = if ($userPath) { "$userPath;$defaultGitBinPath" } else { $defaultGitBinPath }
                [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
                
                # ���µ�ǰ�Ự�� PATH
                $env:Path = "$env:Path;$defaultGitBinPath"
                
                Write-Host "�ѳɹ��� Git Bash ·����ӵ��û��������� PATH"
                $gitBashPath = $defaultGitBashExe
            } else {
                Write-Host "Git Bash ·���Ѵ������û� PATH ��"
                $gitBashPath = $defaultGitBashExe
            }
        } catch {
            Write-Host "�����޷��޸Ļ������� PATH - $_"
            pause
            exit 1
        }
    } else {
        Write-Host "����δ�ҵ� Git Bash����ȷ�� Git �Ѱ�װ�� $defaultGitBinPath"
        pause
        exit 1
    }
}

# ��Ⲣ���� .bash_profile
$bashProfile = Join-Path $HOME ".bash_profile"
if (-not (Test-Path $bashProfile)) {
    New-Item -Path $bashProfile -ItemType File -Force | Out-Null
    Write-Host "�Ѵ��� $bashProfile"
}

# ��� .bash_profile �Ƿ���� .bashrc �ؼ���
$profileContent = Get-Content $bashProfile -Raw -ErrorAction SilentlyContinue
# ����ļ�Ϊ�ջ򲻰��� .bashrc �ؼ��֣������
if ([string]::IsNullOrWhiteSpace($profileContent) -or $profileContent -notmatch '\.bashrc') {
    Add-Content -Path $bashProfile -Value 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi'
    Write-Host "��׷�Ӽ��� .bashrc �Ĵ��뵽 $bashProfile"
}

# ��Ⲣ���� .bashrc
$bashRc = Join-Path $HOME ".bashrc"
if (-not (Test-Path $bashRc)) {
    New-Item -Path $bashRc -ItemType File -Force | Out-Null
    Write-Host "�Ѵ��� $bashRc"
}

# ��� .bashrc �Ƿ���� .bash_aliases �ؼ���
$rcContent = Get-Content $bashRc -Raw -ErrorAction SilentlyContinue
# ����ļ�Ϊ�ջ򲻰��� .bash_aliases �ؼ��֣������
if ([string]::IsNullOrWhiteSpace($rcContent) -or $rcContent -notmatch '\.bash_aliases') {
    Add-Content -Path $bashRc -Value 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi'
    Add-Content -Path $bashRc -Value 'export PS1="\W > "'
    Write-Host "��׷�Ӽ��� .bash_aliases �Ĵ��뵽 $bashRc"
}

# ���� Git Bash ִ�� add_base_aliases.sh
$scriptToRun = Join-Path (Get-Location) "add_base_aliases.sh"

if (Test-Path $scriptToRun -PathType Leaf) {
    & "$gitBashPath" "$scriptToRun"
    Write-Host "��ִ�� $scriptToRun"
} else {
    Write-Host "�����Ҳ��� $scriptToRun"
}

pause