//
//  BGUnlockHelper.m
//  BGUnlockControllerDemo
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 BG. All rights reserved.
//

#import "BGUnlockHelper.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

/*
 typedef NS_ENUM(NSInteger, LAError)
 {
 //授权失败
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 //用户取消Touch ID授权
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 //用户选择输入密码
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 //系统取消授权(例如其他APP切入)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 //系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 //设备Touch ID不可用，例如未打开
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 //设备Touch ID不可用，用户未录入
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 } NS_ENUM_AVAILABLE(10_10, 8_0);
 */
@implementation BGUnlockHelper

+ (BOOL)canUseFingerprintUnlock {
    /**
     *  iOS以下直接返回NO
     */
    if([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    else {
        LAContext *context = [[LAContext alloc] init];
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

+ (void)fingerprintUnlockWithMessage:(NSString *)message
                             failure:(NSString *)failureTitle
                             success:(void (^)())successBlock
                             failure:(void (^)(NSError *))failureBlock {
    //小于iOS8系统调用，不起作用
    if([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return;
    }
    //初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = failureTitle;
    //错误对象
    NSError *error = nil;
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(successBlock) {
                        successBlock();
                    }
                });
            }
            else{
                //解锁失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(failureBlock) {
                        failureBlock(error);
                    }
                });
            }
        }];
    }
    else{
        //设置不支持指纹解锁
        dispatch_async(dispatch_get_main_queue(), ^{
            if(failureBlock) {
                failureBlock(error);
            }
        });
    }

}
@end
