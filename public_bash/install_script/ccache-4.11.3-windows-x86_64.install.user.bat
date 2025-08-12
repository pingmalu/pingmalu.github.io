@echo off
setlocal enabledelayedexpansion

:: ѹ����·�����뱾�ű�ͬĿ¼��
set "ZIP_FILE=%~dp0ccache-4.11.3-windows-x86_64.zip"

:: ��ѹĿ��Ŀ¼
set "TARGET_DIR=C:\Tools\ccache"

:: ���Ŀ��Ŀ¼�Ƿ���ڣ��������򴴽�
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

echo ���ڽ�ѹ %ZIP_FILE% �� %TARGET_DIR% ...
powershell -command "Expand-Archive -Force '%ZIP_FILE%' '%TARGET_DIR%'"
if %errorlevel% neq 0 (
    echo ��ѹʧ�ܣ�����ѹ����·����
    pause
    exit /b 1
)

:: ��ȡ��ǰ�û� PATH
for /f "tokens=2* delims= " %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "OLD_PATH=%%B"

:: �����ǰ�û�û�� PATH ����������Ϊ��
if not defined OLD_PATH (
    set "OLD_PATH="
)

:: �ж�·���Ƿ��Ѿ��� PATH ��
echo !OLD_PATH! | find /i "%TARGET_DIR%" >nul
if %errorlevel% neq 0 (
    echo ���ڽ� %TARGET_DIR% ��ӵ���ǰ�û� PATH ...
    setx Path "!OLD_PATH!;%TARGET_DIR%\ccache-4.11.3-windows-x86_64"
    echo �����ɣ������´������д���ʹ����Ч��
) else (
    echo ��ǰ�û� PATH ���Ѵ��� %TARGET_DIR%��������ӡ�
)

echo ������ɡ�
pause
