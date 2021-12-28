# MySQL基本的用法

## 增删改查基本

### 创建数据库

```
CREATE DATABASE 数据库名;
```

### 删除数据库
```
drop database <数据库名>;
```
### 创建表
```
CREATE TABLE table_name (column_name column_type);
  
create table if not exists Student (
  ID integer primary key autoincrement,
  Name varchar(128),
  Age integer,
  Class interger default 0,
  RegisterTime datetime,
  Money float default 0,
  Birthday date
);
```

### 删除表
 ```
 /// 删表: drop table 表名; drop table if exists 表名;
drop table t_student;
```

### 插入数据（insert）
```
/// 插入数据: insert into 表名 (字段1, 字段2, …) values (字段1的值, 字段2的值, …);
insert into t_student (name, age) values (‘张三’, 10);
```

### 更新数据（update）
```
/// update 表名 set 字段1 = 字段1的值, 字段2 = 字段2的值, … ;
update t_student set name = ‘jack’, age = 20;
```

### 删除数据（delete）
```
///delete from 表名;
    
// 删除指定ID值为2的记录
delete from t_student where ID=2; 
    
// 删除t_student表中所有的记录(慎重)
delete from t_student;
```

### 查询数据（select）
```
/// select 字段1, 字段2, … from 表名; select * from 表名;
select name, age from t_student ;
    
select * from t_student ;
```

## 查询进阶
###  条件查询 Where
```
SELECT field1, field2,...fieldN FROM table_name1, table_name2...  
[WHERE condition1 [AND [OR]] condition2.....
 
// 条件查询
select * from t_student where age > 10 ; 
```
    
###  条件查询 LIKE

LIKE 子句中使用百分号 %字符来表示任意字符，类似于UNIX或正则表达式中的星号 *。   如果没有使用百分号 %, LIKE 子句与等号 = 的效果是一样的
    
```
SELECT field1, field2,...fieldN FROM table_name
WHERE field1 LIKE condition1 [AND [OR]] filed2 = 'somevalue'
    
// 模糊查询
select * from t_student where name  like  '%张%' or phone like '130%';  
```
    
 like 匹配/模糊匹配，会与 % 和 _ 结合使用
```
'%a'     //以a结尾的数据
'a%'     //以a开头的数据
'%a%'    //含有a的数据
'_a_'    //三位且中间字母是a的
'_a'     //两位且结尾字母是a的
'a_'     //两位且开头字母是a的
```
    
### 查询表中有多少列
```
select count(*) from tableName;
```
### UNION 操作符

> MySQL UNION 操作符用于连接两个以上的 SELECT 语句的结果组合到一个结果集合中。多个 SELECT 语句会删除重复的数据。

UNION 语句：用于将不同表中相同列中查询的数据展示出来；（不包括重复数据）

UNION ALL 语句：用于将不同表中相同列中查询的数据展示出来；（包括重复数据）
    
 ```
SELECT 列名称 FROM 表名称 UNION SELECT 列名称 FROM 表名称 ORDER BY 列名称；
   
SELECT 列名称 FROM 表名称 UNION ALL SELECT 列名称 FROM 表名称 ORDER BY 列名称；
```

### 分页查询
> 用SELECT查询时，如果结果集数据量很大，比如几万行数据，放在一个页面显示的话数据量太大，不如分页显示，每次显示100条。要实现分页功能，实际上就是从结果集中显示第1~100条记录作为第1页，显示第101~200条记录作为第2页

```
SELECT ... FROM ... WHERE ... ORDER BY ... LIMIT ...

/// limit N : 返回 N 条记录
/// offset M : 跳过 M 条记录, 默认 M=0, 
/// limit N,M : 相当于 limit M offset N , 从第 N 条记录开始, 返回 M 条记录
select _column,_column from _table [limit N] [offset M]
```

我们把结果集分页，每页100条记录。

要获取第1页的记录，可以使用`LIMIT 100 OFFSET 0：`

如果要查询第2页，那么我们只需要“跳过”头100条记录，也就是对结果集从100条记录开始查询，把OFFSET设定为100：

```
select id, name, gender, score from students order by score desc limit 100 offset 3;
```

假设 numberperpage 表示每页要显示的条数，pagenumber表示页码，那么 返回第pagenumber页，每页条数为numberperpage的sql语句：
```
select * from student limit numberperpage offset (pagenumber - 1) * numberperpage
```



