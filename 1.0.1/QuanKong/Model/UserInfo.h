//
//  UserInfo.h
//  Kaiquan
//
//  Created by rockcent on 14-8-14.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserInfo : NSObject

//全局变量
@property (copy,nonatomic)NSString * userName;
@property (copy,nonatomic)NSString * token;
@property (copy,nonatomic)NSString * weibotoken;
@property (copy,nonatomic)NSString * appleToken;
@property (nonatomic)BOOL isLogined;
@property (nonatomic)BOOL bankSelect;

@property NSString * mid;
@property NSString * weChatOpenId;
@property NSString * weiboId;
@property NSString * phone;
@property NSString * email;

@property NSString * createTime;
@property NSString * nickname;
@property NSString * realName;
@property NSNumber * sex;
@property NSString * province;
@property NSString * city;
@property NSString * country;
@property NSString * headimgurl;
@property NSString * isSetLoginPass;
@property NSString * isSetPayPass;
@property NSString * isRealnameAuth;
@property NSNumber * account;
@property NSNumber * donotUse;



-(void)initWithDictionary:(NSDictionary *)json_dictionary;
+(UserInfo *)shareUserInfo;
+(void)clearInfoInUserDefaults;
-(void)getUserInfoUsername:(NSString *)name Token:(NSString *)mtoken;

- (BOOL)getBankSelect;
@end
