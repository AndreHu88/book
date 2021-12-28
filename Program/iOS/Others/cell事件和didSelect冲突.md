#  cell事件和didSelect方法冲突

我们有时候在Cell上添加了手势，发现不响应对应的事件， debug的时候发现没有走对应的事件方法，却走了cell的didSelect方法，用以下代码可以处理

实现`UIGestureRecognizerDelegate`的代理方法

```
public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let touchClass = NSStringFromClass((touch.view?.classForCoder)!)
        let supClass = NSStringFromClass((touch.view?.superview?.classForCoder)!)
        
        if touchClass == "UITableView" || touchClass == "UICollectionView" ||
            supClass == "UITableView" || supClass == "UICollectionView" ||
            touchClass == "UITableViewCellContentView" || supClass == "UITableViewCell" {
            return false
        }
        
        let touchPoint = touch.location(in: contentView)
        if contentView.layer.contains(touchPoint) {
            return false
        }
        
        return true
    }
    
}
```

```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    NSString *touchClassName = NSStringFromClass([touch.view class]);
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），
    if ([touchClassName isEqualToString:@"UITableViewCellContentView"] ||
        [touchClassName  isEqualToString:@"UICollectionView"] ||
        [touchClassName  isEqualToString:@"UITableView"]) {
        
        // cell 不需要响应 父视图的手势，保证didselect 可以正常
        return NO;
    }
    //默认都需要响应
    return  YES;
}
```