//
//  SettingViewController.m
//  Created by rockcent on 14-8-6.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountSecurityViewController.h"
#import "BoundAccountViewController.h"
#import "UserInfo.h"
#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
@interface SettingViewController ()
@end

@implementation SettingViewController
@synthesize mtableView;
@synthesize titleArray;
@synthesize exitBtn;

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
        titleArray=[[NSArray alloc]initWithObjects:@"账户安全", nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];

    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addMyView];
    [super viewDidLoad];
    self.title = @"设置";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-视图添加
/**
 *  初始化视图
 */
-(void)addMyView
{
    //设置功能列表
    mtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)style:UITableViewStyleGrouped];
//    mtableView.scrollEnabled=NO;
    [mtableView setDelegate:self];
    [mtableView setDataSource:self];
    if ([mtableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mtableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:mtableView];
    //退出按钮
    exitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 40)];
    exitBtn.backgroundColor=[UIColor orangeColor];
    exitBtn.layer.cornerRadius=5.0;
    
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    exitBtn.titleLabel.textColor=[UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(clickExit:) forControlEvents:UIControlEventTouchUpInside];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [subView addSubview:exitBtn];
    mtableView.tableFooterView = subView;
//    [self.view addSubview:exitBtn];
    
}

#pragma mark 点击退出按钮的处理
-(void)clickExit:(UIButton *)but{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"确定注销登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self logoutName:[UserInfo shareUserInfo].userName];
    }
}


/**
 *  登出发送网络请求
 *
 *  @param name 用户名
 */
-(void)logoutName:(NSString *)name
{
    NSString *url = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@&loginOS=%@",NEW_HEAD_LINK,LOGOUT_METHOD,name,APP_KEY,@0];
        [HTTPTool getWithPath:url success:^(id success) {
            //处理结果
            NSString * i=[success objectForKey:@"event"];
            if([i isEqualToString:@"0"]) {
                [UserInfo shareUserInfo].isLogined=NO;
                [UserInfo shareUserInfo].userName=nil;
                [UserInfo shareUserInfo].token=nil;
                [UserInfo shareUserInfo].weibotoken=nil;
                [UserInfo shareUserInfo].account = nil;
                [UserInfo shareUserInfo].isRealnameAuth = nil;
                [UserInfo shareUserInfo].realName = nil;
                [[UserInfo shareUserInfo] setBankSelect:NO];
                NSUserDefaults *userDefaukts =[NSUserDefaults standardUserDefaults];
                [userDefaukts removeObjectForKey:@"isLogined"];
                [userDefaukts removeObjectForKey:@"userName"];
                [userDefaukts removeObjectForKey:@"weibotoken"];
                [userDefaukts removeObjectForKey:@"account"];
                [userDefaukts removeObjectForKey:@"bankSelect"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
            }

        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败！" Enabled:YES];
        }];
}


#pragma mark-UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"table number");
    if (section==0)
        return 1;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      //cell布局
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        //文字
        cell.textLabel.text=[titleArray objectAtIndex:indexPath.row+indexPath.section*3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
         UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        arrow.frame=CGRectMake(0, 0, 8, 12);
        cell.accessoryView = arrow;
    }
    
    UILabel *title=(UILabel *)[cell viewWithTag:22];
    [title setText:[titleArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark-UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row+indexPath.section*3) {
            //用户信息
            case 0:
            [self.navigationController pushViewController:[[AccountSecurityViewController alloc]init] animated:YES];
            break;
            //账户安全
            case 1:
            
            break;
            //资金管理
            case 2:
            [self.view.window showHUDWithText:@"开发中敬请关注···" Enabled:YES];
            break;
            //账号绑定
            case 3:
            [self.view.window showHUDWithText:@"开发中敬请关注···" Enabled:YES];
            break;
        case 4:
            [self.view.window showHUDWithText:@"开发中敬请关注···" Enabled:YES];
            break;
        default:
            break;
    }
}

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
