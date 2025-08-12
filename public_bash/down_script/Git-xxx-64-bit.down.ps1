# Fetch the content of the download page
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')

$response = Invoke-WebRequest -Uri "https://git-scm.com/downloads/win"

# Extract the download link for the latest Git-xxx-64-bit.exe
$pattern = 'https:\/\/github\.com\/[^"]*Git-[\d\.]+-64-bit\.exe'
$match = [regex]::Match($response.Content, $pattern)

if ($match.Success) {
    $url = $match.Value
    $filename = Split-Path $url -Leaf

    # Check if the file already exists in the current directory
    if (Test-Path ".\$filename") {
        Write-Output "File already exists: $filename. Skipping download."
    } else {
        Write-Output "Downloading: $filename"
        Write-Output "Url: $url"
        Invoke-WebRequest -Uri $url -OutFile ".\$filename"
        Write-Output "Download completed."
    }
} else {
    Write-Output "Download link not found."
}

pause