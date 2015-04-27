//
//  KaiquanVerifyRelevant.m
//  Kaiquan
//
//  Created by rick on 14-9-23.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "KaiquanVerifyRelevant.h"

@implementation KaiquanVerifyRelevant
/**
 *  使获取验证码按钮失效15s
 */
+(void)disableVerificationBtnFor15s:(id)verificationBtn
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [verificationBtn setUserInteractionEnabled:NO];
        });
        for (int i=0; i<60; i++) {
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [verificationBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            [verificationBtn setUserInteractionEnabled:YES];
        });
    });
}



#pragma mark 手机号码验证
+(BOOL)verificationPhone:(NSString *) phonennumber{
    NSString *phone = @"^1(\\d{10})$";
    NSPredicate *regexphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    BOOL boole = [regexphone evaluateWithObject:phonennumber];
//    MyLog(@"---------->>%i",boole);
    return boole;
}

#pragma mark 密码验证
+(BOOL)verificationPassword:(NSString *)password{
    NSString *pw = @"^\\w{6,15}$";
    NSPredicate *regexps = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pw];
    BOOL boole = [regexps evaluateWithObject:password];
//    MyLog(@"---------->>%i",boole);
    return boole;
}

#pragma mark 密码确认
+(BOOL)verificationPassword:(NSString *)password affirmPs:(NSString *)affirmPw{
    BOOL boole = NO;
    if ([password isEqualToString:affirmPw]) {
        boole = YES;
    }
    return boole;
}

#pragma mark-辅助函数
/**
 *  生成字符串的MD5
 *
 *  @param str 字符串
 *
 *  @return 对应的MD5
 */

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
