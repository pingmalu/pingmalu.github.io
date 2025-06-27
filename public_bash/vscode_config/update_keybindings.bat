@echo off
setlocal enabledelayedexpansion

:: --- ���� ---
:: Ҫ����Ӧ�ó�����Ŀ¼�б����Ŀ¼�������ո���ʹ�����š�
set "APP_DIRS=Code Cursor Trae "Trae CN" Void Windsurf"
:: keybindings.json �ļ������� URL
set "KEYBINDINGS_URL=https://raw.githubusercontent.com/pingmalu/pingmalu.github.io/master/public_bash/vscode_config/keybindings.json"
:: --- �������� ---

:: ��ȡ��ǰ�ű����ڵ�Ŀ¼
set "SCRIPT_DIR=%~dp0"
set "LOCAL_KEYBINDINGS_FILE=%SCRIPT_DIR%keybindings.json"
set "TARGET_FOUND=0"

echo [INFO] ��ʼ���Ŀ��Ŀ¼...
echo.

:: ��һ�α���������Ƿ�����κ�һ��Ŀ��Ŀ¼
for %%G in (%APP_DIRS%) do (
    set "TARGET_DIR=%APPDATA%\%%~G\User"
    if exist "!TARGET_DIR!" (
        echo [FOUND] ���ִ��ڵ�Ŀ��Ŀ¼: "!TARGET_DIR!"
        set "TARGET_FOUND=1"
    )
)

echo.

:: ��������ҵ���һ��Ŀ��Ŀ¼�������ִ��
if %TARGET_FOUND% equ 1 (
    echo [INFO] �����ҵ�һ��Ŀ��Ŀ¼����ʼ���� keybindings.json �ļ���
    
    :: ��鱾�� keybindings.json �ļ��Ƿ����
    if not exist "%LOCAL_KEYBINDINGS_FILE%" (
        echo [INFO] �ű�����Ŀ¼δ�ҵ� keybindings.json��׼������������...
        :: ʹ�� curl ���������ļ���curl ���°� Windows 10/11 �������á�
        curl -L -o "%LOCAL_KEYBINDINGS_FILE%" "%KEYBINDINGS_URL%"
        
        :: ��������Ƿ�ɹ�
        if errorlevel 1 (
            echo [ERROR] ����ʧ�ܣ����������������ӻ�ȷ��URL�Ƿ���Ч��
            goto :cleanup
        ) else (
            echo [SUCCESS] �ļ��ѳɹ����ص�: "%LOCAL_KEYBINDINGS_FILE%"
        )
    ) else (
        echo [INFO] �ڽű�Ŀ¼�����ҵ����� keybindings.json �ļ���
    )
    
    echo.
    echo [INFO] ��ʼ�� keybindings.json ���Ƶ������ѷ��ֵ�Ŀ��Ŀ¼...
    echo.

    :: �ڶ��α��������ļ����Ƶ����д��ڵ�Ŀ¼��
    for %%G in (%APP_DIRS%) do (
        set "TARGET_DIR=%APPDATA%\%%~G\User"
        if exist "!TARGET_DIR!" (
            echo   ���ڸ��Ƶ� "!TARGET_DIR!"
            copy /Y "%LOCAL_KEYBINDINGS_FILE%" "!TARGET_DIR!" >nul
        )
    )
    
    echo.
    echo [SUCCESS] ����ȫ����ɣ�

) else (
    echo [INFO] δ�ҵ��κ�ָ����Ŀ��Ŀ¼������ִ���κβ�����
)

:cleanup
endlocal
echo.
pause