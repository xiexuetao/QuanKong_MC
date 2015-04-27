//
//  UserBankInfoViewController.m
//  QuanKong
//
//  Created by POWER on 1/12/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import "UserBankInfoController.h"

@interface UserBankInfoController ()

@end

@implementation UserBankInfoController
{
    NSDictionary *bankDic;
    
    UIImageView *selectView;
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
    
    UIButton *editorButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [editorButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editorButton setTitle:@"完成" forState:UIControlStateSelected];
    [editorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editorButton addTarget:self action:@selector(editorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editorItemButton = [[UIBarButtonItem alloc]initWithCustomView:editorButton];
    
    [self.navigationItem setRightBarButtonItem:editorItemButton];
    
    //UINavigationItem标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"我的银行卡";
    
    self.navigationItem.titleView = titleLabel;
    
}

- (void)viewDidLoad {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initMainView];
    
    [super viewDidLoad];
    
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editorButtonClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        selectView.hidden = YES;
        self.tableView.editing = YES;
        
    } else {
        
        sender.selected = NO;
        
        selectView.hidden = NO;
        self.tableView.editing = NO;
    }
}

- (void)buildTableViewWith:(NSDictionary *)bankInfoDic
{
    bankDic = bankInfoDic;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return 1;
    
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
            
        return 70;
        
    } else {
        
        return 40;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
            
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 130, 42)];
        
        [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[bankDic objectForKey:@"bankLogo"]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        
        NSString *accountNo = [bankDic objectForKey:@"accountNo"];
        NSRange rang = NSMakeRange(accountNo.length-4, 4);
        NSString *bankNoStr = [accountNo substringWithRange:rang];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, WIDTH-45, 15)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",[bankDic objectForKey:@"bankName"],bankNoStr];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32.5, WIDTH-135, 15)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:13.0f];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.text = [bankDic objectForKey:@"accountNo"];
        
        //选择提示标识
        selectView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-45, 12.5, 40, 45)];
        selectView.image = [UIImage imageNamed:@"pay_btn_enable_all"];
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:selectView];
        
    } else {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.text = @"添加银行卡";
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 12)];
        arrowImageView.image = [UIImage imageNamed:@"arrow_gray"];
        cell.accessoryView = arrowImageView;
        
        [cell.contentView addSubview:titleLabel];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self.view.window showHUDWithText:@"只能绑定一张银行卡" Enabled:YES];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    if (indexPath.section == 0) {
        
        return YES;
        
    } else {
    
        return NO;
        
    }
}

// Override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        UIActionSheet *deleteBankSheet = [[UIActionSheet alloc]initWithTitle:@"解绑后你的银行卡信息将会从服务器中删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        
        [deleteBankSheet showInView:self.view];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSString *deleteBankUrlStr = [NSString stringWithFormat:@"%@%@&id=%@&appKey=%@",NEW_HEAD_LINK,DELETE_BANK,[bankDic objectForKey:@"id"],APP_KEY];
        
        [HTTPTool getWithPath:deleteBankUrlStr success:^(id success) {
            
        NSString *msg = [success objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"success"]) {
                
                [self.view.window showHUDWithText:@"解绑银行卡成功" Enabled:YES];
                
                [self performSelector:@selector(pushBack:) withObject:nil afterDelay:2.0];
                
            } else {
                
                [self.view.window showHUDWithText:[NSString stringWithFormat:@"解绑失败，%@",msg] Enabled:YES];
            
            }
            
        } fail:^(NSError *error) {
            
            NSLog(@"netWork Fail");
            
        }];
        
    } else {
        
        NSLog(@"1");
    }
}

@end
