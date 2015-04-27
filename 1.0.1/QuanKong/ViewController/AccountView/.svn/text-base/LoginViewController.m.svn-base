//
//  LoginViewController.m
//  LoginDemo
//  登录界面，基本完成
//  Created by Lion on 14-7-16.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPasswdViewController.h"
#import "UserInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+Add.h"
#import "FirsModifyPasswordController.h"
#import "AddictionInfoControllVIew.h"
#import "HTTPTool.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "NSString+DisposeStr.h"
#import "UIWindow+AlertHud.h"
#import "QuanKongAppDelegate.h"

@interface LoginViewController (){
    MBProgressHUD *_hud;
}
@end

@implementation LoginViewController

@synthesize userNameTF;//用户账号输入框
@synthesize passwdTF;//密码输入框



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //版本兼容
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
    #endif
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        // Custom initialization
        [self addInput];
        [self addButton];
        [self.navigationController setNavigationBarHidden:NO];
        
        //修改导航栏title
        self.navigationItem.title = @"登录";
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];
    }
    
    return self;
}

#pragma mark -加入所有按钮视图
/**
 *  加入所有按钮视图
 */
-(void)addButton
{
    
    //登录按钮添加
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 130, WIDTH-20, 50)];
    loginBtn.layer.cornerRadius = 5.0;
    [loginBtn setBackgroundColor:[UIColor orangeColor]];
    [loginBtn setTitle:@"登录" forState: UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    //加入注册按钮
    UIButton * registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [registerBtn addTarget:self action:@selector(resigsterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem * registerItemButton=[[UIBarButtonItem alloc]initWithCustomView:registerBtn];
    [self.navigationItem setRightBarButtonItem:registerItemButton];

    
    //加入返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItemButton];
    
//    //分割线
//    UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT-195, WIDTH, 0.5)];
//    lineImageView.backgroundColor= [UIColor lightGrayColor];
//    [self.view addSubview:lineImageView];
//    
//    //其他方式登录的lable
//    UILabel * otherWayLoginLB=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-60, HEIGHT-220,120,50)];
//    otherWayLoginLB.textColor=[UIColor grayColor];
//    otherWayLoginLB.textAlignment = NSTextAlignmentCenter;
//    otherWayLoginLB.backgroundColor=[UIColor whiteColor];
//    otherWayLoginLB.text=@"其他账号登录";
//    otherWayLoginLB.font=[UIFont systemFontOfSize:12.0f];
//    [self.view addSubview:otherWayLoginLB];
//    
//    //微博登录按钮添加
//    UIButton *weiboLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT-180, 50, 50)];
//
//
//    [weiboLoginBtn setImage:[UIImage imageNamed:@"weibo_icon"] forState:UIControlStateNormal];
//    [weiboLoginBtn addTarget:self action:@selector(ssoButtonPressed)   forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weiboLoginBtn];
//    
//    //微信登录按钮添加
//    UIButton *qqLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2, HEIGHT-180, 50, 50)];
//    [qqLoginBtn setImage:[UIImage imageNamed:@"weixin_icon"] forState:UIControlStateNormal];
//    [qqLoginBtn addTarget:self action:@selector(weixinButtonPressed)   forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qqLoginBtn];
//    
  

}

/**
 *  导航栏按钮放回处理事件
 *
 *  @param sender 弹出
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -加入所有输入框视图
/**
 *  视图添加的一个部分用于添加输入框部分
 */
- (void)addInput
{
    //用户名或Email
    UIImageView * _eview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    [_eview setUserInteractionEnabled:YES];
    [self.view addSubview:_eview];

    //用户邮箱
    userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    userNameTF.placeholder=@"手机号码";
    
    [userNameTF setBackgroundColor:[UIColor clearColor]];
    
    [userNameTF setTextColor:[UIColor grayColor]];

    [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    userNameTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    userNameTF.autocorrectionType = UITextAutocorrectionTypeYes;
    [userNameTF setFont:[UIFont systemFontOfSize:17]];
    [userNameTF setDelegate:self];
    [userNameTF setText:@""];
    [userNameTF setHighlighted:YES];
    [self.view addSubview:userNameTF];
    
    UIImageView * lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 0.5)];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
   
    passwdTF = [[UITextField  alloc] initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    passwdTF.placeholder=@"密码";
    [passwdTF setBackgroundColor:[UIColor clearColor]];
    [passwdTF setBorderStyle:UITextBorderStyleNone];
    [passwdTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    [passwdTF setReturnKeyType:UIReturnKeyDone]; //完成
    passwdTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [passwdTF setSecureTextEntry:YES]; //验证
    [passwdTF setDelegate:self];
    [passwdTF setTextColor:[UIColor grayColor]];
    [passwdTF setText:@""];
     [self.view addSubview:passwdTF];
    
    UIImageView * line2ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
    line2ImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2ImageView];
    
    
    //忘记密码按钮添加
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetBtn.frame = CGRectMake(WIDTH-80, 50, 70 , 50);
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [forgetBtn addTarget:self action:@selector(forgetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    
}


#pragma mark -UITextFieldDelegate
/**
 *  输入结束自动跳到下个输入框
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userNameTF) {
        [passwdTF becomeFirstResponder];
    }
    if (textField==passwdTF) {
        [textField resignFirstResponder];
        [self loginButtonPressed];
    }

    return YES;
}

#pragma  mark -按钮点击处理
/**
 *  忘记密码点击
 */
-(void)forgetBtnPressed
{
    NSLog(@"click forgetBtnPressed");
    //跳转到找回密码界面
    FirsModifyPasswordController * tmp=[[FirsModifyPasswordController alloc]init];
    tmp.hidesBottomBarWhenPushed=YES;
    [[self navigationController] pushViewController:tmp animated:YES];
    
}


/**
 *  微博登录按钮点击
 */
- (void)ssoButtonPressed
{
    QuanKongAppDelegate *delegate = (QuanKongAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.wechatAndWeibo.delegate = self;
    [delegate.wechatAndWeibo wBAuthorizeRequest];
}



/**
 *  授权分享回调
 *
 *  @param resp 响应
 */
-(void)didReceiveWechatAndWeiboResponse:(id)resp{
    
     //  微博
    if ([resp isKindOfClass:WBBaseResponse.class]) {
        WBBaseResponse *response = (WBBaseResponse *)resp;
        if ([response isKindOfClass:WBAuthorizeResponse.class])
        {
            //微博验证成功利用放回的微博id，注册登录
            if (response.statusCode==0) {
                
                NSLog(@"loginWeiBo----------------%@",response.userInfo );
                [self.view.window showHUDWithText:@"授权成功" Enabled:YES];
                //            设置登录的用户名和微博token
                [UserInfo shareUserInfo].weibotoken=[(WBAuthorizeResponse *)response accessToken];
                [UserInfo shareUserInfo].userName=[NSString stringWithFormat:@"weibo%@",[response.userInfo objectForKey:@"uid"]];
                NSLog(@"%@",response.userInfo);
                //用返回的微博id登录
                [self loginWeiBoAndWeiXin:[NSString stringWithFormat:@"weibo%@",[response.userInfo objectForKey:@"uid"]]];
                
            }
        }
}
    
    
    //微信
    if ([resp isKindOfClass:BaseResp.class]) {
        BaseResp *response = (BaseResp*)resp;
        if([response isKindOfClass:[SendAuthResp class]])
        {
            SendAuthResp *aresp = (SendAuthResp *)resp;
            if (aresp.errCode== 0) {
                [self.view.window showHUDWithText:@"授权成功" Enabled:YES];
            }
        }
    }
}

#pragma mark - 微信授权登录
/**
 *  微信登录按钮点击
 */
-(void)weixinButtonPressed{
        QuanKongAppDelegate *delegate = (QuanKongAppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.wechatAndWeibo.delegate = self;
        [delegate.wechatAndWeibo sendAuthRequest];
}


-(void)wechatUserInfo:(NSDictionary *)dic{
    UserInfo *userInfo = [UserInfo shareUserInfo];
     userInfo.userName = [NSString stringWithFormat:@"unionid_%@",[dic objectForKey:@ "unionid" ]];
    [self loginWeiBoAndWeiXin:userInfo.userName];
    
}


/**
 *  登录按钮点击
 */
-(void)loginButtonPressed
{
    if(userNameTF.text.length == 0){
        [self.view.window showHUDWithText:@"手机号码不能为空" Enabled:YES];
    }else if (![NSString verificationPhone:userNameTF.text]){
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }else if(![NSString verificationPassword:passwdTF.text]){
        [self.view.window showHUDWithText:@"请正确填写密码" Enabled:YES];
    }else{
        [self loginName:userNameTF.text Password:passwdTF.text];
        _hud = [MBProgressHUD showMessage:nil toView:self.view dimBackground:YES];
    }
}

/**
 *  处理注册按钮点击
 */
-(void)resigsterButtonPressed
{
    NSLog(@"click resigsterbtn");
    //跳转到注册界面
    RegisterViewController * tmp=[[RegisterViewController alloc]init];
    tmp.hidesBottomBarWhenPushed=YES;
    [[self navigationController] pushViewController:tmp animated:YES];
    
}


#pragma mark -网络请求

/**
 *  登录成功后，利用登录成功获取的token，获取用户资料
 *
 *  @param name  用户名
 *  @param token toke
 */
-(void)getUserInfoUsername:(NSString *)name Token:(NSString *)token
{
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,GET_CUSTOMER_METHOD,name,APP_KEY];
    
    NSLog(@"%@",userInfoUrl);
    
    [HTTPTool getWithPath:userInfoUrl success:^(id success) {
       NSString *i =  [success objectForKey:@"event"];
        if ([i isEqualToString:@"0"]) {
            
                //初始化用户类
                [[UserInfo shareUserInfo] initWithDictionary:success];
                [UserInfo shareUserInfo].isLogined=YES;
                
                if ([UserInfo shareUserInfo].phone==nil||[[UserInfo shareUserInfo].phone isEqualToString:@""]) {
                    [self.navigationController pushViewController:[[AddictionInfoControllVIew alloc]init] animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userinfoneedrefresh" object:self];
        }else{
            [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"网络请求失败" Enabled:YES];
    }];
}


/**
 第三方登录
 **/
-(void)loginWeiBoAndWeiXin:(NSString *)openid
{
    
    NSString *otherUrl = [NSString stringWithFormat:@"%@%@&loginName=%@&appleToken=%@&appKey=%@&loginOS=%@",NEW_HEAD_LINK,OTHER_LOGIN_METHOD,openid,[UserInfo shareUserInfo].appleToken,APP_KEY,@0];
    [HTTPTool getWithPath:otherUrl success:^(id success) {
        NSString *i = [success objectForKey:@"event"];
        if([i isEqualToString:@"0"]) {
                //通过微博或微信登录成
                //token,用户名，登录状态，保存到AppDelegate中的token
                [UserInfo shareUserInfo].token=[success objectForKey:@"token"];
                
                //显示登录成功
               [self.view.window showHUDWithText:@"登录成功" Enabled:YES];
                [self getUserInfoUsername:[UserInfo shareUserInfo].userName Token:[UserInfo shareUserInfo].token];
                [UserInfo shareUserInfo].isLogined=YES;
        }else{
            [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"网络请求失败" Enabled:YES];
    }];
}

/**
 *  发送使用用户名跟密码的登录网路请求
 *
 *  @param name 用户民
 *  @param pwd  密码
 */
-(void)loginName:(NSString *)name Password:(NSString *)pwd
{
   
    [UserInfo shareUserInfo].userName=userNameTF.text;
    
    NSString *mcpsw = pwd;
    pwd=[NSString md5:pwd];
    
   NSString *login = [NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&appleToken=%@&loginOS=%@&appKey=%@&mcPassword=%@",NEW_HEAD_LINK,LOGIN_METHOD,name,pwd,[UserInfo shareUserInfo].appleToken,@0,APP_KEY_MC,[NSString md5_MC:mcpsw]];
    
    NSLog(@"%@",login);
    
    [HTTPTool getWithPath:login success:^(id success) {
        NSString *i = [success objectForKey:@"event"];
        if ([i isEqualToString:@"0"]) {
                [UserInfo shareUserInfo].token=[success objectForKey:@"token"];
                //显示登录成功
                [_hud hide:YES];//移除提示信息
                [self getUserInfoUsername:[UserInfo shareUserInfo].userName Token:[UserInfo shareUserInfo].token];
                [UserInfo shareUserInfo].isLogined=YES;
        }else{
                [_hud hide:YES];//移除提示信息
                [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"网络请求失败" Enabled:YES];
        [_hud hide:YES];//移除提示信息
    }];
}


#pragma mark - 关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

#pragma mark 查找键盘第一响应者
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
