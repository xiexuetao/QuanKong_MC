//
//  UIButton+Extend.m
//  QuanKong
//
//  Created by Rick on 14/12/11.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "UIButton+Extend.h"

@implementation UIButton (Extend)

/**
 *  使获取验证码按钮失效15s
 */
+(void)disableVerificationBtnFor15s:(id)verificationBtn
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [verificationBtn setUserInteractionEnabled:NO];
        });
        for (int i=60; i>0; i--) {
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [verificationBtn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            [verificationBtn setUserInteractionEnabled:YES];
        });
    });
}

@end
