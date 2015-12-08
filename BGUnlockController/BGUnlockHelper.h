//
//  BGUnlockHelper.h
//  BGUnlockControllerDemo
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 BG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGUnlockHelper : NSObject
/**
 *  是否可以使用指纹解锁
 *
 *  @return NO 不可以
 */
+ (BOOL)canUseFingerprintUnlock;

/**
 *  指纹解锁，iOS8以下直接失败
 *
 *  @param message      提示信息
 *  @param failureTitle 失败时，弹出的失败按钮标题，默认不显示
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
+ (void)fingerprintUnlockWithMessage:(NSString *)message  failure:(NSString *)failureTitle success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock;
@end
