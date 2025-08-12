# �������� VS Code ��չ VSIX�����°汾��
# ���Ŀ¼����ǰĿ¼�µ� "vsix" �ļ���
# ### ��ѯ VSCode ���������ʽ�汾����Ԥ������
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
Write-Host "[*] ����׼������ VSIX�������浽 .\vsix\��..." -ForegroundColor Cyan
Write-Host ""

# ��������ɾ��չ ID��publisher.extensionName��
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

# ���ô����������Ҫ�������ע�ͻ�ɾ������һ�У�
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')

# ȷ��ʹ�� TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ���Ŀ¼
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
        throw "�޷���ȡ��չ��Ϣ: $id"
    }
    # Write-Host "$ext.versions[0]"


    # ���� $ext.versions
    foreach ($version in $ext.versions) {
        # ��� properties �Ƿ�����ض��ṹ
        $hasPreRelease = $false
        foreach ($property in $version.properties) {
            if ($property.key -eq "Microsoft.VisualStudio.Code.PreRelease" -and $property.value -eq "true") {
                $hasPreRelease = $true
                break
            }
        }
        
        # ���û���ҵ�����ṹ�����ض�Ӧ�� version
        if (-not $hasPreRelease) {
            return $version.version
        }
    }

    # ������а汾�������ýṹ������ null ������Ĭ��ֵ
    return $null

    # �������°汾��
    # return $ext.versions[0].version
}

foreach ($id in $extIds) {
    $parts = $id -split '\.', 2
    if ($parts.Length -ne 2) {
        Write-Host "[!] ��չ ID ��Ч: $id" -ForegroundColor Yellow
        continue
    }
    $publisher = $parts[0]
    $name = $parts[1]

    try {
        $version = Get-LatestVersion $id
    } catch {
        Write-Host "[x] ��ȡ�汾ʧ��: $id -> $_" -ForegroundColor Red
        continue
    }

    $url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$version/vspackage"
    Write-Host "[URL] $url" -ForegroundColor Yellow

    $file = Join-Path $outDir "$id-$version.vsix"
    if (-not (Test-Path $file)) {
        try {
            Write-Host "[*] �������� $id (v$version) ..." -ForegroundColor Cyan
            Invoke-RestMethod -Uri $url -OutFile $file
            Write-Host "[?] �ѱ���: $file" -ForegroundColor Green
        } catch {
            Write-Host "[x] ����ʧ�� $id -> $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[����] �ļ��Ѵ���: $file" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "[���] ���������ѽ�����VSIX �ļ�λ��: $(Resolve-Path $outDir)" -ForegroundColor Green

# �ȴ��û�����
Write-Host ""
Write-Host "��������˳�..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
