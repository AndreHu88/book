# iOS开发

这一栏集中记录 iOS 开发中的基础知识、运行时机制、工程实践和性能优化问题。阅读方式不是按年代，而是按“从概念到实战”的路径组织。

## 适合谁看

- 正在补齐 Objective-C 与 iOS 基础的开发者
- 想理解 runtime、事件传递、性能治理的工程师
- 需要快速回顾某个 iOS 问题处理方式的人

## 推荐阅读顺序

1. 先看语言和对象模型，建立 Objective-C 基础认知。
2. 再看 runtime、Runloop 与事件机制，理解系统行为。
3. 最后看工程实践与性能治理，把知识落到业务场景。

## 主题索引

### 语言与对象模型

- [Objective-C简介](iOS/OC/oc简介.md)
- [OC的类和对象](iOS/OC/OC的类和对象.md)
- [OC内存管理](iOS/OC/OC内存管理.md)
- [OC消息机制](iOS/OC/OC消息机制.md)
- [Category和Extension](iOS/OC/Category和Extension.md)
- [isa和Class](iOS/OC/isa和Class.md)
- [OC方法调用过程](iOS/OC/OC方法调用过程.md)
- [import第三方库头文件总结](iOS/OC/import第三方库.md)

### runtime 与系统机制

- [runtime如何实现weak属性](iOS/OC/runtime如何实现weak属性.md)
- [runtime具体应用](iOS/OC/runtime具体应用.md)
- [runtime性能优化](iOS/OC/runtime性能优化.md)
- [Runloop与线程](iOS/OC/Runloop与线程.md)
- [iOS事件响应原理](iOS/OC/iOS事件响应原理.md)
- [触摸事件传递和响应原理](iOS/OC/触摸事件传递和响应原理.md)

### 工程实践

- [Block总结](iOS/OC/Block总结.md)
- [FMDB总结](iOS/OC/FMDB总结.md)
- [iOS输入框一些问题](iOS/Others/iOS输入框一些问题.md)
- [iOS文件及持久化](iOS/Others/iOS文件及持久化.md)
- [cell事件和didSelect冲突](iOS/Others/cell事件和didSelect冲突.md)

### 性能与专项问题

- [iOS卡顿监控落地](iOS/Others/iOS卡顿监控落地.md)
- [swift简介](iOS/Swift/syntax/swift简介.md)
