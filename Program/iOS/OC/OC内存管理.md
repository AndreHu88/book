# OC内存管理

## 基础模型：谁持有，谁释放

Objective-C 在 ARC 时代不需要手动写 `retain/release`，但内存管理并没有消失，本质规则仍然是“对象的生命周期由引用关系决定”。

在 ARC 下你主要要关注两类引用：

- `strong`：拥有对象，会延长对象生命周期
- `weak`：不拥有对象，对象释放后自动置空

## 常见属性语义

- `strong`：对象默认选择
- `weak`：避免循环引用，常用于 delegate
- `copy`：字符串、block 常用，防止外部可变对象被篡改
- `assign`：基本类型，或明确非对象语义

## 循环引用怎么出现

最常见场景：控制器持有 block，block 又强引用控制器。解决方式通常是 weak-strong dance：

```objc
__weak typeof(self) weakSelf = self;
self.callback = ^{
    __strong typeof(weakSelf) self = weakSelf;
    if (!self) return;
    [self doSomething];
};
```

## 自动释放池

自动释放池用于延迟释放临时对象。高频循环或批量创建对象时，建议手动加局部 `@autoreleasepool`，否则内存峰值会上升。

## 排查内存问题的流程

1. 用 Instruments 的 Leaks/Allocations 看是否泄漏。
2. 用 Memory Graph 找引用链。
3. 优先检查控制器、定时器、通知、block、KVO。

## 容易忽视的点

- `NSTimer` 会强持有 target。
- 通知/KVO 不及时移除会形成隐式持有。
- 容器（数组/字典）里的对象也会被强持有。

## 总结

ARC 只是简化语法，不会替你设计引用关系。把“对象所有权”画成图，绝大多数内存问题都会变得可定位、可修复。
