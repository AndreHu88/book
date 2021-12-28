# iOS文件及持久化

## iOS 文件目录

在iOS系统的安全机制，每个APP都有自己的文件目录，且只能访问自己的文件目录。该机制被称为沙盒机制。

[苹果官方文件系统编程指南--官网](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html)

**沙盒文件结构如下：**
![](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/art/ios_app_layout_2x.png)

- bundle container目录为APP程序的安装目录，在安装后为不可修改状态
- data container目录为APP数据存储目录，保存APP运行时需要的数据
- iCloud container目录为云存储目录，当APP需要iCloud云存储时可以进行访问

### data container目录
- Documents

    保存用户创建的文档文件的目录，用户可以通过文件分享分享该目录下的文件。在iTunes和iCloud备份时会备份该目录。建议保存你希望用户看得见的文件。
    
- Library
    
    苹果不建议在该目录下保存任何用户相关数据，而是保存APP运行需要的修改数据，当然用户可以根据自己的实际需要进行保存。
    
    - Cache
    
        建议保存数据缓存使用。在用户的磁盘空间已经使用完毕时有可能删除该目录下的文件，在APP使用期间不会删除，APP没有运行时系统有可能进行删除。需要持久化的数据建议不要保存在该目录下，以免系统强制删除。
    - Preferences
        
        用户偏好存储目录，在使用NSUserDefaults或者CFPreferences接口保存的数据保存在该目录下，编程人员不需要对该目录进行管理。在iTunes和iCloud备份时会备份该目录。
    
- tmp

    苹果建议该目录用来保存临时使用的数据，编程人员应该在数据长时间内不使用时主动删除该目录下的文件，在APP没有运行期间，系统可能删除该目录下的文件。在iTunes和iCloud备份时不会备份该目录。
    
### 代码获取目录路径
```
//沙盒根目录
NSString *homePath = NSHomeDirectory();

//document目录
NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

//library目录
NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;

//caches目录
NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;

//application support目录
NSString *applicationSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;

//preference目录
NSString *preferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;

//tem目录
NSString *temPath = NSTemporaryDirectory();
```


-------


## 持久化存储方式
- Plist，只存储数组、字典，但是数组和字典里不能有自定义对象。
- 偏好设置，也不能存储自定义对象。
- 归档NSCoding， 存储自定义对象。
- SQLite3
    - 操作数据比较快
    - 可以局部读取
    - 比较小型，占用的内存资源比较少
- Core Data
- Realm 移动数据库

### Plist

> 如果对是NSString、NSDictionary、NSArray、NSData、NSNumber等类型，就可以使用writeToFile:atomically:方法直接将对象写到属性列表文件中, plist是一种XML格式的文件

归档NSDictionary: 将一个NSDictionary对象归档到一个plist属性列表中
```
// 将数据封装成字典
NSMutableDictionary *dict = [NSMutableDictionary dictionary];
[dict setObject:@"张三" forKey:@"name"];
[dict setObject:@"155xxxxxxx" forKey:@"phone"];
[dict setObject:@"27" forKey:@"age"];
// 将字典持久化到Documents/stu.plist文件中
[dict writeToFile:path atomically:YES];
```

恢复NSDictionary: 读取plist，恢复NSDictionary对象
```
// 读取Documents/stu.plist的内容，实例化
NSDictionaryNSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
NSLog(@"name:%@", [dict objectForKey:@"name"]);
NSLog(@"phone:%@", [dict objectForKey:@"phone"]);
NSLog(@"age:%@", [dict objectForKey:@"age"]);
```

### 偏好设置

iOS提供了一套标准的解决方案来为应用加入偏好设置功能。
每个应用都有个NSUserDefaults实例，通过它来存取偏好设置。

比如，保存用户名等：
```
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
[defaults setObject:@"张三" forKey:@"username"];
[defaults setFloat:18.0f forKey:@"userAge"];
```

读取保存的设置:
```
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
NSString *username = [defaults stringForKey:@"username"];
float userAge = [defaults floatForKey:@"userAge"];
```

**注意：** UserDefaults设置数据时，不是立即写入，而是根据时间戳定时地把缓存中的数据写入本地磁盘。所以调用了set方法之后数据有可能还没有写入磁盘应用程序就终止了。出现以上问题，可以通过调用`synchornize`方法`[defaults synchornize];` 强制写入

### 归档(NSKeyedArchiver)
如果对象是 `NSString`、`NSDictionary`、`NSArray`、`NSData`、`NSNumber`等类型，可以直接用`NSKeyedArchiver`进行归档和恢复

不是所有的对象都可以直接用这种方法进行归档，只有遵守了`NSCoding`协议的对象才可以。

**NSCoding 协议有2个方法：**

- encodeWithCoder: 每次归档对象时，都会调用这个方法。一般在这个方法里面指定如何归档对象中的每个实例变量，可以使用encodeObject:forKey:方法归档实例变量。
- initWithCoder: 每次从文件中恢复(解码)对象时，都会调用这个方法。一般在这个方法里面指定如何解码文件中的数据为对象的实例变量，可以使用decodeObject:forKey方法解码实例变量。

**归档数组等Cocoa Object**
```
NSArray *array = [NSArray arrayWithObjects:@”a”,@”b”,nil];
[NSKeyedArchiver archiveRootObject:array toFile:path];
```

**归档自定义对象：UserModel 实现 NSCoding**：
```
@interface UserModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation UserModel

#pragma mark -  NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [super encodeWithCode: aCoder];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

@end
```

**归档方法**
```
[NSKeyedArchiver archiveRootObject:person toFile:path];
```

**解档方法**
```
UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
```

### SQLite3

> SQLite 是一款嵌入式的轻量关系型文件数据库。
它占用资源非常的低，在嵌入式设备中，可能只需要几百K的内存就够了。 它的处理速度比 Mysql、PostgreSQL 这两款著名的数据库都还快。

**数据库存储数据的步骤**
- 创建数据库(DB)
- 新建一张表（table）。
- 添加多个字段（column，列，属性）。
- 添加多行记录（row，每行存放多个字段对应的值）。

**推荐使用FMDB， FMDB以OC的方式封装了SQLite的C语言API**

**常用的SQL语句**

- 创建表
    ```
    create table t_student (id integer, name text, age inetger, score real);
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

- 删除表
     ```
     /// 删表: drop table 表名; drop table if exists 表名;
    drop table t_student;
    ```

- 插入数据（insert）
    ```
    /// 插入数据: insert into 表名 (字段1, 字段2, …) values (字段1的值, 字段2的值, …);
    insert into t_student (name, age) values (‘张三’, 10);
    ```

- 更新数据（update）
    ```
    /// update 表名 set 字段1 = 字段1的值, 字段2 = 字段2的值, … ;
    update t_student set name = ‘jack’, age = 20;
    ```

- 删除数据（delete）
    ```
    ///delete from 表名;
    
    // 删除指定ID值为2的记录
    delete from t_student where ID=2; 
    
    // 删除t_student表中所有的记录(慎重)
    delete from t_student;
    ```

- 查询数据（select）
    ```
    /// select 字段1, 字段2, … from 表名; select * from 表名;
    
    select name, age from t_student ;
    select * from t_student ;
    
    // 条件查询
    select * from t_student where age > 10 ; 
    
    // 模糊查询
    select * from t_student where name  like  '%张%' or phone like '%张%';  
    ```
    
### Realm

> Realm 移动数据库是一种新型的移动数据库，它是全新的,  Realm 移动数据库因此 和 SQLite 没有任何关系 也不是另外一个 SQL 数据库；它的目标就是去解决这些领域里面的已知问题。但是 Realm 移动数据库也 不是一个键-值存储 类型，这种存储类型在某些情况下非常棒，但是开发者真的很想直接和本地对象打交道。

> Realm 移动数据库 也不是一个 ORM。ORM 把 SQL 数据库的表结构中平的数据转换成了对象图，这样它们能被本地代码使用了。 Realm 的客制化存储引擎不需要把数据转换成对象图，所以它不需要 ORM

> Realm 数据库 直接存储对象 在磁盘上，当然需要最少的类型和结构的转换。英文它没有映射关系或者其它动态解读实体，Realm 移动数据库能够从内存到磁盘非常迅速地操作对象。

[Realm官网](https://academy.realm.io/cn/posts/realm-object-centric-present-day-database-mobile-applications/)