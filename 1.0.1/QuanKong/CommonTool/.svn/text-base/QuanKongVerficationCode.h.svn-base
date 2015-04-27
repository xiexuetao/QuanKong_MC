//
//  QuanKongVerficationCode.h
//  QuanKong
//
//  Created by Rick on 14/12/10.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessOperation)(int code);

@interface QuanKongVerficationCode : NSObject

/**
 *  发送验证码
 *
 *  @param url    请求路径
 *  @param method 请求方法
 *  @param number 手机号码
 *  @param key    appkey
 *  @param but    button
 *  @param view   showView
 *
 *  @return yes or no
 */
+(void)sendVerficationCodeWithUrl:(NSString *)url method:(NSString *)method phone:(NSString *) number appKey:(NSString *) key disableVerficationButton:(UIButton *) but messageShowView:(UIView *) view operation:(SuccessOperation) operation;

@end
