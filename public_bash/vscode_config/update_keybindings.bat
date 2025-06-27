@echo off
setlocal enabledelayedexpansion

:: --- Configuration ---
:: List of application subdirectories to check. Use quotes for directory names containing spaces.
set "APP_DIRS=Code Cursor Trae "Trae CN" Void Windsurf"
:: Download URL for keybindings.json file
set "KEYBINDINGS_URL=https://raw.githubusercontent.com/pingmalu/pingmalu.github.io/master/public_bash/vscode_config/keybindings.json"
:: --- End Configuration ---

:: Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "LOCAL_KEYBINDINGS_FILE=%SCRIPT_DIR%keybindings.json"
set "TARGET_FOUND=0"

echo [INFO] Starting target directory check...
echo.

:: First pass: Check if any target directory exists
for %%G in (%APP_DIRS%) do (
    set "TARGET_DIR=%APPDATA%\%%~G\User"
    if exist "!TARGET_DIR!" (
        echo [FOUND] Target directory found: "!TARGET_DIR!"
        set "TARGET_FOUND=1"
    )
)

echo.

:: If at least one target directory was found, proceed
if %TARGET_FOUND% equ 1 (
    echo [INFO] At least one target directory found, processing keybindings.json file...
    
    :: Check if local keybindings.json exists
    if not exist "%LOCAL_KEYBINDINGS_FILE%" (
        echo [INFO] keybindings.json not found in script directory, downloading from network...
        :: Use curl to download file (built-in for Windows 10/11)
        curl -L -o "%LOCAL_KEYBINDINGS_FILE%" "%KEYBINDINGS_URL%"
        
        :: Verify download success
        if errorlevel 1 (
            echo [ERROR] Download failed! Please check your network connection or verify the URL.
            goto :cleanup
        ) else (
            echo [SUCCESS] File successfully downloaded to: "%LOCAL_KEYBINDINGS_FILE%"
        )
    ) else (
        echo [INFO] Local keybindings.json file found in script directory.
    )
    
    echo.
    echo [INFO] Starting to copy keybindings.json to all found target directories...
    echo.

    :: Second pass: Copy file to all existing directories
    for %%G in (%APP_DIRS%) do (
        set "TARGET_DIR=%APPDATA%\%%~G\User"
        if exist "!TARGET_DIR!" (
            echo   Copying to "!TARGET_DIR!"
            copy /Y "%LOCAL_KEYBINDINGS_FILE%" "!TARGET_DIR!" >nul
        )
    )
    
    echo.
    echo [SUCCESS] All operations completed!

) else (
    echo [INFO] No target directories found, no action required.
)

:cleanup
endlocal
echo.
pause