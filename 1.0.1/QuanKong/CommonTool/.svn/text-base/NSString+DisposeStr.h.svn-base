//
//  NSString+DisposeStr.h
//  QuanKong
//
//  Created by Rick on 14/12/11.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DisposeStr)


/**
 *  手机号码验证
 *
 *  @param phonennumber
 *
 *  @return
 */
+(BOOL)verificationPhone:(NSString *) phonennumber;

/**
 *  密码验证
 *
 *  @param password
 *
 *  @return
 */
+(BOOL)verificationPassword:(NSString *)password;

/**
 *  密码确认
 *
 *  @param password
 *  @param affirmPw
 *
 *  @return
 */
+(BOOL)verificationPassword:(NSString *)password affirmPs:(NSString *)affirmPw;

/**
 *  md5加密
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  名传加密
 *
 *  @param str
 *
 *  @return 
 */
+(NSString *)md5_MC:(NSString *)str;


/**
 *  根据字符串获取实际显示长度
 *
 *  @param string 传入字符串
 *  @param font   字符号
 *
 *  @return 实际显示长度
 */
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;

/**
 *  URL encode 转码
 *
 *  @param input 输入原String
 *
 *  @return 输出编码后String
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

/**
 *  URL encode 解码
 *
 *  @param input 需要解码String
 *
 *  @return 解码后的原String
 */
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;


/**
 *  sha1加密
 *
 *  @return 加密后String
 */
- (NSString*) sha1;
@end
