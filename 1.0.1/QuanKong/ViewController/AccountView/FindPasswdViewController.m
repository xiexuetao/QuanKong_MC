//
//  FindPasswdViewController.m
//  LoginDemo
//  找回登录密码界面，
//  Created by rockcent on 14-7-30.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "FindPasswdViewController.h"
#import "HTTPTool.h"
#import "MBProgressHUD+Add.h"
#import "UIButton+Extend.h"

@implementation FindPasswdViewController
@synthesize phonenumberTF;
@synthesize verificationTF;
@synthesize newpwdTF;
@synthesize confirmnewpwdTF;
@synthesize verificationBtn;
@synthesize changepwdBtn;
#pragma mark-系统方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"findpasswdviewbontroller init");
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
        
        //加入界面
        [self addMyView];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [verificationBtn addTarget:self action:@selector(verificationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [changepwdBtn addTarget:self action:@selector(changepwdBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -加入视图
/**
 *  初始化视图
 */
-(void)addMyView
{
    //手机号码输入框
    phonenumberTF=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    phonenumberTF.layer.borderWidth=1.0f;
    [phonenumberTF setPlaceholder:@"手机号码"];
    //验证码输入框
    verificationTF=[[UITextField alloc]initWithFrame:CGRectMake(0,30, 200, 30)];
    verificationTF.layer.borderWidth=1.0f;
    [verificationTF setPlaceholder:@"验证码"];
    //新密码输入框
    newpwdTF=[[UITextField alloc]initWithFrame:CGRectMake(0,60, 200, 30)];
    newpwdTF.layer.borderWidth=1.0f;
    [newpwdTF setPlaceholder:@"新密码"];
    newpwdTF.secureTextEntry=YES;
    //验证码输入框
    confirmnewpwdTF=[[UITextField alloc]initWithFrame:CGRectMake(0,90, 200, 30)];
    confirmnewpwdTF.layer.borderWidth=1.0f;
    [confirmnewpwdTF setPlaceholder:@"确认密码"];
    confirmnewpwdTF.secureTextEntry=YES;
    //获取验证码按钮
    verificationBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 120, 200, 30)];
    [verificationBtn setTitle:@"verificaiton" forState:UIControlStateNormal];
    [verificationBtn setBackgroundColor:[UIColor blackColor]];
    //改变密码按钮
    changepwdBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 150, 200, 30)];
    [changepwdBtn setTitle:@"changepwd" forState:UIControlStateNormal];
    [changepwdBtn setBackgroundColor:[UIColor blackColor]];
    
    
    
    [phonenumberTF setDelegate:self];
    [verificationTF setDelegate:self];
    [newpwdTF setDelegate:self];
    [confirmnewpwdTF setDelegate:self];
    
    
    [self.view addSubview:verificationTF];
    [self.view addSubview:phonenumberTF];
    [self.view addSubview:newpwdTF];
    [self.view addSubview:confirmnewpwdTF];
    [self.view addSubview:verificationBtn];
    [self.view addSubview:changepwdBtn];
}


#pragma mark -按钮点击事件
/**
 *  获取验证按钮点击处理
 */
-(void)verificationBtnPressed
{
    [self getVerification:phonenumberTF.text];
    [UIButton disableVerificationBtnFor15s:verificationBtn];
    
}
-(void)changepwdBtnPressed
{
    if (NSOrderedSame ==[newpwdTF.text compare:confirmnewpwdTF.text]) {
           [self setPasswdByPhone:phonenumberTF.text NewPassword:newpwdTF.text VerificationCode:verificationTF.text];
        
    }
    else
        //提示两次密码输入不同请重新输入
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不同请重新输入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
        //清空密码输入框
        [newpwdTF setText:@""];
        [confirmnewpwdTF setText:@""];
        
    }
 
}
#pragma mark-网络申请

/**
 *  发送获取验证码网络请求
 *
 *  @param phonenumber 手机号码
 */
-(void)getVerification:(NSString *)phonenumber
{

    [HTTPTool getWithPath:[NSString stringWithFormat:@"%@%@&phoneNum=%@",NEW_HEAD_LINK,GET_LOGIN_PASSWORD_METHOD,phonenumber] success:^(id success) {
        NSString *i = [success objectForKey:@"event"];
        switch ([i isEqualToString:@"0"]) {
            case 0:
                break;
            default:
                break;
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"链接失败" toView:self.view];
    }];
    
}

/**
 *  发送设置密码的网络请求
 *
 *  @param phonenumber 电话号码
 *  @param newpasswd   新的密码
 *  @param code        验证码
 */
-(void)setPasswdByPhone:(NSString *)phonenumber NewPassword:(NSString *)newpasswd VerificationCode:(NSString *)code
{
    [HTTPTool getWithPath:[NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&code=%@",NEW_HEAD_LINK,SET_LOGIN_PASSWORD_METHOD,phonenumber,newpasswd,code] success:^(id success) {
        NSNumber *i = [success objectForKey:@"code"];
        switch ([i integerValue]) {
            case 0:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"链接失败" toView:self.view];
    }];
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
        [verificationTF becomeFirstResponder];
    }
    if (textField==verificationTF) {
        [newpwdTF becomeFirstResponder];
    }
    if (textField==newpwdTF) {
        [confirmnewpwdTF becomeFirstResponder];
    }
    if (textField==confirmnewpwdTF) {
        [textField resignFirstResponder];
        [self changepwdBtn];
    }
    
    return YES;
}

@end
