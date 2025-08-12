# Force TLS 1.2 to avoid connection errors
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy('http://172.16.1.201:1081')

# Fetch the content of the 7-Zip download page
$response = Invoke-WebRequest -Uri "https://www.7-zip.org/"

# Define the regex pattern to find the latest 7z*-x64.exe relative link
$pattern = 'href="a\/7z[\d]+-x64\.exe"'
$match = [regex]::Match($response.Content, $pattern)

if ($match.Success) {
    # Extract the relative path and build the full URL
    $relativePath = $match.Value -replace 'href="', '' -replace '"', ''
    $url = "https://www.7-zip.org/$relativePath"
    $filename = Split-Path $url -Leaf

    # Check if the file already exists in the current directory
    if (Test-Path ".\$filename") {
        Write-Output "File already exists: $filename. Skipping download."
    } else {
        Write-Output "Downloading: $filename"
        Invoke-WebRequest -Uri $url -OutFile ".\$filename"
        Write-Output "Download completed."
    }
} else {
    Write-Output "Download link not found."
}

pause