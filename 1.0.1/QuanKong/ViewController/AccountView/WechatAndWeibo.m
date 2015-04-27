//
//  WechatAndWeibo.m
//  QuanKong
//
//  Created by Rick on 14/11/24.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "WechatAndWeibo.h"
#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
@interface WechatAndWeibo(){
   NSString *_access_token;
   NSString *_openid;
   NSString *_wxCode;
}
@end

static WechatAndWeibo *_mWechatAndWeibo = nil;

@implementation WechatAndWeibo

+(id)initWithSWW{
    if (!_mWechatAndWeibo) {
        
        _mWechatAndWeibo = [[self alloc] init];
        
        //向微博客户端程序注册第三方应用
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kAppKey];
        
        //向微信注册
        [WXApi registerApp:kWXAPP_ID withDescription:@ "weixin" ];
        
        return _mWechatAndWeibo;
    }
    return _mWechatAndWeibo;
}

#pragma mark - WeiboSDK

/**
 *  发送授权请求
 */
- (void)wBAuthorizeRequest
{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    NSLog(@"ssobuttonPressed");
}


/**
 *  与微博有关的网络请求respon处理
 *
 *  @param response 返回的消息
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    [self.delegate didReceiveWechatAndWeiboResponse:response];
}


-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    //    MyLog(@"weibo");
}


/**
 *  分享
 */
+ (void)shareButtonPressed:(NSString *)title image:(UIImage *)img{
    
    WBMessageObject *message = [WBMessageObject message];
    
    //文字
    message.text = title;
    
    
    //图片
    WBImageObject *image = [WBImageObject object];
    image.imageData = UIImagePNGRepresentation(img);
    message.imageObject = image;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"QuanKongCouponDetailViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}



#pragma mark - wechatSDK

/**
 *  发送微信授权请求
 */
-( void )sendAuthRequest
{
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"未安装微信客户端，\n是否现在去下载？" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在就去下载", nil];
        alert.delegate = self;
        [alert show];
    }else{
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @ "snsapi_userinfo,snsapi_base" ;
        req.state = @ "0744" ;
        [WXApi sendReq:req];
    }
}



/**
 *  微信授权分享回调
 *
 *  @param resp 响应
 */
-( void )onResp:(BaseResp *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code 用户换取access_token的code，仅在ErrCode为0时有效
     state 第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang 微信客户端当前语言
     country 微信用户当前国家信息
     */
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            _wxCode = aresp.code;
            [self getAccess_token];//获取token
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
                [self.delegate didReceiveWechatAndWeiboResponse:resp];
    }
}

/**
 *  获取token
 */
-( void )getAccess_token
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    NSString *url =[NSString stringWithFormat:@ "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code" ,kWXAPP_ID,kWXAPP_SECRET,_wxCode];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                _access_token = [dic objectForKey:@ "access_token"];
                _openid = [dic objectForKey:@ "openid"];
                [self getUserInfo];
            }
        });
    });
}


//利用GCD来获取对应的token和openID。
//第三步：根据第二步获取的token和openid获取用户的相关信息。

-( void )getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@" ,_access_token,_openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self.delegate wechatUserInfo:dic];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取用户信息失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    });
}


/**
 *  发送微信分享信息
 *
 *  @param shareType 分享目标 yes：朋友圈  no：会话
 */
-(void)weixinShareButtonPressed:(BOOL) shareType titleLa:(NSString *)title description:(NSString *)description image:img couponId:(NSString *)couponId{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"未安装微信客户端，\n是否现在去下载？" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在就去下载", nil];
        alert.delegate = self;
        [alert show];
    }else{

        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            NSString *ID = [business objectForKey:@"id"];
            if ([i isEqualToString:@"0"]) {
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = title;
                message.description = description;
                
                UIImage *image = [WechatAndWeibo generatePhotoThumbnail:img];
                
                [message setThumbImage:image];
                
                WXWebpageObject *ext = [WXWebpageObject object];
                
                ext.webpageUrl = [NSString stringWithFormat:@"%@%@?channelId=%@&id=%@",TRANSLATION_WEBHEADER_URL,TRANSLATION_WEB_URL,ID,couponId];
                
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;//是否发送文字
                req.message = message;
                //    req.text = @"测试分享数据";
                if (shareType) {
                    req.scene = WXSceneSession;//分享到微信会话
                }else{
                    req.scene = WXSceneTimeline;//分享到微信朋友圈
                }
                
                [WXApi sendReq:req];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[success objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *str = [WXApi getWXAppInstallUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}



/**
 *  生成缩略图
 *
 *  @param image
 *
 *  @return
 */
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image {
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 64.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}

@end
