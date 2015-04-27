//
//  ChangePhoneViewController.m
//  Kaiquan
//  修改绑定手机界面，未完成
//  Created by rockcent on 14-8-14.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()

@end

@implementation ChangePhoneViewController

@synthesize theNewPhoneTF;
@synthesize verificationTF;
@synthesize getVerificationBtn;
@synthesize changeBtn;
#pragma mark-


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


/**
 *  初始化视图
 */
-(void)addMyView
{
    
    UITextField *oldPhone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 2, 50)];
    oldPhone.placeholder = @"请输入原手机号码";
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but setTitle:@"获取验证码"forState:UIControlStateNormal];
    but.frame = CGRectMake(WIDTH-100, 0, 100, 50);
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    iv.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *verification = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, WIDTH - 2, 50)];
    verification.placeholder = @"请输入验证码";

    
    UIButton *affirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    affirm.titleLabel.text = @"提交";
    affirm.bounds = CGRectMake(0, 0, WIDTH/2, 40);
    affirm.center = CGPointMake(10, 120);
    affirm.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:oldPhone];
    [self.view addSubview:iv];
    [self.view addSubview:but];
    [self.view addSubview:verification];
    [self.view addSubview:affirm];
    
}

@end
