//
//  AccountSecurityViewController.m
//  Kaiquan
//  账号安全设置界面，基本完成
//  Created by rockcent on 14-8-15.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "PasswrodMangerViewController.h"
#import "FirsModifyPasswordController.h"
#import "LoginViewController.h"
#import "AddictionInfoControllVIew.h"
#import "UIWindow+AlertHud.h"
#import "UITableView+Help.h"
@interface AccountSecurityViewController ()

@end

@implementation AccountSecurityViewController
@synthesize mtableView;
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
        
        //加入返回
        [self.view setBackgroundColor:[UIColor whiteColor]];
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
        
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.title = @"账户安全";
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];
                // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [self addMyView];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark-加入视图
/**
 *  初始化视图
 */
-(void)addMyView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    mtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [UITableView setExtraCellLineHidden:mtableView];
    [mtableView setDelegate:self];
    [mtableView setDataSource:self];
    if ([mtableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [mtableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:mtableView];
    
}



#pragma mark-UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"table number");
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell布局
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        arrow.frame=CGRectMake(0, 0, 8, 12);
        cell.accessoryView = arrow;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"交易密码";
            break;
        case 1:
            cell.textLabel.text=@"登录密码";
            break;
        case 2:
            cell.textLabel.text=@"找回交易密码";
            break;
        default:
            break;
    }
    return cell;
    
    
}
#pragma mark-UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            //交易密码
        case 0:
            if ([UserInfo shareUserInfo].phone != nil) {
                [self.navigationController pushViewController:[[PasswrodMangerViewController alloc]initWithPasswrodType:0] animated:YES];
            }else{
                AddictionInfoControllVIew *add = [[AddictionInfoControllVIew alloc] init];
                add.type = YES;
                [self.navigationController pushViewController:add animated:YES];
            }
            break;
            //登录密码
        case 1:{
            if ([UserInfo shareUserInfo].phone != nil) {
                [self.navigationController pushViewController:[[PasswrodMangerViewController alloc]initWithPasswrodType:1] animated:YES];
            }else{
                AddictionInfoControllVIew *add = [[AddictionInfoControllVIew alloc] init];
                add.type = YES;
                [self.navigationController pushViewController:add animated:YES];
            }
        }
            break;
        case 2:
            //跳转到找回密码界面
        {
            if ([UserInfo shareUserInfo].phone != nil) {
                if ([[UserInfo shareUserInfo].isSetPayPass isEqualToString:@"1"]) {
                    FirsModifyPasswordController * tmp=[[FirsModifyPasswordController alloc]init];
                    tmp.hidesBottomBarWhenPushed=YES;
                    [[self navigationController] pushViewController:tmp animated:YES];
                    tmp.type = 1;
                }else{
                    [self.navigationController pushViewController:[[PasswrodMangerViewController alloc]initWithPasswrodType:0] animated:YES];
                }
            }else{
                AddictionInfoControllVIew *add = [[AddictionInfoControllVIew alloc] init];
                add.type = YES;
                [self.navigationController pushViewController:add animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark-按钮点击处理
/**
 *  放回按钮点击处理
 *
 *  @param sender
 */

-(void)pushBack:(id)sender

{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
