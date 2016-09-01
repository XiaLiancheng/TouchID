//
//  ViewController.m
//  TouchID
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 Liancheng. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self useTouchID];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)useTouchID{
    LAContext * context = [LAContext new];
    //设置右边按钮
    context.localizedFallbackTitle = @"密码验证";
    
    NSError * error = nil;
    //判断设备是否支持TouchID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持指纹");
        //验证TouchID的方法
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请输入您的指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSLog(@"指纹验证通过");
            }else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"SystemCancel");
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        NSLog(@"UserCancel");
                    }
                        break;
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"验证失败");
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"TouchID不可用");
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"未设置密码");
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"TouchID不可用,用户未登入");
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                    }
                        break;
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                    }
                        break;
                }
            }
        }];
        
    }else
    {
        NSLog(@"不支持指纹");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID不可用,用户未登入");
            }
                break;
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"未设置密码");
            }
                break;
            default:
            {
                NSLog(@"TouchID不生效");
            }
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
