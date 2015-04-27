//
//  QuanKongNoticeViewController.m
//  QuanKong
//
//  Created by POWER on 14/10/31.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongNoticeViewController.h"
#import "QuanKongNoticeDetailViewController.h"

#import "noticeListCell.h"

#import "NSDate+Help.h"

@interface QuanKongNoticeViewController ()

@end

@implementation QuanKongNoticeViewController
{
    NSMutableArray *noticeIdArray;
    NSMutableArray *noticeTitleArray;
    NSMutableArray *noticeCreatTimeArray;
    NSMutableArray *noticeReadedArray;
    NSMutableArray *noticeContentArray;
    NSMutableArray *noticeTypeArray;
    NSMutableArray *noticeTemplateIdArray;
    
    int dataRows;
    
}

@synthesize notceTableView;

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)emptyViewWith:(NSString *)string
{
    UILabel *emptype = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2-60, WIDTH, 40)];
    emptype.backgroundColor = [UIColor clearColor];
    emptype.font = [UIFont systemFontOfSize:16.0f];
    emptype.textAlignment = NSTextAlignmentCenter;
    emptype.numberOfLines = 0;
    emptype.textColor = [UIColor lightGrayColor];
    emptype.text = string;
    
    [self.view addSubview:emptype];
}

- (void)initMainView
{
    if (!notceTableView) {
        
        notceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        notceTableView.backgroundColor = [UIColor whiteColor];
        notceTableView.dataSource = self;
        notceTableView.delegate = self;
        
    }
    
    [self setExtraCellLineHidden:notceTableView];
    
    [self.view addSubview:notceTableView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getUserNoticeMessage];
    
    //    [self emptyView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserNoticeMessage
{
    [LoadingHUDView showLoadinginView:self.view];
    
    NSString *noticeUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&currentPage=0&pageSize=20&appKey=%@",NEW_HEAD_LINK,LIST_MY_MESSAGE,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:noticeUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            NSArray *typeTitleArray = @[@"系统消息",@"二手交易",@"红包",@"退款",@"其他"];
            
            NSMutableArray *objList = [success objectForKey:@"objList"];
            
            noticeIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeTitleArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeCreatTimeArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeReadedArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeTemplateIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeTypeArray = [[NSMutableArray alloc]initWithCapacity:0];
            noticeContentArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            for (int i = 0; i < objList.count; i++) {
                
                NSString *noticeId = [[objList objectAtIndex:i]objectForKey:@"id"];
                NSString *noticeTitle = [[objList objectAtIndex:i]objectForKey:@"title"];
                NSString *noticeCreatTime = [[objList objectAtIndex:i]objectForKey:@"createtime"];
                NSString *noticeReaded = [[objList objectAtIndex:i]objectForKey:@"readed"];
                NSString *noticeTemplateId = [[objList objectAtIndex:i]objectForKey:@"templateid"];
                NSString *noticeType = [typeTitleArray objectAtIndex:[[[objList objectAtIndex:i]objectForKey:@"type"] intValue]];
                NSString *noticeContent = [[objList objectAtIndex:i]objectForKey:@"content"];
                
                NSString *noticeTimerStr = [NSDate getTimeStrWithString:noticeCreatTime];
                
                [noticeIdArray addObject:noticeId];
                [noticeTitleArray addObject:noticeTitle];
                [noticeCreatTimeArray addObject:noticeTimerStr];
                [noticeReadedArray addObject:noticeReaded];
                [noticeTypeArray addObject:noticeType];
                [noticeTemplateIdArray addObject:noticeTemplateId];
                [noticeContentArray addObject:noticeContent];
                
            }
            
            [LoadingHUDView hideLoadingView];
            
            if (noticeIdArray.count > 0) {
                
                [self initMainView];
                
            } else {
                
                [self emptyViewWith:@"亲，你还没有站内信"];
            }
            
        } else {
            
            [LoadingHUDView hideLoadingView];
            
            [self emptyViewWith:@"亲，你还没有站内信"];
        }

        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return [noticeIdArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    noticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[noticeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.userInteractionEnabled = YES;
    
    [cell.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"image complete");
    }];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"[%@]%@",[noticeTypeArray objectAtIndex:indexPath.row],[noticeTitleArray objectAtIndex:indexPath.row]];
    
    NSString *readTag = [noticeReadedArray objectAtIndex:indexPath.row];
    
    [readTag isEqualToString:@"0"]?(cell.badgeIcon.hidden = NO):(cell.badgeIcon.hidden=YES);
    
    NSMutableString *htmlStr = [[NSMutableString alloc]initWithString:[noticeContentArray objectAtIndex:indexPath.row]];
    
    NSString *web_text = [NSString stringWithFormat:@"<html>"
                          "<head>""<style>""a{text-decoration: none;-webkit-tap-highlight-color:transparent;}a:link{color:#000000}""body {font-family: \"%@\"; font-size: %f; color: %@;}""</style>""</head>""<body>%@</body>""<script>var i = 0,a = document.getElementsByTagName('a'),len = a.length;for(;i<len;i++){a[i].href='javascript:';}</script></html>", @"宋体", 12.0f,@"#000000",htmlStr];
    
    NSString *web_text_mingQuan = [web_text stringByReplacingOccurrencesOfString:@"券控" withString:@"会员魔方"];
    
    cell.timeLabel.text = [noticeCreatTimeArray objectAtIndex:indexPath.row];
    
    [cell.textWebView loadHTMLString:web_text_mingQuan baseURL:nil];
    [cell.textWebView setUserInteractionEnabled:NO];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [noticeReadedArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    
    [notceTableView reloadData];
    
    NSString *idStr = [noticeIdArray objectAtIndex:indexPath.row];
    
    NSString *readMessageUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&msgId=%@&appKey=%@",NEW_HEAD_LINK,READ_MY_MESSAGE,[UserInfo shareUserInfo].userName,idStr,APP_KEY];
    
    [HTTPTool getWithPath:readMessageUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
        } else {
            
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"netWork Fail");
        
    }];
    
    /*QuanKongNoticeDetailViewController *noticeDetailViewController = [[QuanKongNoticeDetailViewController alloc]init];
     
     [self.navigationController pushViewController:noticeDetailViewController animated:YES];*/
}

/**
 *  隐藏多余分割线
 *
 *  @param tableView 需要隐藏分割线的tableview
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}


@end
