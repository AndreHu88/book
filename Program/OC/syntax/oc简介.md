# Objective-C简介

Objective-C是一种通用、高级、面向对象的编程语言。它扩展了标准的ANSI C编程语言，将Smalltalk式的消息传递机制加入到ANSI C中。目前主要支持的编译器有GCC和Clang（采用LLVM作为后端)

## 特性
具有面向对象的语言特性
* 封装
* 继承
* 多态

具有相当多的动态特性
* 动态类型（Dynamic typing）
* 动态绑定（Dynamic binding）
* 动态加载（Dynamic loding）

## 语法
在Objective-C中使用C语言代码也是完全合法的。Objective-C被描述为盖在C语言上的薄薄一层，因为Objective-C的原意就是在C语言主体上加入面向对象的特性。Objective-C的面向对象语法源于Smalltalk消息传递风格。所有其他非面向对象的语法，包括变量类型，预处理器（preprocessing），流程控制，函数声明与调用皆与C语言完全一致。但有些C语言语法合法代码在objective-c中表达的意思不一定相同，比如某些布尔表达式，在C语言中返回值为true，但在Objective-C若与true直接相比较，函数将会出错，因为在Objective-C中true的值只表示为1.

### Hello World

```
#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {

    @autoreleasepool {
        NSLog(@"Hello World!");
    }

   return 0;
}
```

### 消息传递
Objective-C最大的特色是承自Smalltalk的消息传递模型（message passing），此机制与今日C++式之主流风格差异甚大。Objective-C里，与其说对象互相调用方法，不如说对象之间互相传递消息更为精确。此二种风格的主要差异在于调用方法/消息传递这个动作。C++里类别与方法的关系严格清楚，一个方法必定属于一个类别，而且在编译时（compile time）就已经紧密绑定，不可能调用一个不存在类别里的方法。但在Objective-C，类别与消息的关系比较松散，调用方法视为对对象发送消息，所有方法都被视为对消息的回应。所有消息处理直到执行时（runtime）才会动态决定，并交由类别自行决定如何处理收到的消息。也就是说，一个类别不保证一定会回应收到的消息，如果类别收到了一个无法处理的消息，程序只会抛出异常，不会出错或崩溃。

C++里，送一个消息给对象（或者说调用一个方法）的语法如下：

`obj.method(argument);`

Objective-C则写成：

`[obj method: argument];`

此二者并不仅仅是语法上的差异，还有基本行为上的不同。

这里以一个汽车类（car class）的简单例子来解释Objective-C的消息传递特性：

`[car fly];`

### 类的定义与实现
Objective-C中强制要求将类的接口（interface）与实现（implementation）分为两个部分。

类的定义文件遵循C语言之惯例以.h为后缀，实现文件以.m为后缀。

**接口**
定义部分，清楚定义了类的名称、成员变量和方法。 以关键字@interface作为开始，@end作为结束。

```
@interface MyObject : NSObject {
    int memberVar1; // 实体变量
    id  memberVar2;
}

+(return_type) class_method; // 类方法

-(return_type) instance_method1; // 实例方法
-(return_type) instance_method2: (int) p1;
-(return_type) instance_method3: (int) p1 andPar: (int) p2;
@end
```

方法前面的 +/- 号代表函数的类型：加号（+）代表类方法（class method），不需要实例就可以调用，与C++ 的静态函数（static member function）相似。减号（-）即是一般的实例方法（instance method）。

Objective-C定义一个新的方法时，名称内的冒号（:）代表参数传递，不同于C语言以数学函数的括号来传递参数。Objective-C方法使得参数可以夹杂于名称中间，不必全部附缀于方法名称的尾端，可以提高程序可读性。设定颜色RGB值的方法为例：

```
- (void) setColorToRed: (float)red Green: (float)green Blue:(float)blue; /* 宣告方法*/

[myColor setColorToRed: 1.0 Green: 0.8 Blue: 0.2]; /* 呼叫方法*/
```
这个方法的签名是setColorToRed:Green:Blue:。每个冒号后面都带着一个float类别的参数，分别代表红，绿，蓝三色。

**实现**
实现区段则包含了公开方法的实现，以及定义私有（private）变量及方法。 以关键字@implementation作为区段起头，@end结尾。

```
@implementation MyObject {
  int memberVar3;   /// 私有变量
}

+(return_type) class_method {
    .... //method implementation
}
-(return_type) instance_method1 {
     ....
}
-(return_type) instance_method2: (int) p1 {
    ....
}
-(return_type) instance_method3: (int) p1 andPar: (int) p2 {
    ....
}
@end
```