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

if not exist "vsix_pre" (
    echo [����] Ŀ¼ vsix_pre �����ڣ���ȷ�ϵ�ǰĿ¼���� vsix_pre �ļ���
    pause
    exit /b
)

for %%f in ("vsix_pre\*.vsix") do (
    echo ���ڰ�װ���: %%~nxf
    code --install-extension "%%~dpfnxf"
)

echo.
echo ���� .vsix �����װ��ɣ�
pause
