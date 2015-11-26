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
    ctrl.delegate = self;
    ctrl.passcodeUnlockCount = 10;
    ctrl.passcode = @"8573";
    [self presentViewController:ctrl animated:YES completion:NULL];
}

#pragma mark - BGUnlockControllerDelegate
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
