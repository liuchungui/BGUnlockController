//
//  BGUnlockController.m
//  BGUnlockControllerDemo
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 BG. All rights reserved.
//

#import "BGUnlockController.h"
#import "BGUnlockHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>

static UIImage *ImageWithColor(UIColor * color, CGSize size){
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
}
@interface BGUnlockController ()
/**
 *  按钮数组的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *buttonsSuperView;
/**
 *  按钮数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArr;
/**
 *  圆点数组
 */
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topDotViewArr;
@property (weak, nonatomic) IBOutlet UIView *topDotSuperView;

/**
 *  提醒文本
 */
@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;

/**
 *  圆点底部距离按钮父视图的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDotSuperViewCenterXLayoutConstraint;

/**
 *  结果解锁的数字密码
 */
@property (nonatomic, strong) NSString *resultPassCode;

/**
 *  解锁的次数
 */
@property (nonatomic, assign) NSInteger unlockCount;

/**
 *  输入的数字个数
 */
@property (nonatomic, assign) NSInteger inputNumCount;

/**
 *  解锁类型
 */
@property (nonatomic, assign) BGUnlockControllerUnlockType unlockType;
@end

@implementation BGUnlockController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.fingerprintUnlockCount = 3;
        self.passcodeUnlockCount = 5;
        self.fingerprintUnlockMessage = @"请使用指纹解锁";
        self.fingerprintUnlockFailureTitle = @"点击输入数字密码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValues];
    [self setupViews];
    if([BGUnlockHelper canUseFingerprintUnlock]) {
        [self useFingerprintUnlock];
    }
    else {
        [self usePasscodeUnlock];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)setupValues {
    self.unlockCount = 0;
    self.resultPassCode = @"";
}

- (void)setupViews {
    //屏幕宽度
    CGFloat mainScrrenWidth = [UIScreen mainScreen].bounds.size.width;
    //设置按钮的宽和高
    CGFloat height = (NSInteger)(mainScrrenWidth-320)*0.1+70.0f;
    self.buttonHeightLayoutConstraint.constant = height;
    //设置按钮
    for (UIButton *button in self.buttonArr) {
        button.exclusiveTouch = YES;
        button.layer.cornerRadius = height/2.0;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:ImageWithColor([UIColor clearColor], CGSizeMake(height, height)) forState:UIControlStateNormal];
        [button setBackgroundImage:ImageWithColor([UIColor blueColor], CGSizeMake(height, height)) forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    //圆点
    for (UIView *dotView in self.topDotViewArr) {
        dotView.layer.cornerRadius = 5.0f;
        dotView.layer.borderWidth = 1.0f;
        dotView.layer.borderColor = [UIColor blueColor].CGColor;
        dotView.backgroundColor = [UIColor clearColor];
        dotView.layer.masksToBounds = YES;
    }
    
    //顶部提醒文字
    self.topTipLabel.text = @"请输入解锁密码";
}

- (void)hideContentView {
    self.topDotSuperView.hidden = YES;
    self.buttonsSuperView.hidden = YES;
    self.topTipLabel.hidden = YES;
}

- (void)showContentView {
    self.topDotSuperView.hidden = YES;
    self.buttonsSuperView.hidden = YES;
    self.topTipLabel.hidden = YES;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - action
- (void)buttonAction:(UIButton *)button {
    //设置圆点为实心
    UIView *dotView = self.topDotViewArr[self.inputNumCount];
    dotView.backgroundColor = [UIColor blueColor];
    NSLog(@"inputNumCount = %zd, color:%@", self.inputNumCount, dotView.backgroundColor);
    for (UIView *view in self.topDotViewArr) {
        NSLog(@"%@", view.backgroundColor);
    }
    //存储数字解锁码
    NSInteger codeValue = [self.buttonArr indexOfObject:button];
    self.resultPassCode = [NSString stringWithFormat:@"%@%zd", self.resultPassCode, codeValue];
    if(++self.inputNumCount == 4) {
        self.inputNumCount = 0;
        //比较输入的数字码正确与否
        if([self.resultPassCode isEqualToString:self.passcode]) {
            [self unlockSuccess];
        }
        else {
            //屏蔽点击
            self.buttonsSuperView.userInteractionEnabled = NO;
            [self shakePassCodeView:^{
                [self clearPassCodeView];
                self.buttonsSuperView.userInteractionEnabled = YES;
                //自增
                self.unlockCount ++;
                //如果已经超过数字解锁码的上限，则调用失败的方法
                if(self.unlockCount > self.passcodeUnlockCount) {
                    [self unlockFailure];
                }
            }];
   
        }
    }
}


#pragma makr - public method
- (void)clearPassCodeView {
    [self setupValues];
    //圆点
    for (UIView *dotView in self.topDotViewArr) {
        dotView.backgroundColor = [UIColor clearColor];
    }
}

- (void)shakePassCodeView: (void (^)())block {
    self.topDotSuperViewCenterXLayoutConstraint.constant = 50;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topDotSuperViewCenterXLayoutConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            [self.view layoutIfNeeded];
            block();
        }
    }];
}

#pragma mark - set method
- (void)setFingerprintUnlockCount:(NSInteger)fingerprintUnlockCount {
    _fingerprintUnlockCount = fingerprintUnlockCount;
}

- (void)setPasscodeUnlockCount:(NSInteger)passcodeUnlockCount {
    _passcodeUnlockCount = passcodeUnlockCount;
}

#pragma mark - unloc logic
- (void)useFingerprintUnlock {
    self.unlockCount ++;
    self.unlockType = BGUnlockControllerUnlockTouchId;
    [BGUnlockHelper fingerprintUnlockWithMessage:self.fingerprintUnlockMessage failure:self.fingerprintUnlockFailureTitle success:^{
        [self unlockSuccess];
    } failure:^(NSError *error) {
        /*
         //用户取消Touch ID授权
         LAErrorUserCancel           = kLAErrorUserCancel,
         //用户选择输入密码
         LAErrorUserFallback         = kLAErrorUserFallback,
         注意：如果是用户取消，则直接启用数字解锁
         */
        if(error.code == LAErrorUserCancel || error.code == LAErrorUserFallback) {
            BOOL isFail = NO;
            if([self.delegate respondsToSelector:@selector(shouldUnlockFailureWhenGiveUpFingerprintUnlock:)]) {
                isFail = [self.delegate shouldUnlockFailureWhenGiveUpFingerprintUnlock:self];
            }
            if(isFail) {
                [self unlockFailure];
            }
            else {
                /**
                 *  替换解锁方式，解锁次数初始化为0
                 */
                self.unlockCount = 0;
                [self usePasscodeUnlock];
            }
        }
        else if(self.unlockCount > self.fingerprintUnlockCount) {
            /**
             *  替换解锁方式，解锁次数初始化为0
             */
            self.unlockCount = 0;
            [self usePasscodeUnlock];
        }
        else {
            [self useFingerprintUnlock];
        }
    }];
}

- (void)usePasscodeUnlock {
    self.unlockType = BGUnlockControllerUnlockPassCode;
}

#pragma mark - response delete method
- (void)unlockSuccess {
    [self.delegate unlockController:self successWithUnlockType:self.unlockType];
}

- (void)unlockFailure {
    [self.delegate unlockFailureWithUnlockController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
