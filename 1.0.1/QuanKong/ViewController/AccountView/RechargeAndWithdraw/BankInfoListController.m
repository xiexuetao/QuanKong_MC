//
//  BankInfoListController.m
//  QuanKong
//
//  Created by POWER on 1/14/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import "BankInfoListController.h"

@interface BankInfoListController ()

@end

@implementation BankInfoListController
{
    NSMutableArray *bankIdArray;
    NSMutableArray *bankLogoArray;
    NSMutableArray *bankNameArray;
}

- (void)viewDidLoad {
    
    [self initMainView];
    
    [self getBankInfo];

    [super viewDidLoad];

}

- (void)initMainView
{
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
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
    
    //UINavigationItem标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"选择银行";
    
    self.navigationItem.titleView = titleLabel;
    
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getBankInfo
{
    NSString *bankUrlStr = [NSString stringWithFormat:@"%@%@&appKey=%@",NEW_HEAD_LINK,BANK_LIST,APP_KEY];
    
    [HTTPTool getWithPath:bankUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            bankIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            bankLogoArray = [[NSMutableArray alloc]initWithCapacity:0];
            bankNameArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            NSMutableArray *bankInfoArray = [success objectForKey:@"objList"];
            
            NSLog(@"%@",bankInfoArray);
            
            for (int i = 0; i < bankInfoArray.count; i++) {
                
                NSString *bankId = [[bankInfoArray objectAtIndex:i]objectForKey:@"id"];
                NSString *bankLogoUrl = [[bankInfoArray objectAtIndex:i]objectForKey:@"logo"];
                NSString *bankName = [[bankInfoArray objectAtIndex:i]objectForKey:@"name"];
                
                [bankIdArray addObject:bankId];
                [bankLogoArray addObject:bankLogoUrl];
                [bankNameArray addObject:bankName];
                
            }
            
            [self.tableView reloadData];
            
        } else {
            
            [self.tableView.window showHUDWithText:[NSString stringWithFormat:@"获取银行信息失败，%@",msg] Enabled:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"NetWork Fail");
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [bankNameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    // Configure the cell...
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 130, 42)];
    
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[bankLogoArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [cell.contentView addSubview:iconView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectBankIdWithId:[bankIdArray objectAtIndex:indexPath.row] AndImageUrl:[bankLogoArray objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
