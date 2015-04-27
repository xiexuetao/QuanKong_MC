//
//  NextModifyPasswordController.m
//  Kaiquan
//
//  Created by rick on 14-9-23.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "NextModifyPasswordController.h"
#import "NSString+DisposeStr.h"
#import "MBProgressHUD+Add.h"
#import "LoginViewController.h"
#import "HTTPTool.h"
#import "UserInfo.h"
#import "AccountSecurityViewController.h"
#import "UIWindow+AlertHud.h"

#define PAY_PASSWORD 1
#define LOGIN_PASSWORD =
@interface NextModifyPasswordController (){
}

@end

@implementation NextModifyPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
                self.extendedLayoutIncludesOpaqueBars = NO;
                self.modalPresentationCapturesStatusBarAppearance = NO;
            }
        #endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //返回导航栏按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItemButton;
    
    //新密码输入框
    self.pwTF =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    [self.pwTF setPlaceholder:@"请输入新密码"];
    self.pwTF.secureTextEntry = YES;
    self.pwTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:self.pwTF];
    
    //分割线
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 0.5)];
    line1.backgroundColor=[UIColor grayColor];
    line1.alpha = 0.4;
    [self.view addSubview:line1];
    
    //确认密码输入框
    self.confirmPwTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    [self.confirmPwTF setPlaceholder:@"请输入确认密码"];
    self.confirmPwTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.confirmPwTF.secureTextEntry = YES;
    [self.view addSubview:self.confirmPwTF];
    //分割线
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.4;
    [self.view addSubview:line2];
    
    if (self.type == PAY_PASSWORD) {
        self.loginpsTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
        self.pwTF.frame = CGRectMake(10, 50, WIDTH-20, 50);
        self.confirmPwTF.frame = CGRectMake(10, 100, WIDTH-20, 50);
        self.loginpsTF.placeholder = @"请输入登录密码";
        self.loginpsTF.secureTextEntry = YES;
        [self.view addSubview:self.loginpsTF];
        
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 150, WIDTH-20, 0.5)];
        line2.backgroundColor = [UIColor lightGrayColor];
        line2.alpha = 0.4;
        [self.view addSubview:line2];
    }
    
    //确认按钮
    self.confirmBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 180, WIDTH-20, 40)];
    [self.confirmBut setBackgroundColor:[UIColor orangeColor]];
    self.confirmBut.layer.cornerRadius=5.0;
    [self.confirmBut setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmBut addTarget:self action:@selector(confirmPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBut];
}

#pragma mark 导航栏返回
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确认按钮点击
-(void)confirmPassword:(UIButton *)but{
    
        [self modifyPasswordWithPhone:self.phoneNumber verificationCode:self.code Password:self.pwTF.text confirmPs:self.confirmPwTF.text];

}

#pragma mark 发送设置密码请求
-(void)modifyPasswordWithPhone:(NSString *)phonenumber verificationCode:(NSString *)code Password:(NSString *)pwd confirmPs:(NSString *)affirmPw
{
    
    //mc
    code = @"3838438";
    
    if(self.loginpsTF.text.length == 0 && self.type == PAY_PASSWORD){
        [self.view.window showHUDWithText:@"请输入登录密码"  Enabled:YES];
    }else
        if(![NSString verificationPassword:self.loginpsTF.text]&&self.type == 1){
        [self.view.window showHUDWithText:@"登录密码不正确" Enabled:YES];
    }else
        if (pwd.length==0) {
        [self.view.window showHUDWithText:@"请输入新密码" Enabled:YES];
    }else if(![NSString verificationPassword:pwd]){
        [self.view.window showHUDWithText:@"新密码长度或填写不正确" Enabled:YES];
    }else if(affirmPw.length == 0){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else  if (![NSString verificationPassword:pwd affirmPs:affirmPw]) {
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else{
        NSString *mcStr = pwd;
        pwd = [NSString md5:pwd];
        affirmPw = [NSString md5:affirmPw];
        NSString *str;
        UserInfo *user = [UserInfo shareUserInfo];
        
        if (self.type == PAY_PASSWORD) {//交易密码
            str = [NSString stringWithFormat:@"%@%@&password=%@&loginName=%@&loginPassword=%@&appKey=%@&code=%@",NEW_HEAD_LINK,SET_PAY_PASSWORD_METHOD,affirmPw,user.userName,[NSString md5:self.loginpsTF.text],APP_KEY_MC,self.code];
        } else {//登录密码
            str = [NSString stringWithFormat:@"%@%@&password=%@&loginName=%@&appKey=%@&code=%@&mcPassword=%@",NEW_HEAD_LINK,LOGIN_PASSWORD_METHOD,pwd,self.phoneNumber,APP_KEY_MC,self.code,[NSString md5_MC:mcStr]];
        }

        [HTTPTool getWithPath: str success:^(id success) {
            //处理结果
            NSNumber * i = [success objectForKey:@"code"];
            
            if ([i integerValue] != 0){
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }else{
                [self.view.window showHUDWithText:@"保存成功" Enabled:YES];
                NSArray *arr = self.navigationController.childViewControllers;
                if (self.type == PAY_PASSWORD) {
                    for (UIViewController *vc in arr) {
                        if ([vc isKindOfClass:AccountSecurityViewController.class]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }else{
                    for (UIViewController *vc in arr) {
                        if ([vc isKindOfClass:LoginViewController.class]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }
                [user getUserInfoUsername:user.userName Token:user.token];
            }

        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"操作失败" Enabled:YES];
        }];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
