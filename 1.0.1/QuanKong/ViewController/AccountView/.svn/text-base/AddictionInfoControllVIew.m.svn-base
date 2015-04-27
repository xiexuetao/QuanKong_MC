//
//  AddictionInfoControllVIew.m
//  Kaiquan
//  附加信息界面，网络请求未完成
//  Created by rockcent on 14-8-6.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "AddictionInfoControllVIew.h"
#import "HTTPTool.h"
#import "UserInfo.h"
#import "AccountSecurityViewController.h"
#import "UIWindow+AlertHud.h"
#import "NSString+DisposeStr.h"
#import "UIButton+Extend.h"
@interface AddictionInfoControllVIew (){
    UITextField *_pswTF;
    UITextField *_confirmTF;
}

@end

@implementation AddictionInfoControllVIew


@synthesize verificaitonBtn;
@synthesize saveBtn;
@synthesize phonenumTF;
@synthesize verificaitonTF;

#pragma mark-系统方法
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
        [self.view setBackgroundColor:[UIColor whiteColor]];
      

        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.title = @"完善帐户信息";
    
    [self addMyView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark-加入控件
/**
 *  初始化视图
 */
-(void)addMyView
{
    //加入返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(SkipBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItemButton];
    
    //手机号码输入框
    phonenumTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    [phonenumTF setPlaceholder:@"手机号码"];
    [phonenumTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    phonenumTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phonenumTF.autocorrectionType = UITextAutocorrectionTypeYes;
    [phonenumTF setFont:[UIFont systemFontOfSize:17]];
    [phonenumTF setDelegate:self];
    [phonenumTF setText:@""];
    [phonenumTF setHighlighted:YES];
    [self.view addSubview:phonenumTF];
    
   //获取验证码按钮
    verificaitonBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 0, 100, 50)];
    verificaitonBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [verificaitonBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificaitonBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [verificaitonBtn addTarget:self action:@selector(verificaitonBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificaitonBtn];
    
    //分割线
    UIImageView * line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    //验证码输入框
     verificaitonTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    [verificaitonTF setPlaceholder:@"验证码"];
    [verificaitonTF setDelegate:self];
    verificaitonTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:verificaitonTF];
    
    //分割线
    UIImageView * line2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    _pswTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, WIDTH-20, 50)];
    _pswTF.secureTextEntry = YES;
    _pswTF.placeholder = @"请输入登录密码";
    _pswTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:_pswTF];
    
    //分割线
    UIImageView * line3=[[UIImageView alloc]initWithFrame:CGRectMake(10, 150, WIDTH-20, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3];
    
    _confirmTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, WIDTH-20, 50)];
    _confirmTF.secureTextEntry = YES;
    _confirmTF.placeholder = @"请输入确认密码";
    _confirmTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:_confirmTF];
    
    //分割线
    UIImageView * line4=[[UIImageView alloc]initWithFrame:CGRectMake(10, 200, WIDTH-20, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line4];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, WIDTH, 20)];
    la.font = [UIFont systemFontOfSize:13.f];
    la.textColor = [UIColor darkGrayColor];
    la.text = @"提示：完善信息后您下次可以使用手机号码登录";
    [self.view addSubview:la];
    
    
    //保存按钮
    saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 250, WIDTH-20, 40)];
    saveBtn.layer.cornerRadius=5.0f;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor orangeColor]];
    [saveBtn addTarget:self action:@selector(saveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    //跳过按钮
//    [self addSkipBtn];
    
}



/**
 *  添加导航栏右边跳过按钮
 */
-(void)addSkipBtn
{
    UIButton *skipBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(SkipBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *skipButtonItem = [[UIBarButtonItem alloc]initWithCustomView:skipBtn];
    [self.navigationItem setRightBarButtonItem:skipButtonItem];
}



#pragma  mark-按钮点击事件
/**
 *  获取验证码按钮点击处理
 */
-(void)verificaitonBtnPressed
{
    NSString *phone = self.phonenumTF.text;
    NSString *isUsernameUrl = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,CHECK_USER_EXIST_METHOD,phone,APP_KEY];
    if (phone.length == 0) {
        [self.view.window showHUDWithText:@"手机号码不能为空" Enabled:YES];
    }else if (![NSString verificationPhone:phone]){
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }else{
        [HTTPTool getWithPath:isUsernameUrl success:^(id success) {
            NSString *i = [success objectForKey:@"event"];
            if ([i isEqualToString:@"0"] && [success objectForKey:@"obj"]) {
                [self.view.window showHUDWithText:@"手机已绑定其他用户" Enabled:YES];
            }else{
                [self getVerfication:phone];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"请求失败" Enabled:YES];
        }];
    }
}



/**
 *  保存按钮点击处理
 */
-(void)saveBtnPressed
{
    [self addPhonenumInfoPhonenum:phonenumTF.text VerificationCode:verificaitonTF.text password:_pswTF.text confirmPsw:_confirmTF.text];
}



/**
 *  跳过按钮点击处理
 */
-(void)SkipBtnPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark-网络请求
/**
 *  发送添加手机号码的网络请求
 *
 *  @param phonenume         手机号码
 *  @param verificiationcode 验证码
 */
-(void)addPhonenumInfoPhonenum:(NSString *)phonenume VerificationCode:(NSString *)verificiationcode password:(NSString *)psw confirmPsw:(NSString *)confirm
{
    if (![NSString verificationPhone:phonenume]) {
        [self.view.window showHUDWithText:@"请输入正确的手机号码" Enabled:YES];
    }else if (![NSString verificationPassword:psw]){
        [self.view.window showHUDWithText:@"请输入6~15位密码"  Enabled:YES];
    }else if (![NSString verificationPassword:psw affirmPs:confirm]){
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else if(verificiationcode.length < 1){
        [self.view.window showHUDWithText:@"验证码不能为空" Enabled:YES];
    }else{
        UserInfo *user = [UserInfo shareUserInfo];
        NSString *str = [NSString stringWithFormat:@"%@%@&phoneNum=%@&loginName=%@&code=%@&loginPassword=%@&appKey=%@",NEW_HEAD_LINK,ADD_PHONE_METHOD,phonenume,user.userName,verificiationcode,[NSString md5:psw],APP_KEY];
        
        [HTTPTool getWithPath:str success:^(id success) {
           NSString *code = [success objectForKey:@"event"];
            if ([code isEqualToString:@"0"]) {
                [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
                if (self.type) {
                   NSArray *arr = self.navigationController.childViewControllers;
                    for (UIViewController *vc in arr) {
                        if ([vc isKindOfClass:AccountSecurityViewController.class]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
               
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
            }
            [user getUserInfoUsername:user.userName Token:user.token];
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"请求失败" Enabled:YES];
        }];
    }
}


/**
 *  获取验证码
 *
 *  @param phonenum 手机号码
 */
-(void)getVerfication:(NSString *)phonenum
{
    
        NSString *str = [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,SUPPLEMENTARY_METHOD,phonenum,APP_KEY];
        
        [HTTPTool getWithPath:str success:^(id success) {
           NSString *msg = [success objectForKey:@"msg"];
            if ([msg isEqualToString:@"success"]) {
                [UIButton disableVerificationBtnFor15s:verificaitonBtn];
                [self.view.window showHUDWithText:@"已发送" Enabled:YES];
            }else{
                [self.view.window showHUDWithText:@"发送失败" Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"请求失败" Enabled:YES];
        }];
    
}


/**
 * 放回按钮点击处理
 *
 *  @param sender
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (textField==phonenumTF) {
        [verificaitonTF becomeFirstResponder];
    }
    if (textField==verificaitonTF) {
        [verificaitonTF resignFirstResponder];
        [self saveBtnPressed];
    }
    
    
    return YES;
}


@end
