@echo off
setlocal enabledelayedexpansion

:: 压缩包路径（与本脚本同目录）
set "ZIP_FILE=%~dp0ccache-4.11.3-windows-x86_64.zip"

:: 解压目标目录
set "TARGET_DIR=C:\Tools\ccache"

:: 检查目标目录是否存在，不存在则创建
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

echo 正在解压 %ZIP_FILE% 到 %TARGET_DIR% ...
powershell -command "Expand-Archive -Force '%ZIP_FILE%' '%TARGET_DIR%'"
if %errorlevel% neq 0 (
    echo 解压失败，请检查压缩包路径。
    pause
    exit /b 1
)

:: 获取当前用户 PATH
for /f "tokens=2* delims= " %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "OLD_PATH=%%B"

:: 如果当前用户没有 PATH 变量，先设为空
if not defined OLD_PATH (
    set "OLD_PATH="
)

:: 判断路径是否已经在 PATH 中
echo !OLD_PATH! | find /i "%TARGET_DIR%" >nul
if %errorlevel% neq 0 (
    echo 正在将 %TARGET_DIR% 添加到当前用户 PATH ...
    setx Path "!OLD_PATH!;%TARGET_DIR%\ccache-4.11.3-windows-x86_64"
    echo 添加完成，请重新打开命令行窗口使其生效。
) else (
    echo 当前用户 PATH 中已存在 %TARGET_DIR%，无需添加。
)

echo 操作完成。
pause
