//
//  KaiquanVerifyRelevant.h
//  Kaiquan
//
//  Created by rick on 14-9-23.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface KaiquanVerifyRelevant : NSObject
/**
 *  使获取验证码按钮失效15s
 */
+(void)disableVerificationBtnFor15s:(id)verificationBtn;

//手机号码验证
+(BOOL)verificationPhone:(NSString *) phonennumber;

// 密码验证
+(BOOL)verificationPassword:(NSString *)password;

// 密码确认
+(BOOL)verificationPassword:(NSString *)password affirmPs:(NSString *)affirmPw;

//md5加密
+ (NSString *)md5:(NSString *)str;
@end
