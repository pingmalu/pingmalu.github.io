@echo off
setlocal enabledelayedexpansion

REM 检查 code 命令
where code >nul 2>nul
if errorlevel 1 (
    echo [错误] 未检测到 VSCode 的命令行工具 code.exe
    echo 请先在 VSCode 中启用命令行工具：
    echo   1. 打开 VSCode
    echo   2. 按 Ctrl+Shift+P
    echo   3. 输入 "Shell Command: Install 'code' command in PATH" 并回车
    pause
    exit /b
)

if not exist "vsix" (
    echo [错误] 目录 vsix 不存在，请确认当前目录下有 vsix 文件夹
    pause
    exit /b
)

for %%f in ("vsix\*.vsix") do (
    echo 正在安装插件: %%~nxf
    code --install-extension "%%~dpfnxf" --force
)

echo.
echo 所有 .vsix 插件安装完成！
pause
