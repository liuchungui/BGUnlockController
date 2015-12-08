//
//  ViewController.m
//  BGUnlockControllerDemo
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 BG. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "BGUnlockController.h"

@interface ViewController ()<BGUnlockControllerDelegate, UIAlertViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(id)sender {
    BGUnlockController *ctrl = [[BGUnlockController alloc] init];
    //数字验证码的次数
    ctrl.passcodeUnlockCount = 6;
    //数字验证码
    ctrl.delegate = self;
    ctrl.passcode = @"8573";
    ctrl.fingerprintUnlockMessage = @"通过Home进行解锁";
    ctrl.fingerprintUnlockFailureTitle = @"使用数字密码解锁";
    [self presentViewController:ctrl animated:YES completion:NULL];
}

#pragma mark - BGUnlockControllerDelegate
- (BOOL)shouldUnlockFailureWhenGiveUpFingerprintUnlock:(BGUnlockController *)controller {
    return NO;
}
- (void)unlockController:(BGUnlockController *)controller successWithUnlockType:(BGUnlockControllerUnlockType)unlockType {
    NSString *title = @"";
    if(unlockType == BGUnlockControllerUnlockTouchId) {
        title = @"使用指纹解锁成功";
    }
    else {
        title = @"使用数字密码解锁成功";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)unlockFailureWithUnlockController:(BGUnlockController *)controller {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解锁失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
