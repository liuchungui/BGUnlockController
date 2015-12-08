//
//  BGUnlockController.h
//  BGUnlockControllerDemo
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  解锁类型
 */
typedef NS_ENUM(NSInteger, BGUnlockControllerUnlockType) {
    /**
     *  数字密码解锁
     */
    BGUnlockControllerUnlockPassCode,
    /**
     *  指纹解锁
     */
    BGUnlockControllerUnlockTouchId,
};

@class BGUnlockController;

@protocol BGUnlockControllerDelegate <NSObject>
@required
/**
 *  当点击放弃指纹解锁时，是否表示解锁失败
 *
 *  @return 默认返回NO
 */
@optional
- (BOOL)shouldUnlockFailureWhenGiveUpFingerprintUnlock:(BGUnlockController *)controller;

@required
/**
 *  解锁成功
 *
 *  @param controller 解锁控制器
 *  @param unlockType 解锁类型
 */
- (void)unlockController:(BGUnlockController *)controller successWithUnlockType:(BGUnlockControllerUnlockType)unlockType;
/**
 *  解锁失败
 *
 *  @param controller 解锁失败
 */
- (void)unlockFailureWithUnlockController:(BGUnlockController *)controller;

@end

@interface BGUnlockController : UIViewController
/**
 *  指纹解锁的次数，达到上限次数如果没有解锁成功，则弹出数字解锁，默认为3
 */
@property (nonatomic, assign) NSInteger fingerprintUnlockCount;

/**
 *  指纹解锁提示信息，默认为“请使用指纹解锁”
 */
@property (nonatomic, strong) NSString *fingerprintUnlockMessage;

/**
 *  指纹解锁失败时的按钮标题，默认为“点击输入数字密码”
 */
@property (nonatomic, strong) NSString *fingerprintUnlockFailureTitle;

/**
 *  数字解锁码
 */
@property (nonatomic, strong) NSString *passcode;

/**
 *  数字解锁的次数，默认5次，如果达到上限，则说明解锁失败，锁定用户
 */
@property (nonatomic, assign) NSInteger passcodeUnlockCount;


@property (nonatomic, weak) id<BGUnlockControllerDelegate> delegate;

@end
