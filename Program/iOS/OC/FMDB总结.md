# FMDB总结

## 打开数据库
根据path打开数据库
```
// 1..创建数据库对象
FMDatabase *db = [FMDatabase databaseWithPath:path];
// 2.打开数据库
if ([db open]) {
    // do something
} 
else {
    NSLog(@"fail to open database");
}
```

文件路径有三种
- 路径不存在

  > 会自动创建
- 空字符串 @""

  > 会在临时目录创建一个空的数据库，当FMDatabase连接关闭时，数据库文件也被删除
  
- nil

  > 会创建一个内存中临时数据库，当FMDatabase连接关闭时，数据库会被销毁
  
## 数据库操作

### 查询
### 更新

在FMDB中，除查询以外的所有操作，都称为“更新”

- create
- drop
- insert
- update
- delete

#### 创建表

```
NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL)";
[db executeUpdate:createTableSqlString];
```

#### 写入数据
```
NSString *sql = @"insert into t_student (name, age) values (?, ?)";
NSString *name = [NSString stringWithFormat:@"Jack - %d",arc4random()];
NSNumber *age = [NSNumber numberWithInt:arc4random_uniform(100)];
[db executeUpdate:sql, name, age];
```

#### 删除数据
```
// 删除数据
NSString *sql = @"delete from t_student where id = ?";
[db executeUpdate:sql, [NSNumber numberWithInt:1]];
```

#### 更改数据
```
// 更改数据
NSString *sql = @"update t_student set name = 'Tom'  where id = ?";
[db executeUpdate:sql, [NSNumber numberWithInt:2]];
```