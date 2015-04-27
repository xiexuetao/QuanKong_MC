//
//  UserInfo.m
//  Kaiquan
//  用户信息实体类，已完成，以单例设计模式编写
//  Created by rockcent on 14-8-14.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "UserInfo.h"
#import "HTTPTool.h"
static UserInfo * mUserInfo=nil;
@implementation UserInfo

//用户登录是获取的信息
@synthesize userName;
@synthesize token;
@synthesize weibotoken;
@synthesize appleToken;

//用户的详细信息
@synthesize mid;
@synthesize weChatOpenId;
@synthesize weiboId;
@synthesize phone;
@synthesize email;
@synthesize createTime;
@synthesize nickname;
@synthesize realName;
@synthesize sex;
@synthesize province;
@synthesize city;
@synthesize country;
@synthesize headimgurl;
@synthesize isSetLoginPass;
@synthesize isSetPayPass;
@synthesize isRealnameAuth;
@synthesize account;
@synthesize donotUse;

#pragma mark -

/**
 *  网络上获取的json数据初始化用户类
 *
 *  @param json_dictionary 网络获取的json数据
 */
-(void)initWithDictionary:(NSDictionary *)json_dictionary
{
//    MyLog(@"UserInfo.initWithDictionary-----%@",json_dictionary);
    NSDictionary *obj = [json_dictionary objectForKey:@"obj"];
    mid=[obj objectForKey:@"id"];
    weChatOpenId=[obj objectForKey:@"weChatOpenId"];
    weiboId=[obj objectForKey:@"weiboId"];
    phone=[obj objectForKey:@"phone"];
    email=[obj objectForKey:@"email"];
    createTime=[obj objectForKey:@"createTime"];
    nickname=[obj objectForKey:@"nickname"];
    realName=[obj objectForKey:@"realname"];
    sex=[obj objectForKey:@"sex"];
    province=[obj objectForKey:@"province"];
    city=[obj objectForKey:@"city"];
    country=[obj objectForKey:@"country"];
    headimgurl=[obj objectForKey:@"headimgurl"];
    isSetLoginPass=[obj objectForKey:@"isSetLoginPass"];
    isSetPayPass=[obj objectForKey:@"isSetPayPass"];
    isRealnameAuth=[obj objectForKey:@"isRealnameAuth"];
    account=[obj objectForKey:@"account"];
}
/**
 *  一旦用户登录，调用保存用户的username，token，islogined
 *
 *  @param isLogined nil
 */
-(void)setIsLogined:(BOOL)isLogined
{
    _isLogined=isLogined;
    [self saveInfoIntoUerDefaults];
}

-(BOOL)getIsLogined
{
    //如果用户登录，刷新用户数据
   
    return _isLogined;
}

/**
 *  银行绑定读写
 *
 *  @param bankSelect nil
 */
- (void)setBankSelect:(BOOL)bankSelect
{
    _bankSelect = bankSelect;
}

- (BOOL)getBankSelect
{
    return _bankSelect;
}

/**
 *  单例设计模式
 *
 *  @return 用户信息的单例
 */
+(UserInfo *)shareUserInfo
{
    if (!mUserInfo) {
       mUserInfo=[[self alloc]init];
        //从本地读取文件，初始化用户信息类
     [self readInfoFromUserDefaults];
        //用户已经登录，用已有的token，username去获取用户信息
        if (mUserInfo.isLogined) {
            [mUserInfo getUserInfoUsername:mUserInfo.userName Token:mUserInfo.token];
        }
    }
    return  mUserInfo;
}
#pragma mark-用户信息数据与本地数据的交互
/**
 *  将用户的username，token，islogined保存到本地
 */
-(void)saveInfoIntoUerDefaults
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:@"userName"];
    [defaults setObject:self.token forKey:@"token"];
    [defaults setBool:self.isLogined forKey:@"isLogined"];
    [defaults setBool:self.bankSelect forKey:@"bankSelect"];
    [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
}
/**
 *  从本地读取用户username，token，islogined，初始化用户信息
 */
+(void)readInfoFromUserDefaults
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    mUserInfo.userName=[defaults objectForKey:@"userName"];
    mUserInfo.token=[defaults objectForKey:@"token"];
    mUserInfo.isLogined=[defaults boolForKey:@"isLogined"];
    mUserInfo.bankSelect=[defaults boolForKey:@"bankSelect"];
    
    [defaults synchronize];
}
/**
 *  清空本地的用户信息
 */
+(void)clearInfoInUserDefaults
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}
#pragma mark-网络请求
/**
 *  用保存的token与username获取用户的信息
 *
 *  @param name   用户名
 *  @param mtoken token
 */
-(void)getUserInfoUsername:(NSString *)name Token:(NSString *)mtoken
{
    NSString *url = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,GET_CUSTOMER_METHOD,userName,APP_KEY];
    
    [HTTPTool getWithPath:url success:^(id success) {
        NSDictionary *json_dictionary = success;
        
        NSString * i=[json_dictionary objectForKey:@"event"];
        //获取用户信息返回结果
        if ([i isEqualToString:@"0"]) {
                [self initWithDictionary:json_dictionary];
                //通知我tab刷新用户信息
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userinfoneedrefresh" object:self];
        }
    } fail:^(NSError *error) {

    }];
}
@end
