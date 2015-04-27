//
//  QuanKongNoticeDetailViewController.m
//  QuanKong
//
//  Created by POWER on 14/11/14.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongNoticeDetailViewController.h"

@interface QuanKongNoticeDetailViewController ()

@end

@implementation QuanKongNoticeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn_og.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [testButton setTitle:@"hide" forState:UIControlStateNormal];
        [testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *testItemButton = [[UIBarButtonItem alloc]initWithCustomView:testButton];
        
        [self.navigationItem setRightBarButtonItem:testItemButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor orangeColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"站内信";
        
        self.navigationItem.titleView = titleLabel;
        
    }
    return self;
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)testButtonClick:(UIButton *)sender
{
    [LoadingHUDView hideLoadingView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [LoadingHUDView showLoadinginView:self.view];
    
    NSLog(@"fuck");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
