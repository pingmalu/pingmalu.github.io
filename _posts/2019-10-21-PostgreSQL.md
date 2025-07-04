---
layout: post
title: PostgreSQL
---

# windows下使用PostgreSQL

## 可移植版本下载与安装

下载地址：[https://www.enterprisedb.com/downloads/postgres-postgresql-downloads](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)


### 一键安装脚本

```bat
@echo off
cd /d %TEMP%
setlocal enabledelayedexpansion

:: Configuration
set "INSTALL_DIR=D:\02_SOFT\pg\PGgreen"
set "DOWNLOAD_URL=https://get.enterprisedb.com/postgresql/postgresql-17.5-2-windows-x64-binaries.zip"
set "ZIP_FILE=postgresql-17.5-2-windows-x64-binaries.zip"

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this script as Administrator!
    pause
    exit /b
)

:: Create install directory if it doesn't exist
if not exist "%INSTALL_DIR%" (
    echo Creating directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

:: Skip download if ZIP file already exists
if exist "%TEMP%\%ZIP_FILE%" (
    echo File "%ZIP_FILE%" already exists in TEMP. Skipping download.
) else (
    echo Downloading PostgreSQL binaries...
    curl -L -o "%ZIP_FILE%" "%DOWNLOAD_URL%"
    if %errorLevel% neq 0 (
        echo Download failed! Please check your internet connection or the URL.
        pause
        exit /b
    )
)

:: Extract ZIP to target directory
where tar >nul 2>&1
if %errorLevel% equ 0 (
    echo Extracting using tar...
    tar -xf "%ZIP_FILE%" -C "%INSTALL_DIR%"
) else (
    where 7z >nul 2>&1
    if %errorLevel% equ 0 (
        echo Extracting using 7-Zip...
        7z x "%ZIP_FILE%" -o"%INSTALL_DIR%" -y
    ) else (
        echo Extracting using PowerShell...
        powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"
    )
)

:: Move contents of pgsql subfolder to main install directory
if exist "%INSTALL_DIR%\pgsql\" (
    echo Moving files from \pgsql to root of install directory...
    robocopy "%INSTALL_DIR%\pgsql" "%INSTALL_DIR%" /E /MOVE >nul

    :: Remove empty pgsql directory
    if exist "%INSTALL_DIR%\pgsql" (
        rmdir "%INSTALL_DIR%\pgsql"
    )
)

:: Clean up downloaded ZIP
:: del "%ZIP_FILE%"

:: Create helper scripts
echo Creating "start_pg.bat"...
(
    echo @echo off
    echo cd /d %%~dp0\bin
    echo .\pg_ctl.exe -D ../data -l ../logfile start
) > "%INSTALL_DIR%\start_pg.bat"

echo Creating "stop_pg.bat"...
(
    echo @echo off
    echo cd /d %%~dp0\bin
    echo .\pg_ctl.exe -D ../data stop
) > "%INSTALL_DIR%\stop_pg.bat"

echo Creating "register_service_admin.bat"...
(
    echo @echo off
    echo cd /d %%~dp0\bin
    echo .\pg_ctl.exe register -N "PGgreen" -D ../data -w
) > "%INSTALL_DIR%\register_service_admin.bat"

echo Creating "unregister_service_admin.bat"...
(
    echo @echo off
    echo cd /d %%~dp0\bin
    echo .\pg_ctl.exe unregister -N "PGgreen"
) > "%INSTALL_DIR%\unregister_service_admin.bat"

echo Creating "init_pg.bat"...
(
    echo @echo off
    echo cd /d %%~dp0\bin
    echo .\initdb.exe -D ..\data -U postgres -W --encoding=UTF8
) > "%INSTALL_DIR%\init_pg.bat"

echo PostgreSQL has been successfully set up in: %INSTALL_DIR%
pause

```

### 1. 传到到目录

如：C:\pg_green

### 2. 解压文件

将下载的压缩包解压到您选择的目录，例如：

```
D:\02_SOFT\pg\PGgreen
或
/data/PGgreen
```

### 3. 初始化数据库

打开命令行/终端，导航到 PostgreSQL 的 bin 目录，然后运行初始化命令：

```bash
# Windows
initdb.exe -D ..\data -U postgres -W --encoding=UTF8

# Linux/Mac
./initdb -D ../data -U postgres -W --encoding=UTF8
```

这将创建数据目录并设置初始配置。

## 4. 启动 PostgreSQL 服务

```bash
# Windows
pg_ctl.exe -D ..\data -l ..\logfile start

# Linux/Mac
./pg_ctl -D ../data -l ../logfile start
```

## 5. 连接到数据库

使用 psql 客户端连接：

```bash
# Windows
psql.exe -U postgres -d postgres

# Linux/Mac
./psql -U postgres -d postgres
```

## 6. 基本管理命令


停止服务：

```bash
pg_ctl -D ../data stop
```


```sql
-- 创建新数据库
CREATE DATABASE mydb;

-- 创建新用户
CREATE USER myuser WITH PASSWORD 'mypassword';

-- 这将允许 myuser 在 mydb 数据库中创建表
GRANT CREATE ON DATABASE mydb TO myuser;

-- 1. 创建用户
CREATE USER rwuser WITH PASSWORD 'mypassword';

-- 2. 授权连接数据库
GRANT CONNECT ON DATABASE mydb TO rwuser;

-- 3. 授权使用 schema
GRANT USAGE ON SCHEMA public TO rwuser;

-- 4. 授权数据操作 (去指定数据库下)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO rwuser;
--授权 public schema 下所有序列权限 (插入时自增序列需要)
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO rwuser;

-- 5. 设置 future tables 权限 (去指定数据库下)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO rwuser;
--保证以后新建的序列也自动授权：
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO rwuser;

```

## 高级配置

如果需要远程访问或更改端口等配置，可以编辑数据目录中的 postgresql.conf 和 pg_hba.conf 文件。


在TARGET_DIR目录下创建名为 启动PG.bat 停止PG.bat 注册服务-管理员权限.bat 卸载服务-管理员权限.bat 对应脚本

## 启动PG

```bat
:: @echo off
cd /d %~dp0/bin
.\pg_ctl.exe -D ../data -l ../logfile start
```

## 停止PG

```bat
:: @echo off
cd /d %~dp0/bin
.\pg_ctl.exe -D ../data stop
```

## 注册服务-管理员权限

```bat
:: @echo off
cd /d %~dp0/bin
.\pg_ctl.exe register -N "PGgreen" -D ../data -w
```

## 卸载服务-管理员权限

```bat
:: @echo off
cd /d %~dp0/bin
.\pg_ctl.exe unregister -N "PGgreen"
```

### 启动停止服务

```bat
net start PGgreen
net stop PGgreen
```

### 在 postgresql.conf 中配置日志

编辑数据目录中的 postgresql.conf 文件

设置以下参数：

```conf
listen_addresses = '0.0.0.0'
port = 5433
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
```




# 将Mysql数据库迁移至PostgreSQL

## 简单的方法：使用Navicat Premium复制功能

选中源表名-右击复制-到新库里粘贴

## 方法一.使用python工具 py-mysql2pgsql(python3下不支持)

项目地址：https://pypi.org/project/py-mysql2pgsql/

pip安装的时候如果遇到：
 _mysql.c(42) : fatal error C1083: Cannot open include file: 'config-win.h': No such file or directory

可以去安装 mysql-python 模块： http://www.codegood.com/archives/129

## 方法二.pgloader(推荐用该命令)

项目地址：[https://github.com/dimitri/pgloader](https://github.com/dimitri/pgloader)

1.安装：

```
apt install pgloader
```

2.创建迁移配置文件 mysql_to_pgsql.load

```
LOAD DATABASE
        FROM mysql://username@192.168.50.1:3306/xxl_job
        INTO postgresql://server?sslmode=allow
        WITH include drop, create tables, create indexes, workers = 8, concurrency = 1
ALTER SCHEMA 'xxl_job' RENAME TO 'public';
```

3.执行配置文件

```
pgloader -v --no-ssl-cert-verification mysql_to_pgsql.load
```

4.也可以单个命令中执行

```
pgloader mysql://user@localhost/sakila postgresql:///pagila?sslmode=allow
```


# MySQL与PostgreSQL语法差异

## LIMIT

PostgreSQL不支持 LIMIT ?,? 写法，不过可以用OFFSET代替（MySQL也兼容OFFSET）

比如：

```
LIMIT #{offset} , #{pagesize}
```

可以写成：

```
LIMIT #{pagesize} OFFSET #{offset}
```

## DATE_ADD

PostgreSQL不支持DATE_ADD写法，使用timestamp代替

比如：

```
DATE_ADD(#{nowTime},INTERVAL -#{timeout} SECOND)
```

改成：

```
timestamp '${nowTime}'::timestamp + interval '-${timeout}) sec'
```

# PostgreSQL设置自增auto_increment

PostgreSQL无法像MySQL一样设置自增id，可以通过计数器来实现：

```sql
-- 创建该的计数器sequence
CREATE SEQUENCE seq_test_id;
-- 设置 sequence 的开始值
SELECT setval('seq_test_id', 20);
-- 设置id的值，从计数器获取
ALTER TABLE "public".test ALTER COLUMN id SET DEFAULT nextval('seq_test_id');
```

查看计数器最大值：

```sql
SELECT setval('seq_test_id', max(id)) FROM m_md;
```

注意：id需要去除主键

### 显示创建表结构，实现类似 SHOW CREATE TABLE 语句

PostgreSQL无法像MySQL一样SHOW CREATE TABLE，可以通过函数来实现：

```sql
-- ----------------------------
-- Function structure for generate_create_table_statement
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."generate_create_table_statement"("p_table_name" varchar);
CREATE OR REPLACE FUNCTION "public"."generate_create_table_statement"("p_table_name" varchar)
  RETURNS "pg_catalog"."text" AS $BODY$
DECLARE
    v_table_ddl   text;
    column_record record;
BEGIN
    FOR column_record IN 
        SELECT 
            b.nspname as schema_name,
            b.relname as table_name,
            a.attname as column_name,
            pg_catalog.format_type(a.atttypid, a.atttypmod) as column_type,
            CASE WHEN 
                (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                 FROM pg_catalog.pg_attrdef d
                 WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) IS NOT NULL THEN
                'DEFAULT '|| (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                              FROM pg_catalog.pg_attrdef d
                              WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef)
            ELSE
                ''
            END as column_default_value,
            CASE WHEN a.attnotnull = true THEN 
                'NOT NULL'
            ELSE
                'NULL'
            END as column_not_null,
            a.attnum as attnum,
            e.max_attnum as max_attnum
        FROM 
            pg_catalog.pg_attribute a
            INNER JOIN 
             (SELECT c.oid,
                n.nspname,
                c.relname
              FROM pg_catalog.pg_class c
                   LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
              WHERE c.relname ~ ('^('||p_table_name||')$')
                AND pg_catalog.pg_table_is_visible(c.oid)
              ORDER BY 2, 3) b
            ON a.attrelid = b.oid
            INNER JOIN 
             (SELECT 
                  a.attrelid,
                  max(a.attnum) as max_attnum
              FROM pg_catalog.pg_attribute a
              WHERE a.attnum > 0 
                AND NOT a.attisdropped
              GROUP BY a.attrelid) e
            ON a.attrelid=e.attrelid
        WHERE a.attnum > 0 
          AND NOT a.attisdropped
        ORDER BY a.attnum
    LOOP
        IF column_record.attnum = 1 THEN
            v_table_ddl:='CREATE TABLE '||column_record.schema_name||'.'||column_record.table_name||' (';
        ELSE
            v_table_ddl:=v_table_ddl||',';
        END IF;

        IF column_record.attnum <= column_record.max_attnum THEN
            v_table_ddl:=v_table_ddl||chr(10)||
                     '    '||column_record.column_name||' '||column_record.column_type||' '||column_record.column_default_value||' '||column_record.column_not_null;
        END IF;
    END LOOP;

    v_table_ddl:=v_table_ddl||');';
    RETURN v_table_ddl;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
```

使用方法：

```sql
SELECT generate_create_table_statement('table_name');
```