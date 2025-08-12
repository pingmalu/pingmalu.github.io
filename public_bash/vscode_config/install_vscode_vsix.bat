@echo off
setlocal enabledelayedexpansion

REM ��� code ����
where code >nul 2>nul
if errorlevel 1 (
    echo [����] δ��⵽ VSCode �������й��� code.exe
    echo ������ VSCode �����������й��ߣ�
    echo   1. �� VSCode
    echo   2. �� Ctrl+Shift+P
    echo   3. ���� "Shell Command: Install 'code' command in PATH" ���س�
    pause
    exit /b
)

if not exist "vsix" (
    echo [����] Ŀ¼ vsix �����ڣ���ȷ�ϵ�ǰĿ¼���� vsix �ļ���
    pause
    exit /b
)

for %%f in ("vsix\*.vsix") do (
    echo ���ڰ�װ���: %%~nxf
    code --install-extension "%%~dpfnxf" --force
)

echo.
echo ���� .vsix �����װ��ɣ�
pause
