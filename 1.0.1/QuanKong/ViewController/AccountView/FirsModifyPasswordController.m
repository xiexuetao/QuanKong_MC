//
//  FirsModifyPasswordController.m
//  Kaiquan
//
//  Created by rick on 14-9-23.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//修改登录密码UI_1

#import "FirsModifyPasswordController.h"
#import "PasswrodMangerViewController.h"
#import "NextModifyPasswordController.h"
#import "HTTPTool.h"
#import "UserInfo.h"
#import "NSString+DisposeStr.h"
#import "UIWindow+AlertHud.h"
#import "UIButton+Extend.h"
@interface FirsModifyPasswordController (){
    NSNumber *_code;
}
@end

@implementation FirsModifyPasswordController

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

    //导航栏返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItemButton;
    
    //手机号码输入框
    self.phonenumberTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 50)];
    self.phonenumberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phonenumberTF.autocorrectionType = UITextAutocorrectionTypeYes;
    //    [self.phonenumberTF setDelegate:self];
    if (self.type == 1) {
        self.navigationItem.title = @"找回交易密码";
        self.phonenumberTF.text = [UserInfo shareUserInfo].phone;
        self.phonenumberTF.userInteractionEnabled = NO;
    }else{
        [self.phonenumberTF setPlaceholder:@"手机号码"];
        self.navigationItem.title = @"找回登录密码";
    }
    self.phonenumberTF.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:self.phonenumberTF];
    
    //分割线
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    
    //如果是找回登录密码
    if (self.type != 1) {
        
        //验证按钮
        self.verificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 0, 100,50)];
        self.verificationBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [self.verificationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verificationBtn addTarget:self action:@selector(verificationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.verificationBtn];

        
        //验证码输入框
        self.verificationTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH-20, 50)];
        self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.verificationTF setPlaceholder:@"请输入验证码"];
        [self.view addSubview:self.verificationTF];
        
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, WIDTH-20, 0.5)];
        line2.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:line2];
    }
    
    //下一步按钮
    self.nextBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, WIDTH-20, 40)];
    [self.nextBut setBackgroundColor:[UIColor orangeColor]];
    self.nextBut.layer.cornerRadius = 5.0;
    [self.nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBut addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextBut];
}

#pragma mark 点击下一步处理
-(void)nextStep:(UIButton *)but{
    
    if (self.phonenumberTF.text.length == 0) {
        [self.view.window showHUDWithText:@"手机号码不能为空" Enabled:YES];
    }else if (![NSString verificationPhone:self.phonenumberTF.text]){
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }else if (self.verificationTF.text.length == 0 && self.type !=1){
        [self.view.window showHUDWithText:@"验证码不能为空" Enabled:YES];
    }
    else{
//        NSString *str;
//        if (self.type == 1) {
//            str = [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,GET_PAY_SEND_CODE_METHOD,self.phonenumberTF.text,APP_KEY_MC];
//        }else{
//            str = [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,GET_LOGIN_CODE_METHOD,self.phonenumberTF.text,APP_KEY_MC];
//        }
        
//        [HTTPTool getWithPath:str success:^(id success) {
//            NSNumber *i = [success objectForKey:@"event"];
//            if ([i integerValue] == 0) {
//                NSString *code = [success objectForKey:@"obj"];
                if (([_code.stringValue isEqualToString:self.verificationTF.text]  && ![self.verificationTF.text isEqual:@""] && [NSString verificationPhone:self.phonenumberTF.text]) || self.type == 1) {
                    NextModifyPasswordController *next = [[NextModifyPasswordController alloc]init];
                    next.phoneNumber = self.phonenumberTF.text;
                    next.code = self.verificationTF.text;
                    next.type = self.type;
                    if (self.type == 1) {
                        next.navigationItem.title = @"重设交易密码";
                    }else{
                        next.navigationItem.title = @"重设登录密码";
                    }
                    [self.navigationController pushViewController:next animated:YES];
                }else{
                    [self.view.window showHUDWithText:@"验证码错误" Enabled:YES];
                }
                UserInfo *user = [UserInfo shareUserInfo];
                [user getUserInfoUsername:user.userName Token:user.token];
//            }else{
//                [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
//            }
//        } fail:^(NSError *error) {
//            [self.view.window showHUDWithText:@"请求失败" Enabled:YES];
//        }];
    }
}


#pragma mark - 验证码相关
/**
 *  获取验证按钮点击处理
 */
-(void)verificationBtnPressed{
    //验证用户是否存在
    NSString *isUsernameUrl = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,CHECK_USER_EXIST_METHOD,self.phonenumberTF.text,APP_KEY];
    if (self.phonenumberTF.text.length == 0) {
        [self.view.window showHUDWithText:@"手机号码不能为空" Enabled:YES];
    }else if (![NSString verificationPhone:self.phonenumberTF.text]){
        [self.view.window showHUDWithText:@"请正确填写手机号码" Enabled:YES];
    }else{
        [HTTPTool getWithPath:isUsernameUrl success:^(id success) {
            NSString *i = [success objectForKey:@"event"];
            if ([i isEqualToString:@"0"] && [success objectForKey:@"obj"]) {
                [self getVerification:self.phonenumberTF.text];
            }else{
                [self.view.window showHUDWithText:@"客户不存在" Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"请求失败" Enabled:YES];
        }];
    }
}

/**
 *  发送获取验证码网络请求
 *
 *  @param phonenumber 手机号码
 */
-(void)getVerification:(NSString *)phonenumber
{
        NSString *str;
        if (self.type == 1) {//交易密码
           str =  [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,GET_PAY_PASSWORD_METHOD,phonenumber,APP_KEY];
        }else{//重设登录密码
//           str = [NSString stringWithFormat:@"%@%@&phoneNum=%@&appKey=%@",NEW_HEAD_LINK,GET_LOGIN_PASSWORD_METHOD,phonenumber,APP_KEY];
            str = [NSString stringWithFormat:@"%@/face.jsp?phoneNum=%@",MC_HEAD_LINK,self.phonenumberTF.text];

        }
        [HTTPTool getWithPath: str success:^(id success) {
            NSNumber *i = [success objectForKey:@"event"];
            if ([i integerValue] == 0) {
                [UIButton disableVerificationBtnFor15s:self.verificationBtn];
                [self.view.window showHUDWithText:@"已发送" Enabled:YES];
                _code = [success objectForKey:@"obj"];
            } else {
                [self.view.window showHUDWithText:@"发送失败" Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"链接失败" Enabled:YES];
        }];
}



/**
 *  返回按钮点击处理
 *
 *  @param
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
