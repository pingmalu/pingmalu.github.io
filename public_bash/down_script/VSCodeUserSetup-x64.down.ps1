param(
  [ValidateSet('auto','x64','arm64')]
  [string]$Arch = 'auto',

  [ValidateSet('user','system','zip')]
  [string]$Installer = 'user',

  [string]$OutDir = '.',

  [switch]$NoProgress
)

# ���ô����������Ҫ�������ע�ͻ�ɾ������һ�У�
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')


# 1) ���� TLS1.2������ĳЩ��������ʧ��
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2) �Զ����ܹ�
if ($Arch -eq 'auto') {
  $isArm = $false
  try {
    $isArm = $env:PROCESSOR_ARCHITECTURE -match 'ARM64'
  } catch {}
  $Arch = if ($isArm) { 'arm64' } else { 'x64' }
}

# 3) ѡ�� VS Code ����ͨ�����ȶ��棩��Ŀ�������
#    user   -> �������ԱȨ�޵��û���װ��
#    system -> ��Ҫ����ԱȨ�޵�ϵͳ��װ��
#    zip    -> �ⰲװ ZIP ��
switch ($Installer) {
  'user'   { $osSlug = "win32-$Arch-user"; $ext = 'exe' }
  'system' { $osSlug = "win32-$Arch";      $ext = 'exe' }
  'zip'    { $osSlug = "win32-$Arch-zip";  $ext = 'zip' }
}

$downloadUrl = "https://code.visualstudio.com/sha/download?build=stable&os=$osSlug"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

# 4) ����ļ������ɰ���ĳɴ�ʱ���/�汾�ţ�
# $outFile = Join-Path $OutDir ("VSCode-$Installer-$Arch.$ext")

# 4) �������޸ġ�ͨ�����������ȡ������������ļ���
Write-Host "���ڻ�ȡ������Ϣ..."
try {
    $response = Invoke-WebRequest -Uri $downloadUrl -Method Head -UseBasicParsing
    
    $contentDisposition = $response.Headers['Content-Disposition']
    $serverFileName = '' # ��ʼ������

    # ���ȴ� Content-Disposition ��Ӧͷ�н����ļ���
    # ʹ�ø���׳��������ʽ��ֻƥ�� filename="..." �� filename=... ��ֵ
    if ($contentDisposition -and $contentDisposition -match 'filename\*?="?([^"]+)"?') {
        $serverFileName = $Matches[1]
    } else {
        # ����޷��� Header ��ȡ�����Դ����յ��ض��� URL �н���
        $serverFileName = [System.IO.Path]::GetFileName($response.BaseResponse.ResponseUri.LocalPath)
    }

    # ���ؼ��޸��������ļ������Ƴ��ֺż���֮����������ݣ����޼����ߵ����źͿո�
    if ($serverFileName) {
        $serverFileName = $serverFileName.Split(';')[0].Trim('" ')
    }

    if (-not $serverFileName) {
        throw "�޷��ӷ�������Ӧ��ȷ���ļ�����"
    }

    $outFile = Join-Path $OutDir $serverFileName

} catch {
    Write-Error "��ȡ������Ϣʧ��: $($_.Exception.Message)"
    pause # �ڳ���ʱ��ͣ������鿴������Ϣ
    exit 1
}


# ========= �������ж��ļ��Ƿ��Ѵ��� =========
if (Test-Path $outFile) {
    Write-Host "�ļ��Ѵ��ڣ���������: $outFile"
    pause
    exit 0
}
# ==========================================

# 5) ��ѡ���رս�������������������
if ($NoProgress) { $global:ProgressPreference = 'SilentlyContinue' }

Write-Host "��ʼ���� VS Code ($Installer, $Arch) ..."
Write-Host "URL: $downloadUrl"
Write-Host "���浽: $outFile"

try {
  Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile
  Write-Host "�������: $outFile"
} catch {
  Write-Error "����ʧ�ܣ�$($_.Exception.Message)"
  exit 1
}


pause