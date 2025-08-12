@echo off
setlocal

REM ����Ŀ��·��
set "TARGET=%USERPROFILE%\AppData\Roaming\DBeaverData\drivers\maven"

REM ��� dbeaver-ce-maven-central.zip �Ƿ����
if not exist "dbeaver-ce-maven-central.zip" (
    echo δ�ҵ� dbeaver-ce-maven-central.zip����ȷ�ϸ��ļ��ڵ�ǰĿ¼�¡�
    pause
    exit /b 1
)

REM ����Ŀ��Ŀ¼����������ڣ�
if not exist "%TARGET%" (
    echo ����Ŀ¼ %TARGET%
    mkdir "%TARGET%"
)

REM ��ѹ������
echo ���ڽ�ѹ dbeaver-ce-maven-central.zip �� %TARGET%...
powershell -command "Expand-Archive -LiteralPath 'dbeaver-ce-maven-central.zip' -DestinationPath '%TARGET%' -Force"

echo ��ѹ��ɣ�
pause
endlocal
