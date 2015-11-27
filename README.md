###环境要求
* iOS 7.0+
* Xcode 7.1+

###使用

```
    BGUnlockController *ctrl = [[BGUnlockController alloc] init];
    //数字验证码的次数
    ctrl.passcodeUnlockCount = 10;
    //数字验证码
    ctrl.passcode = @"8573";
    ctrl.delegate = self;
    [self presentViewController:ctrl animated:YES completion:NULL];
```

实现BGUnlockControllerDelegate代理方法

```
- (void)unlockController:(BGUnlockController *)controller successWithUnlockType:(BGUnlockControllerUnlockType)unlockType {

}

- (void)unlockFailureWithUnlockController:(BGUnlockController *)controller {

}
```

###效果如下：

![](http://ww1.sinaimg.cn/large/7746cd07jw1eyfp8y4qnpg207b0cznc9.gif)