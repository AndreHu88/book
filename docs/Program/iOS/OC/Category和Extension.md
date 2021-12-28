# Category和Extension

##  简介
Category（分类/类别） 是 OC 的语言特性，主要作用是为已经存在的类添加方法。Category 可以做到在既不子类化，也不侵入一个类的源码的情况下，为原有的类添加新的方法，从而实现扩展一个类或者分离一个类的目的。在日常开发中我们常常使用 Category 为已有的类扩展功能。

虽然继承也能为已有类增加新的方法，而且还能直接增加属性，但继承关系增加了不必要的代码复杂度，在运行时，也无法与父类的原始方法进行区分。所以我们可以优先考虑使用自定义 Category（分类）

## 应用场景

### Category
Category的主要作用是为已经存在的类添加方法，除此之外还有其它的使用场景

1. 可以把类的实现分开在几个不同的文件里面。这样做有几个显而易见的好处，
    - 可以减少单个文件的体积 
    - 可以把不同的功能组织到不同的category里 
    - 可以由多个开发者共同完成一个类 
    - 可以按需加载想要的category 等等。
2. 声明私有方法
3. 模拟多继承
4. 把framework的私有方法公开

### Category的用法

- Category的小括号内一定要有名字

```
#import 
@interface NSObject (Category)

- (void)myMethod;

@end

```

### Extension

Extension作用:
- 能为某个类添加成员变量,属性,方法;
- 一般的类扩展写到.m文件中;
- 一般的私有属性写到类扩展中

```
@interface ViewController ()   <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

@end

```

## Category和Extension的区别

Category（分类）看起来和 Extension（扩展）有点相似。Extension（扩展）有时候也被称为 匿名分类。但两者实质上是不同的东西。

Extension（扩展）是在编译阶段与该类同时编译的，是类的一部分。而且 Extension（扩展）中声明的方法只能在该类的`@implementation` 中实现，这也就意味着，你无法对系统的类使用 Extension（扩展）


- Category是运行时决定生效的，Extension是编译时就决定生效的
- Category可以为系统类添加分类，Extension不能
- Category是有声明和实现，Extension直接写在宿主.m文件，只有声明
- Category只能扩充方法，不能扩充成员变量和属性
- 如果Category声明了声明了一个属性,那么Category只会生成这个属性的set,get方法的声明,也就不是会实现

## 为什么Category不能像Extension一样添加成员变量

因为 Extension（扩展）是在编译阶段与该类同时编译的，就是类的一部分。既然作为类的一部分，且与类同时编译，那么就可以在编译阶段为类添加成员变量。

而 Category（分类）不同， Category（分类）的特性是：可以在运行时阶段动态地为已有类添加新行为。 Category（分类）是在运行时期间决定的。而成员变量的内存布局已经在编译阶段确定好了，如果在运行时阶段添加成员变量的话，就会破坏原有类的内存布局，从而造成可怕的后果，所以 Category（分类）无法添加成员变量


## Category的原理

所有的OC类和对象，在runtime层都是用struct表示的，category也是，在runtime层，category用结构体category_t（在objc-runtime-new.h中可以找到此定义），它包含了

```
typedef struct category_t *Category;

struct category_t {
    const char *name;                                // 类名
    classref_t cls;                                  // 类，在运行时阶段通过 clasee_name（类名）对应到类对象
    struct method_list_t *instanceMethods;           // Category 中所有添加的对象方法列表
    struct method_list_t *classMethods;              // Category 中所有添加的类方法列表
    struct protocol_list_t *protocols;               // Category 中实现的所有协议列表
    struct property_list_t *instanceProperties;      // Category 中添加的所有属性
};
```


