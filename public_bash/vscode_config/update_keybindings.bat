@echo off
setlocal enabledelayedexpansion

:: --- 配置 ---
:: 要检查的应用程序子目录列表。如果目录名包含空格，请使用引号。
set "APP_DIRS=Code Cursor Trae "Trae CN" Void Windsurf"
:: keybindings.json 文件的下载 URL
set "KEYBINDINGS_URL=https://raw.githubusercontent.com/pingmalu/pingmalu.github.io/master/public_bash/vscode_config/keybindings.json"
:: --- 结束配置 ---

:: 获取当前脚本所在的目录
set "SCRIPT_DIR=%~dp0"
set "LOCAL_KEYBINDINGS_FILE=%SCRIPT_DIR%keybindings.json"
set "TARGET_FOUND=0"

echo [INFO] 开始检查目标目录...
echo.

:: 第一次遍历：检查是否存在任何一个目标目录
for %%G in (%APP_DIRS%) do (
    set "TARGET_DIR=%APPDATA%\%%~G\User"
    if exist "!TARGET_DIR!" (
        echo [FOUND] 发现存在的目标目录: "!TARGET_DIR!"
        set "TARGET_FOUND=1"
    )
)

echo.

:: 如果至少找到了一个目标目录，则继续执行
if %TARGET_FOUND% equ 1 (
    echo [INFO] 至少找到一个目标目录，开始处理 keybindings.json 文件。
    
    :: 检查本地 keybindings.json 文件是否存在
    if not exist "%LOCAL_KEYBINDINGS_FILE%" (
        echo [INFO] 脚本所在目录未找到 keybindings.json，准备从网络下载...
        :: 使用 curl 命令下载文件。curl 在新版 Windows 10/11 中已内置。
        curl -L -o "%LOCAL_KEYBINDINGS_FILE%" "%KEYBINDINGS_URL%"
        
        :: 检查下载是否成功
        if errorlevel 1 (
            echo [ERROR] 下载失败！请检查您的网络连接或确认URL是否有效。
            goto :cleanup
        ) else (
            echo [SUCCESS] 文件已成功下载到: "%LOCAL_KEYBINDINGS_FILE%"
        )
    ) else (
        echo [INFO] 在脚本目录中已找到本地 keybindings.json 文件。
    )
    
    echo.
    echo [INFO] 开始将 keybindings.json 复制到所有已发现的目标目录...
    echo.

    :: 第二次遍历：将文件复制到所有存在的目录中
    for %%G in (%APP_DIRS%) do (
        set "TARGET_DIR=%APPDATA%\%%~G\User"
        if exist "!TARGET_DIR!" (
            echo   正在复制到 "!TARGET_DIR!"
            copy /Y "%LOCAL_KEYBINDINGS_FILE%" "!TARGET_DIR!" >nul
        )
    )
    
    echo.
    echo [SUCCESS] 操作全部完成！

) else (
    echo [INFO] 未找到任何指定的目标目录，无需执行任何操作。
)

:cleanup
endlocal
echo.
pause