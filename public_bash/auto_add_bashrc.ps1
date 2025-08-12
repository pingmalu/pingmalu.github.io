# �Զ����� Git Bash ·��
$gitBashPath = Get-Command bash.exe -ErrorAction SilentlyContinue | Where-Object {
    $_.Source -match "Git[\\/](bin|usr[\\/]bin)[\\/]bash\.exe$"
} | Select-Object -First 1 -ExpandProperty Source

if (-not $gitBashPath) {
    Write-Host "����δ�ҵ� Git Bash����ȷ�� Git �Ѱ�װ������ӵ� PATH"
    exit 1
}

# ��Ⲣ���� .bash_profile
$bashProfile = Join-Path $HOME ".bash_profile"
if (-not (Test-Path $bashProfile)) {
    New-Item -Path $bashProfile -ItemType File -Force | Out-Null
    Write-Host "�Ѵ��� $bashProfile"
}

# ��� .bash_profile �Ƿ���� .bashrc �ؼ���
$profileContent = Get-Content $bashProfile -Raw
if ($profileContent -notmatch '\.bashrc') {
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
$rcContent = Get-Content $bashRc -Raw
if ($rcContent -notmatch '\.bash_aliases') {
    Add-Content -Path $bashRc -Value 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi'
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