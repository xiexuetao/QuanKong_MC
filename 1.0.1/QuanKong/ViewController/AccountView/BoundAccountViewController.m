//
//  BoundAccountViewController.m
//  Kaiquan
//  绑定账号界面一级，包括微博跟微信绑定两个入口，基本完成
//  Created by rockcent on 14-8-15.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "BoundAccountViewController.h"
#import "UserInfo.h"
@interface BoundAccountViewController ()

@end

@implementation BoundAccountViewController

@synthesize mTableView;

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


#pragma mark-加入视图
/**
 *  视图初始化
 */
-(void)addMyView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)style:UITableViewStyleGrouped];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [self.view addSubview:mTableView];
    
}

#pragma mark-UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    
    return 0.1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"table number");
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell布局
    
        UILabel * lab2=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 0,100 , 50)];
        [cell.contentView addSubview:lab2];
        UIImageView * arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        arrow.frame=CGRectMake(0, 0, 10, 15);
        cell.accessoryView=arrow;
  
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=@"绑定新浪微博";
            lab2.text=[UserInfo shareUserInfo].weiboId;
            
        }
            break;
            case 1:
        {
            cell.textLabel.text=@"绑定微信";
            lab2.text=[UserInfo shareUserInfo].weChatOpenId;
        }
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
        case 0:
            
            break;
            case 1:
            
            break;
        default:
            break;
    }
}
#pragma mark-按钮点击处理
/**
 *  返回按钮点击处理
 *
 *  @param sender
 */
-(void)pushBack:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
