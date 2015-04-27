//
//  QuanKongShopListViewController.m
//  QuanKong
//
//  Created by POWER on 14/10/21.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongShopListViewController.h"

#import "QuanKongMapViewController.h"
#import "UITableView+Help.h"

@interface QuanKongShopListViewController ()

@end

@implementation QuanKongShopListViewController
{
    NSMutableArray *storeListArray;
    
    NSArray *titleArray;
}

@synthesize shopListTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = LIGHT_GRAY;
        
        //根据iOS版本判断界面起始位置
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        //UINavigationItem标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"门店列表";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        titleArray = [[NSArray alloc]initWithObjects:@"map_icon",@"phone_icon", nil];
        
        [LoadingHUDView showLoadinginView:self.view];
    }
    
    return self;
}

/**
 *  获取店铺列表信息
 *
 *  @param couponId 券ID
 */
- (void)getShopListWithCouponId:(NSString *)couponId
{
    NSString *shopListUrlStr = [NSString stringWithFormat:@"%@%@&couponModelId=%@&appKey=%@",NEW_HEAD_LINK,LIST_STORE,couponId,APP_KEY];
    
    [HTTPTool getWithPath:shopListUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            storeListArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            int listCout = ((NSMutableArray *)([success objectForKey:@"objList"])).count;
            
            for (int i = 0; i < listCout ; i++) {
                
                [storeListArray addObject:[QuanKongStore initWihtData:[[success objectForKey:@"objList"]objectAtIndex:i]]];
                
            }
            
            [self initTableView];
            
            [LoadingHUDView hideLoadingView];
            
        } else {
            
            [LoadingHUDView hideLoadingView];
            
            [self.view.window showHUDWithText:@"出错了" Enabled:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
}

/**
 *  创建店铺信息列表
 */
- (void)initTableView
{
    if (!shopListTableView) {
        
        shopListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        shopListTableView.delegate = self;
        shopListTableView.dataSource = self;
        shopListTableView.separatorColor = LIGHT_GRAY;
        
        if ([shopListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [shopListTableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
        }
        
        if ([shopListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [shopListTableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
        }
        
        [UITableView setExtraCellLineHidden:shopListTableView];
        
        [self.view insertSubview:shopListTableView atIndex:1];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return storeListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    QuanKongStore *storeDic = [storeListArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.userInteractionEnabled = YES;
    
    UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-60, 35)];
    shopNameLabel.backgroundColor = [UIColor clearColor];
    shopNameLabel.textAlignment = NSTextAlignmentLeft;
    shopNameLabel.textColor = [UIColor blackColor];
    shopNameLabel.font = [UIFont systemFontOfSize:14.0f];
    shopNameLabel.text = storeDic.name;
    
    [cell.contentView addSubview:shopNameLabel];
    
    UILabel *shopAdressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, WIDTH-65, 25)];
    shopAdressLabel.backgroundColor = [UIColor clearColor];
    shopAdressLabel.textAlignment = NSTextAlignmentLeft;
    shopAdressLabel.textColor = [UIColor grayColor];
    shopAdressLabel.font = [UIFont systemFontOfSize:13.0f];
    shopAdressLabel.text = [NSString stringWithFormat:@"地址：%@",storeDic.address];
    
    [cell.contentView addSubview:shopAdressLabel];
    
    UILabel *shopTelphoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, WIDTH-50, 25)];
    shopTelphoneLabel.backgroundColor = [UIColor clearColor];
    shopTelphoneLabel.textAlignment = NSTextAlignmentLeft;
    shopTelphoneLabel.textColor = [UIColor grayColor];
    shopTelphoneLabel.font = [UIFont systemFontOfSize:13.0f];
    shopTelphoneLabel.text = [NSString stringWithFormat:@"电话：%@",storeDic.telephone];
    
    UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-45, 15, 1, 55)];
    verLine.backgroundColor = LIGHT_GRAY;
    
    cell.contentView.userInteractionEnabled = YES;
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *functionButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-40, 10+35*i, 35, 30)];
        [functionButton setBackgroundImage:[UIImage imageNamed:[titleArray objectAtIndex:i]]
                                  forState:UIControlStateNormal];
        if(i==0){
            [functionButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            functionButton.tag = indexPath.row;
        }else{
            [functionButton addTarget:self action:@selector(functionButtonClickPhone:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.contentView addSubview:functionButton];
    }
    
    [cell.contentView addSubview:verLine];
    
    [cell.contentView addSubview:shopNameLabel];
    [cell.contentView addSubview:shopAdressLabel];
    [cell.contentView addSubview:shopTelphoneLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
    bgView.backgroundColor = LIGHT_GRAY;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    titleLabel.text = [NSString stringWithFormat:@"共%d个兑换点",storeListArray.count];
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

#pragma mark - button selector

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)functionButtonClick:(UIButton *)sender
{
    QuanKongMapViewController *mapViewController = [[QuanKongMapViewController alloc]init];
    
    [mapViewController setMapViewWith:((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).lat And:((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).lng And:((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).name And:((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).address];
    MyLog(@"lat-------%f;lng----------%f",((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).lat,((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).lng);
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

-(void)functionButtonClickPhone:(UIButton *)sender{
    if ([self checkDevice:@"iPhone"]) {
        
        NSMutableString *phoneNumStr = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",((QuanKongStore *)[storeListArray objectAtIndex:sender.tag]).telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
        
    } else {
        
        UIAlertView *warningAlertView = [[UIAlertView alloc]initWithTitle:@"你使用的设备不可以拨打电话" message:@"请更换设备再尝试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [warningAlertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  检测当前设备
 *
 *  @param name 设备名称
 *
 *  @return 是否检测的设备
 */
-(bool)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}


@end
