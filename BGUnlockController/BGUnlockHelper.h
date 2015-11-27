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
 *  @parm  message 提示信息
 *  @param success 解锁成功调用
 *  @param failure 解锁失败调用
 *  @note  成功和失败的回调必须传
 */
+ (void)fingerprintUnlockWithMessage:(NSString *)message success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock;
@end
