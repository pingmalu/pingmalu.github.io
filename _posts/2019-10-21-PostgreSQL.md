---
layout: post
title: PostgreSQL
---

# 将Mysql数据库迁移至PostgreSQL

## 方法一.使用python工具 py-mysql2pgsql

项目地址：https://pypi.org/project/py-mysql2pgsql/

pip安装的时候如果遇到：
 _mysql.c(42) : fatal error C1083: Cannot open include file: 'config-win.h': No such file or directory

可以去安装 mysql-python 模块： http://www.codegood.com/archives/129

## 方法二.pgloader

项目地址：https://github.com/dimitri/pgloader

# MySQL与PostgreSQL语法差异

## LIMIT

PostgreSQL不支持 LIMIT ?,? 写法，不过可以用OFFSET代替（MySQL也兼容OFFSET）

比如：

  LIMIT #{offset} , #{pagesize}

可以写成：

  LIMIT #{pagesize} OFFSET #{offset}


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