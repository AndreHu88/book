# iOS输入框总结

## 限制输入框输入字数

对于 iOS 系统自带的键盘，有时候它在输入框中填入的是占位字符（已被高亮选中起来），等用户选中键盘上的候选词时，再替换为真正输入的字符

比如输入框限定最多只能输入 10 位，当已经输入 9 个汉字的时候，使用系统拼音键盘则第 10 个字的拼音就打不了（因为剩余的 1 位无法输入完整的拼音）。

输入框中的拼音会被高亮选中起来，所以我们可以根据 UITextField 的 markedTextRange 属性判断是否存在高亮字符，如果有则不进行字数统计和字符串截断操作。我们通过监听 UIControlEventEditingChanged 事件来对输入框内容的变化进行相应处理，如下：

```
[self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
```

```
- (void)textFieldDidChange:(UITextField *)textField {

    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }

    // maxWowdLimit 为 0，不限制字数
    if (self.maxWowdLimit == 0) {
        return;
    }

    // 判断是否超过最大字数限制，如果超过就截断
    if (textField.text.length > self.maxWowdLimit) {
        textField.text = [textField.text substringToIndex:self.maxWowdLimit];
    }

    // 剩余字数显示 UI 更新
}
```

## 常用的UI属性

```
textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSFontAttributeName : SystemFont(14), NSForegroundColorAttributeName : UIColorFromRGB(0x999999, 1.0)}];
```