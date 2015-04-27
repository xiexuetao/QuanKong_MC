//
//  WechatAndWeibo.h
//  QuanKong
//
//  Created by Rick on 14/11/24.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@protocol WechatAndWeiboDelegate <NSObject>
-(void) didReceiveWechatAndWeiboResponse:(id)resp;
-(void)wechatUserInfo:(NSDictionary *)dic;
@end

@interface WechatAndWeibo : NSObject<WeiboSDKDelegate,WBHttpRequestDelegate,WXApiDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)id <WechatAndWeiboDelegate> delegate;



/**
 *  初始化
 *
 *  @return 实体
 */
+(instancetype)initWithSWW;

/**
 *  微博发送授权请求
 */
- (void)wBAuthorizeRequest;

/**
 *  微信授权请求
 */
-( void )sendAuthRequest;

/**
 *  微信分享
 *
 *  @param shareType   分享到
 *  @param title
 *  @param description
 *  @param couponId
 */
-(void)weixinShareButtonPressed:(BOOL) shareType titleLa:(NSString *)title description:(NSString *)description image:img couponId:(NSString *)couponId;

/**
 *  微博分享
 *
 *  @param title
 *  @param img
 */
+ (void)shareButtonPressed:(NSString *)title image:(UIImage *)img;
@end
