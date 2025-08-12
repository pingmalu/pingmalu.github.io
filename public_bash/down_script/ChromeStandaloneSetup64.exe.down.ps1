# 设置代理（如果不需要代理可以注释或删除下面一行）
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')


$downloadUrl = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BCEC27557-0338-A6BE-F10F-A625517C44BB%7D%26lang%3Dzh-CN%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeStandaloneSetup64.exe"
$outputFile = "ChromeStandaloneSetup64.exe"

Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile
Write-Host "下载完成：$outputFile"
