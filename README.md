
创建控制器

```
    BGUnlockController *ctrl = [[BGUnlockController alloc] init];
    //数字验证码的次数
    ctrl.passcodeUnlockCount = 10;
    //数字验证码
    ctrl.delegate = self;
    ctrl.passcode = @"8573";
    [self presentViewController:ctrl animated:YES completion:NULL];
```

实现BGUnlockControllerDelegate代理方法

```
- (void)unlockController:(BGUnlockController *)controller successWithUnlockType:(BGUnlockControllerUnlockType)unlockType {

}

- (void)unlockFailureWithUnlockController:(BGUnlockController *)controller {

}
```

效果如下：

![](http://ww1.sinaimg.cn/large/7746cd07jw1eyfp8y4qnpg207b0cznc9.gif)