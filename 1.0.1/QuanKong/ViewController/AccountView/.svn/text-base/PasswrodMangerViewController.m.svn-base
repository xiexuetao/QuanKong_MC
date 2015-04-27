//
//  PasswrodMangerViewController.m
//  Kaiquan
//  修改密码界面，修改登录密码跟交易密码用同一个viewContrll
//  Created by rockcent on 14-8-18.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "PasswrodMangerViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+DisposeStr.h"
#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
@interface PasswrodMangerViewController ()

@end

@implementation PasswrodMangerViewController

@synthesize originalTF;
@synthesize theNewPasswordTF;
@synthesize confirmPasswordTF;
@synthesize okBtn;
@synthesize passwordType;//0 交易密码 1 登录密码
/**
 *  初始化viewControll 再次区分是交易密码的修改页面，还是登录密码的修改页面
 *
 *  @param type  区分是什么的修改页面 ：0 交易密码 1 登录密码
 *
 *  @return
 */
-(id)initWithPasswrodType:(NSInteger)type
{
    passwordType=type;
    return [super init];
}

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
        //加入返回
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
        
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self addMyView];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-视图添加
-(void)addMyView
{
    
    if (passwordType==0) {//交易密码界面
        if ([[UserInfo shareUserInfo].isSetPayPass intValue]) {
            [self initChangeView];
        }
        else
        {
            [self initSetView];
        }
        
    }
    else//修改密码界面
    {
        if ([[UserInfo shareUserInfo].isSetLoginPass intValue]) {
            [self initChangeView];
        }else{
            [self initSetView];
        }
    }

}
/**
 *  如果用户已经设置密码调用，初始化修改密码界面
 */
-(void)initChangeView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    originalTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    originalTF.placeholder=@"请输入原密码";
    originalTF.secureTextEntry = YES;
    originalTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 50, WIDTH-10, 0.5)];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
    
    
    
    theNewPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    theNewPasswordTF.placeholder=@"请输入6~15位新密码";
    theNewPasswordTF.secureTextEntry = YES;
    theNewPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    UIImageView * line1ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 100, WIDTH-10, 0.5)];
    line1ImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1ImageView];
    
    
    confirmPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 50)];
    confirmPasswordTF.placeholder=@"请输入确认密码";
    confirmPasswordTF.secureTextEntry = YES;
    confirmPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    UIImageView * line2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 0.5)];
    line2ImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2ImageView];
    
    okBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 200, WIDTH-20, 40)];
    okBtn.layer.cornerRadius=5.0;
    [okBtn setBackgroundColor:[UIColor orangeColor]];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (passwordType==0) {
        self.navigationItem.title = @"修改交易密码";
    }else{
        self.navigationItem.title = @"修改登录密码";
    }

    [self.view addSubview:originalTF];
    [self.view addSubview:theNewPasswordTF];
    [self.view addSubview:confirmPasswordTF];
    [self.view addSubview:okBtn];
}

/**
 *  如果用户为设置密码，调用初始化界面
 */
-(void)initSetView
{
    if (passwordType==0) {
        self.navigationItem.title = @"设置交易密码";
    }else{
        //        tishi.text =  @"";
        self.navigationItem.title = @"设置登录密码";
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    theNewPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    theNewPasswordTF.placeholder=@"请输入密码";
    UIImageView * line1ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 50, WIDTH-10, 0.5)];
    theNewPasswordTF.secureTextEntry = YES;
    theNewPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    line1ImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1ImageView];
    
    confirmPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
    confirmPasswordTF.placeholder=@"请输入确认密码";
    confirmPasswordTF.secureTextEntry = YES;
    confirmPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    UIImageView * line2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 100, WIDTH, 0.5)];
    line2ImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2ImageView];
    
    if (passwordType == 0) {
        self.loginPsw = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
        self.loginPsw.placeholder = @"请输入登录密码";
        self.loginPsw.secureTextEntry = YES;
        self.loginPsw.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self.view addSubview:self.loginPsw];
        
        theNewPasswordTF.frame = CGRectMake(10, 50, WIDTH-20, 50);
        
        confirmPasswordTF.frame = CGRectMake(10, 100, WIDTH-20, 50);
        
        UIImageView * line2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 0.5)];
        line2ImageView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line2ImageView];
        
        UILabel *tishi = [[UILabel alloc] initWithFrame:CGRectMake(12, 151, WIDTH-20, 50)];
        tishi.font = [UIFont fontWithName:@"Helvetica" size:12];
        tishi.alpha = 0.8;
        tishi.text = @"设置交易密码，可以提升您账户资金的安全";
        [self.view addSubview:tishi];
        
        okBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 200, WIDTH-20, 40)];
        
    }else{
        okBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 150, WIDTH-20, 40)];
    }
    okBtn.layer.cornerRadius=5.0;
    [okBtn setBackgroundColor:[UIColor orangeColor]];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:originalTF];
    [self.view addSubview:theNewPasswordTF];
    [self.view addSubview:confirmPasswordTF];
    [self.view addSubview:okBtn];
}

#pragma mark 按钮点击处理时间
/**
 *  确认按钮点击处理
 */
-(void)okBtnPressed
{
    switch (passwordType) {
            //交易密码
        case 0:
        {
            if ([[UserInfo shareUserInfo].isSetPayPass intValue]) {
                [self changeTradePassWordWithNew:theNewPasswordTF.text old:originalTF.text confirm:confirmPasswordTF.text];
            }else{
                [self setTradePasswordWithPassword:theNewPasswordTF.text affirmPs:confirmPasswordTF.text];
            }
            
        }
            break;
            //登录密码
        case 1:
        {
            if ([UserInfo shareUserInfo].isSetLoginPass) {
                [self changeLoginPassWordWithNew: theNewPasswordTF.text old:originalTF.text confirm:confirmPasswordTF.text];
            }else{
                [self setLoginPasswordWithPassword:theNewPasswordTF.text affirmPs:confirmPasswordTF.text];
            }
        }
            break;
        default:
            break;
    }
}

/**
 *  返回按钮点击处理
 *
 *  @param sender
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 网络请求
#pragma mark -
/**
 *  设置交易密码
 *
 *  @param password 交易密码
 */
-(void)setTradePasswordWithPassword:(NSString *)password affirmPs:(NSString *)confirm
{
    
    if(self.loginPsw.text.length == 0){
        [self.view.window showHUDWithText:@"请输入登录密码" Enabled:YES];
    }else if(![NSString verificationPassword:self.loginPsw.text]){
        [self.view.window showHUDWithText:@"登录密码位数不正确" Enabled:YES];
    }else if(password.length == 0){
        [self.view.window showHUDWithText:@"请输入交易密码" Enabled:YES];
    }else if(![NSString verificationPassword:password]){
        [self.view.window showHUDWithText:@"交易密码位数不正确" Enabled:YES];
    }else if(confirm.length == 0){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else if (![NSString verificationPassword:password affirmPs:confirm]){
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else{
        NSString * str=[NSString stringWithFormat:@"%@%@&loginName=%@&payPassword=%@&appKey=%@&loginPassword=%@",NEW_HEAD_LINK,PAY_PASSWORD_METHOD,[UserInfo shareUserInfo].userName,[NSString md5:password],APP_KEY,[NSString md5:self.loginPsw.text]];
        NSLog(@"%@",str);
        [self changePassWord:str];
    }

}

/**
 *  设置登录密码
 *
 *  @param password 登录密码
 */
-(void)setLoginPasswordWithPassword:(NSString *)password affirmPs:(NSString *)confirm
{
    if(password.length == 0){
        [self.view.window showHUDWithText:@"请输入登录密码" Enabled:YES];
    }else if(![NSString verificationPassword:password]){
        [self.view.window showHUDWithText:@"登录密码位数不正确" Enabled:YES];
    }else if(confirm.length == 0){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else if (![NSString verificationPassword:password affirmPs:confirm]){
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else{
        NSString * str = [NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&appKey=%@",NEW_HEAD_LINK,SET_LOGIN_PASSWORD_METHOD,[UserInfo shareUserInfo].userName,[NSString md5:password],APP_KEY];
        [self changePassWord:str];
    }
}



/**
 *  修改交易密码
 *
 *  @param theNewPassword 新的交易密码
 *  @param oldPassword    旧的交易密码
 */
-(void)changeTradePassWordWithNew:(NSString *)theNewPassword old:(NSString *)oldPassword confirm:(NSString *)confirm
{
    if ([oldPassword isEqualToString:@""]) {
        [self.view.window showHUDWithText:@"原密码不能为空" Enabled:YES];
    }else if([theNewPassword isEqualToString:@""]){
        [self.view.window showHUDWithText:@"新密码不能为空" Enabled:YES];
    }else if(![NSString verificationPassword:theNewPassword]){
        [self.view.window showHUDWithText:@"新密码长度或填写不正确"Enabled:YES];
    }else if([confirm isEqualToString:@""]){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else if(![NSString verificationPassword:theNewPassword affirmPs:confirm]){
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else{
        NSString * str = [NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&newPassword=%@&appKey=%@",NEW_HEAD_LINK,UPDATE_PAYPSW_METHOD,[UserInfo shareUserInfo].userName,[NSString md5:oldPassword],[NSString md5:theNewPassword],APP_KEY];
        [self changePassWord:str];
    }
}

/**
 *  修改登录密码
 *
 *  @param theNewPassword 新的登录密码
 *  @param oldPassword    旧的登录面膜
 */
-(void)changeLoginPassWordWithNew:(NSString *)theNewPassword old:(NSString *)oldPassword confirm:(NSString *)confirm
{
    if ([oldPassword isEqualToString:@""]) {
        [self.view.window showHUDWithText:@"原密码不能为空" Enabled:YES];
    }else if([theNewPassword isEqualToString:@""]){
        [self.view.window showHUDWithText:@"新密码不能为空" Enabled:YES];
    }else if(![NSString verificationPassword:theNewPassword]){
        [self.view.window showHUDWithText:@"新密码长度或填写不正确" Enabled:YES];
    }else if([confirm isEqualToString:@""]){
        [self.view.window showHUDWithText:@"请输入确认密码" Enabled:YES];
    }else if(![NSString verificationPassword:theNewPassword affirmPs:confirm]){
        [self.view.window showHUDWithText:@"二次输入密码不一致" Enabled:YES];
    }else{
//        NSString * str=[NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&newPassword=%@&appKey=%@",NEW_HEAD_LINK,UPDATE_LOGIN_PASSWORD_METHOD,[UserInfo shareUserInfo].userName,[NSString md5:originalTF.text],[NSString md5:theNewPasswordTF.text],APP_KEY];
        
        NSString * str=[NSString stringWithFormat:@"%@%@&loginName=%@&password=%@&newPassword=%@&appKey=%@&mcPassword=%@&mcNewPassword=%@",NEW_HEAD_LINK,UPDATE_LOGIN_PASSWORD_METHOD,[UserInfo shareUserInfo].userName,[NSString md5:originalTF.text],[NSString md5:theNewPasswordTF.text],APP_KEY_MC,[NSString md5_MC:originalTF.text],[NSString md5_MC:theNewPasswordTF.text]];
        
        [self changePassWord:str];
    }
}

-(void)changePassWord:(NSString *)str{
    [HTTPTool getWithPath:str success:^(id success) {
        NSString * i=[success objectForKey:@"event"];
        if ([i isEqualToString:@"0"]) {
            UserInfo *user = [UserInfo shareUserInfo];
            [self.view.window showHUDWithText:@"操作成功" Enabled:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
            [user getUserInfoUsername:user.userName Token:user.token];
        } else {
                [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"链接失败" Enabled:YES];
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
