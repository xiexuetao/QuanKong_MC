//
//  QuanKongCityViewController.m
//  QuanKong
//
//  Created by POWER on 14-9-18.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongCityViewController.h"

@interface QuanKongCityViewController ()

@end

@implementation QuanKongCityViewController
{
    
    NSMutableArray *keys;
    NSMutableArray *arrayCitys;
    NSMutableArray *arrayHotCity;
    NSMutableArray *arrayLoadCity;
}

@synthesize cityTableView;
@synthesize cities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //        self.view.backgroundColor = [UIColor whiteColor];
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"选择地点";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        //热门城市数组
        arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"西安",@"重庆",@"沈阳",@"青岛",@"济南",@"深圳",@"长沙",@"无锡", nil];
        //默认城市数组
        arrayLoadCity = [NSMutableArray arrayWithObject:@"广州"];
        
        //关键字数组
        keys = [NSMutableArray array];
        //
        arrayCitys = [NSMutableArray array];
        
    }
    return self;
}

/**
 *  创建城市列表
 */
- (void)initTableView
{
    if (!cityTableView) {
        
        cityTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        cityTableView.delegate = self;
        cityTableView.dataSource = self;
        cityTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        cityTableView.backgroundColor = [UIColor whiteColor];
        
        [self.view insertSubview:cityTableView atIndex:1];
        
    }
}

#pragma mark - 获取城市数据

/**
 *  获取城市数据
 */
-(void)getCityData
{
    cities = [[NSMutableDictionary alloc]initWithCapacity:0];;
    
    [keys addObjectsFromArray:[[cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    
    NSString *strLoad = @"定";
    
    [keys insertObject:strLoad atIndex:0];
    
    [keys insertObject:strHot atIndex:1];
    
    [cities setObject:arrayHotCity forKey:strHot];
    
    [cities setObject:arrayLoadCity forKey:strLoad];
}

#pragma mark - tableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    bgView.backgroundColor = BACKGROUND_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [keys objectAtIndex:section];
    
    if ([key rangeOfString:@"定"].location != NSNotFound) {
        
        titleLabel.text = @"定位城市";
        
    } else if ([key rangeOfString:@"热"].location != NSNotFound) {
        
        titleLabel.text = @"热门城市";
        
    }
    
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [keys objectAtIndex:section];
    
    NSArray *citySection = [cities objectForKey:key];
    
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    
    cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [keys objectAtIndex:indexPath.section];
    
    //讲数据储存到userDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:[[cities objectForKey:key]objectAtIndex:indexPath.row] forKey:@"city"];
    
    [userDefaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - button selector

/**
 *  退出按钮
 *
 *  @param sender id
 */
- (void)backButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCityData];
    
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"释放了一个控件");
}

@end
