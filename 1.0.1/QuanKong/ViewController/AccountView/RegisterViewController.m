//
//  RegisterViewController.m
//  注册界面，基本完成
//  Created by Lion on 14-7-17.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "RegisterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "HTTPTool.h"
#import "UserInfo.h"
#import "UIWindow+AlertHud.h"
#import "QuanKongWebViewController.h"
#import "UIWindow+AlertHud.h"
#import "NSString+DisposeStr.h"
#import "UIButton+Extend.h"

@interface RegisterViewController (){
    BOOL registerTag;
}
@end

@implementation RegisterViewController
@synthesize registerBtn;
@synthesize phonenumberTF;
@synthesize passwdTF;
@synthesize verificationBtn;
@synthesize verificationTF;
@synthesize pwAffirmTF;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif
        [self.view setBackgroundColor:[UIColor whiteColor]];
          //加入控件
       
        
        self.navigationItem.title = @"注册";
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];

        
            }
    return self;
    
  
   
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self addMyView];
    
}
/**
 *  初始化视图
 */
-(void)addMyView
{

    //放回导航栏按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItemButton;
   
    //手机号码输入框
    phonenumberTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    phonenumberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phonenumberTF.autocorrectionType = UITextAutocorrectionTypeYes;
    [phonenumberTF setPlaceholder:@"手机号码"];
    [phonenumberTF setDelegate:self];
    [self.view addSubview:phonenumberTF];
    
   
    //验证按钮
//    verificationBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 0, 100,50)];
//    verificationBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
//    [verificationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//   [verificationBtn addTarget:self action:@selector(verificationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//      [self.view addSubview:verificationBtn];
    
    //分割线
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    //验证码输入框
//    verificationTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
//    verificationTF.keyboardType = UIKeyboardTypeNumberPad;
//    [verificationTF setPlaceholder:@"验证码"];
//    [verificationTF setDelegate:self];
//    [self.view addSubview:verificationTF];
    
    //分割线
//    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
//    line2.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:line2];
    
    //密码输入框
    passwdTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    [passwdTF setPlaceholder:@"请输入6~15位密码"];
    [passwdTF setDelegate:self];
    passwdTF.secureTextEntry = YES;
    passwdTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:passwdTF];
    
    //分割线
    UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3];
    
    //确认密码
    pwAffirmTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, WIDTH-20, 50)];
    [pwAffirmTF setDelegate:self];
    pwAffirmTF.placeholder = @"请输入确认密码";
    pwAffirmTF.secureTextEntry = YES;
    pwAffirmTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:pwAffirmTF];
    
    //分割线
    UIImageView *line4=[[UIImageView alloc]initWithFrame:CGRectMake(10, 150, WIDTH-20, 0.5)];
    
    line4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line4];
    
    
//    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(10, 160, 30, 30)];
//    [but setBackgroundImage:[UIImage imageNamed:@"register_btn_on"] forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(clickregisterTag:) forControlEvents:UIControlEventTouchUpInside];
//    registerTag = YES;
    
//    [self.view addSubview:but];
    
    /*UIButton *protocol = [[UIButton alloc]initWithFrame:CGRectMake(45, 160, 150, 30)];
    [protocol setTitle:@"会员魔方用户协议" forState:UIControlStateNormal];
    [protocol setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    protocol.titleLabel.font = [UIFont systemFontOfSize:13.f];
    protocol.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocol addTarget:self action:@selector(clickProtocol:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:protocol];*/
    
    //注册按钮
    registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 200, WIDTH-20, 45)];
    [registerBtn setBackgroundColor:[UIColor orangeColor]];
    registerBtn.layer.cornerRadius=5.0;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerBtn];
  
    
}



/**
 *
 *
 *  @param but
 */
-(void)clickregisterTag:(UIButton *) but{
    if (registerTag == YES) {
        registerTag = NO;
        [but setBackgroundImage:[UIImage imageNamed:@"register_btn_off"] forState:UIControlStateNormal];
    }else{
        registerTag = YES;
        [but setBackgroundImage:[UIImage imageNamed:@"register_btn_on"] forState:UIControlStateNormal];
    }
}



-(void)clickProtocol:(UIButton *)but
{
    QuanKongWebViewController *webVC = [[[QuanKongWebViewController alloc] init]initWebViewWithRequestUrl:PROTOCOL_WEB_URL];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"会员魔方用户协议";
    
    webVC.navigationItem.titleView = titleLabel;
    
    [self.navigationController pushViewController:webVC animated:YES];
}



/**
 *  导航栏放回按钮处理
 *
 *  @param sender
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-按钮点击触发时间
/**
 *  获取验证码按钮点击处理
 */
-(void)verificationBtnPressed
{
    if([NSString verificationPhone:self.phonenumberTF.text]){
        NSString *str = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,CHECK_USER_EXIST_METHOD,self.phonenumberTF.text,APP_KEY];
        [HTTPTool getWithPath:str success:^(id success) {
            NSString *i = [success objectForKey:@"event"];
            if ([i isEqualToString:@"0"] && ![success objectForKey:@"obj"]) {
                [self getVerfication:phonenumberTF.text];
            }else{
                [self.view.window showHUDWithText:@"手机号码已被注册" Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"发送失败" Enabled:YES];
        }];
        
    }else{
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }
}

/**
 *  注册按钮点击处理
 */
-(void)registerBtnPressed
{
        [self registerWithPhone:phonenumberTF.text VerificationCode:verificationTF.text Password:passwdTF.text affirmPs:pwAffirmTF.text];
}

#pragma  mark ASIHTTPRequestDelegate
#pragma mark-网络请求
/**
 *  发送获取验证码的网络请求
 *
 *  @param phonenumber 手机号码
 */
-(void)getVerfication:(NSString *)phonenumber
{
   bool phoneBoole = [NSString verificationPhone:phonenumber];
    if (phoneBoole) {
        NSString *registerCode = [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,REGISTER_CODE_METHOD,phonenumber,APP_KEY];
        [HTTPTool getWithPath:registerCode success:^(id success) {
            NSNumber *i = [success objectForKey:@"code"];
            if ([i integerValue] == 0) {
                //获取验证码成功
                [UIButton disableVerificationBtnFor15s:verificationBtn];
                [self.view.window showHUDWithText:@"验证码发送成功"  Enabled:YES];
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"验证码发送失败"  Enabled:YES];
        }];
        
    }else{
        [self.view.window showHUDWithText:@"手机号码错误!"  Enabled:YES];
    }
}


/**
 *  发送注册的网络请求
 *
 *  @param phonenumber 手机账号
 *  @param code        验证码
 *  @param pwd         密码
 */
-(void)registerWithPhone:(NSString *)phonenumber VerificationCode:(NSString *)code Password:(NSString *)pwd affirmPs:(NSString *)affirmPw
{
    code = @"3838438";
    
    if (![NSString verificationPhone:phonenumber]) {
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }
//    else if(code.length == 0){
//        [self.view.window showHUDWithText:@"请输入验证码" Enabled:YES];
//    }
    else if(pwd.length == 0){
        [self.view.window showHUDWithText:@"请输入密码" Enabled:YES];
    }else if(![NSString verificationPassword:pwd]){
        [self.view.window showHUDWithText:@"请正确填写密码" Enabled:YES];
    }else if(affirmPw.length == 0){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else if(![NSString verificationPassword:pwd affirmPs:affirmPw]) {
        [self.view.window showHUDWithText:@"二次确认密码不一致" Enabled:YES];
    }else if(registerTag==NO){
        [self.view.window showHUDWithText:@"请勾选同意用户协议" Enabled:YES];
    }else{
        NSString *mcpsw = pwd;
        [NSString md5:mcpsw];
        pwd = [NSString md5:pwd];
        NSString *registerUrl = [NSString stringWithFormat:@"%@%@&phoneNum=%@&password=%@&code=%@&appKey=%@&mcPassword=%@",NEW_HEAD_LINK,REGISTER_METHOD,phonenumber,pwd,code,APP_KEY_MC,[NSString md5_MC:mcpsw]];
        [HTTPTool getWithPath:registerUrl success:^(id success) {
            NSString *i = [success objectForKey:@"event"];
            if ([i isEqualToString:@"0"]) {
                    //登录成功
                    UserInfo *user = [UserInfo shareUserInfo];
                    user.userName = phonenumber;
                    [self.view.window showHUDWithText:@"注册成功" Enabled:YES];
                
                NSString *loginUrl = [NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&appleToken=%@&loginOS=%@&appKey=%@&mcPassword=%@",NEW_HEAD_LINK,LOGIN_METHOD,phonenumber,pwd,[UserInfo shareUserInfo].appleToken,@0,APP_KEY_MC,[NSString md5_MC:mcpsw]];
                [HTTPTool getWithPath:loginUrl success:^(id success) {
                        NSString *i = [success objectForKey:@"event"];
                        if([i isEqualToString:@"0"]) {
                                //通过账号密码登录成功
                                //token,用户名，登录状态，保存到KaiquanAppDelegate中的token
                                user.token=[success objectForKey:@"token"];

                                //显示登录成功
                                [user getUserInfoUsername:user.userName Token:user.token];
                                [UserInfo shareUserInfo].isLogined=YES;
                                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                                [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
                        }
                    } fail:^(NSError *error) {
                        [self.view.window showHUDWithText:@"网络请求失败" Enabled:YES];
                    }];
            }else{
               [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
            }
        } fail:^(NSError *error) {
            
        }];

    }
}

#pragma mark -UITextFieldDelegate

/**
 *  第一个输入框输入结束后调到第二个输入框，完成输入后关闭键盘
 *
 *  @param textField
 *
 *  @return 
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==phonenumberTF) {
        [passwdTF becomeFirstResponder];
    }
    if (textField==passwdTF) {
        [verificationTF becomeFirstResponder];
       
    }
    if (textField==verificationTF) {
        [verificationTF resignFirstResponder];
         [self registerBtnPressed];
    }
    
    return YES;
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