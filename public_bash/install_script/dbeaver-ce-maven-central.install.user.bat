@echo off
setlocal

REM 定义目标路径
set "TARGET=%USERPROFILE%\AppData\Roaming\DBeaverData\drivers\maven"

REM 检查 dbeaver-ce-maven-central.zip 是否存在
if not exist "dbeaver-ce-maven-central.zip" (
    echo 未找到 dbeaver-ce-maven-central.zip，请确认该文件在当前目录下。
    pause
    exit /b 1
)

REM 创建目标目录（如果不存在）
if not exist "%TARGET%" (
    echo 创建目录 %TARGET%
    mkdir "%TARGET%"
)

REM 解压并覆盖
echo 正在解压 dbeaver-ce-maven-central.zip 到 %TARGET%...
powershell -command "Expand-Archive -LiteralPath 'dbeaver-ce-maven-central.zip' -DestinationPath '%TARGET%' -Force"

echo 解压完成！
pause
endlocal
