//
//  QuanKongHomeViewController.m
//  QuanKong
//
//  Created by POWER on 14-9-16.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongHomeViewController.h"
#import "QuanKongCityViewController.h"
#import "QuanKongCouponDetailViewController.h"
#import "QuanKongQRcodeViewController.h"
#import "QuanKongNoticeViewController.h"
#import "QuanKongSearchViewController.h"


@interface QuanKongHomeViewController (){
    
    BOOL _searchData;//标识切换搜索tableview
    
    UITableView *_searchTableView;//搜索tableview
}

@end

@implementation QuanKongHomeViewController
{
    //券信息数组
    NSMutableArray *couponListArray;
    
    //券列表标识
    NSString *tagStr;
    
    //上架加载控件
    LoadMoreTableFooterView *loadMoreTableFooterView;
    //加载状态标识
    BOOL isLoadMoreing;
    //加载页数
    int dataRows;
}

@synthesize msearchBar;
@synthesize couponTableView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //根据系统版本调整高度起始位置
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        //创建页面默认显示最热的券
        tagStr = LIST_HOT_COUPON;
        
        //加载页数，初始化页面开始为1
        dataRows = 1;
        
        [LoadingHUDView showLoadinginView:self.view];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*//判断是否有定位城市
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefaults objectForKey:@"city"];
    
    if (city == NULL) {
        
        CRNavigationController *senderNoticeNav = [[CRNavigationController alloc]initWithRootViewController:[[QuanKongCityViewController alloc]init]];
        
        senderNoticeNav.navigationBar.barTintColor = ROCKCENT_ORANGE;
        
        [self presentViewController:senderNoticeNav animated:YES completion:nil];
        
    }
    
    [self initNavigationItemButtonWithStr:city];*/
}

/**
 *  根据 券列表标识 及 页数获 取券列表信息
 *
 *  @param couponTag  券列表标识
 *  @param couponPage 页数获
 */
- (void)getCouponDataWithTag:(NSString *)couponTag andPage:(NSString *)couponPage
{
    
    //券的请求链接,每次请求固定20张券的信息
    NSString *kcouponUrlStr = [NSString stringWithFormat:@"%@%@&pageSize=20&currentPage=%@&appKey=%@",NEW_HEAD_LINK,couponTag,couponPage,APP_KEY];
    
    NSLog(@"%@",kcouponUrlStr);
    
    [HTTPTool getWithPath:kcouponUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if([msg isEqualToString:@"success"]) {
            
            //根据加载次数决定是否刷新券的数据数组
            //页面初始化时，重设数据数组
            
            if (dataRows == 1) {
                
                couponListArray = [[NSMutableArray alloc]initWithCapacity:0];
            }
            
            int listCount = ((NSMutableArray *)[success objectForKey:@"objList"]).count;
            
            for (int i = 0; i < listCount; i++) {
                
                [couponListArray addObject:[QuanKongVoucher initWihtData:[[success objectForKey:@"objList"]objectAtIndex:i]]];

            }
            
            if (dataRows == 1) {
                
                //创建券的显示列表
                [self initCouponTableView];
            }
            
            //取消加载状态
            isLoadMoreing = NO;
            
            [self reloadData];
            
        } else {
            
            //请求错误警告
            UIAlertView *failAlertView = [[UIAlertView alloc]initWithTitle:@"出错了~" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [failAlertView show];
            
        }
        
    } fail:^(NSError *error) {
        
        //网络出错提示
        [LoadingHUDView hideLoadingView];
        
    }];
    
    //关闭提示
    [LoadingHUDView hideLoadingView];
    
    //刷新列表
    [self reloadData];
    
}

/**
 *  创建搜索栏
 */
- (void)initSearchBar
{
    if (!msearchBar) {
        
        msearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
        msearchBar.delegate = self;
        msearchBar.backgroundImage = [UIImage imageNamed:@"searchBar_Bg.png"];
        msearchBar.placeholder = @"请输入关键字";
        msearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        msearchBar.showsCancelButton = NO;
        [msearchBar setImage:[UIImage imageNamed:@"search_bar_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
    
    UIView *view = msearchBar.subviews[0];
    
    UITextField *textField = view.subviews[1];
    textField.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:103.0/255.0 blue:0 alpha:1.0];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = [UIColor whiteColor];
    textField.bounds = CGRectMake(0, 6,160, 32);    //    //透明色background
    
    self.navigationItem.titleView = msearchBar;
    msearchBar.delegate = self;
    
}

/**
 *  创建城市选择按钮（导航栏->左）
 *
 *  @param cityName 默认按钮名称
 */
- (void)initNavigationItemButtonWithStr:(NSString *)cityName
{
    UIButton *cityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 20)];
    cityButton.backgroundColor = [UIColor clearColor];
    cityButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    cityButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [cityButton setTitle:cityName forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [cityButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(38, 8, 13, 8)];
    arrowView.image = [UIImage imageNamed:@"city_arrow"];
    
    [cityButton addSubview:arrowView];
    
    UIBarButtonItem *cityButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cityButton];
    
    self.navigationItem.leftBarButtonItem = cityButtonItem;
    
}

/**
 *  创建二维码扫描及消息按钮(导航栏->右)
 */
-(void)createRightItems{
    
    //消息按钮
    UIButton *messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 18)];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"message_btn"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *messageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    messageButtonItem.badgeBGColor = [UIColor redColor];
    messageButtonItem.badgeValue = @"4";
    messageButtonItem.badge.hidden = YES;
    
    //二维码扫描按钮
    UIButton *qrcodeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25 , 18)];
    [qrcodeButton setBackgroundImage:[UIImage imageNamed:@"qr_code_btn"] forState:UIControlStateNormal];
    [qrcodeButton addTarget:self action:@selector(qrcodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *qrcodeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:qrcodeButton];
    
    NSArray *rightButtonItems = [[NSArray alloc]initWithObjects:qrcodeButtonItem, nil];
    
    self.navigationItem.rightBarButtonItems = rightButtonItems;
}

/**
 *  创建券列表
 */
- (void)initCouponTableView
{
    //取消加载状态
    isLoadMoreing = NO;
    
    if (!couponTableView) {
        
        couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-45-64) style:UITableViewStylePlain];
        couponTableView.delegate = self;
        couponTableView.dataSource = self;
        couponTableView.backgroundColor = [UIColor clearColor];
        couponTableView.separatorColor = LIGHT_GRAY;
        [self.view insertSubview:couponTableView atIndex:1];
        
    } else {
        
        [couponTableView reloadData];
        
    }
    
    //创建上拉加载更多控件
    if (!loadMoreTableFooterView) {
        
        loadMoreTableFooterView = [[LoadMoreTableFooterView alloc]initWithFrame:CGRectMake(0.0f, couponTableView.contentSize.height, couponTableView.frame.size.width, couponTableView.bounds.size.height)];
        
        loadMoreTableFooterView.delegate = self;
        
        [couponTableView addSubview:loadMoreTableFooterView];
        
    }
    
    [self reloadData];
    
}

#pragma mark - tableView dataSource

//方法类型：系统方法
//编   写：peter
//方法功能：返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

//方法类型：系统方法
//编   写：peter
//方法功能：返回tableViewCell 的个数 = 问题的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return couponListArray.count;
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 113;
        
    } else {
        
        return 95;
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        return 50;
        
    } else {
        
        return 0;
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的根部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlewCell 的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据section区别标识符，防止不同得section的cell重用
    NSString *identifier = [NSString stringWithFormat:@"status_%d",indexPath.section];
    
    couponLIstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    QuanKongVoucher *couponDic = [couponListArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = [[couponLIstViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //section->0
        if (indexPath.section == 0) {
            
            //广告页控件
            UIScrollView *adBgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 113)];
            adBgScrollView.backgroundColor = [UIColor clearColor];
            adBgScrollView.pagingEnabled = YES;
            adBgScrollView.delegate = self;
            adBgScrollView.showsHorizontalScrollIndicator = NO;
            adBgScrollView.contentSize = CGSizeMake(WIDTH*1, 113);
            
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 88, 120, 25)];
            pageControl.numberOfPages = 1;
            pageControl.currentPage = 0;
            
            //加载广告图
            for (int i = 0; i < 1; i++) {
                
                UIImageView *addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+WIDTH*i, 0, WIDTH, 113)];
                addImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner_rockcent_0"]];
                
                [adBgScrollView addSubview:addImageView];
            }
            
            [cell.contentView addSubview:adBgScrollView];
            [cell.contentView insertSubview:pageControl aboveSubview:adBgScrollView];
        }
    }
    
    if (indexPath.section == 1) {
        
        NSArray *picArray = [couponDic.picUrl componentsSeparatedByString:@";"];
        
        //券的的图片
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[picArray objectAtIndex:0]]]
                              placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
        
        //券的名称
        cell.titleLabel.text = couponDic.name;
        
        //券的介绍
        cell.introduceLabel.text = couponDic.introduce;
        
        //券的折扣
        NSString *discountStr = [NSString stringWithFormat:@"%i",couponDic.discount];;
        
        //根据couponTypeStr对不同的
        switch (couponDic.type) {
            //现金券
            case 0:
            {
                //券标识图
                cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_0.png"];
                
                //优惠价字体大小颜色设置
                NSString *estimateStr = [NSString stringWithFormat:@"%@元",couponDic.estimateAmount];
                
                NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
                
                [estimateAmountStr addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor orangeColor]
                                          range:NSMakeRange(0, estimateStr.length)];
                
                [estimateAmountStr addAttribute:NSFontAttributeName
                                          value:[UIFont systemFontOfSize:19.0f]
                                          range:NSMakeRange(0, estimateStr.length)];
                
                cell.valueLabel.attributedText = estimateAmountStr;
                
                //原价字体大小颜色设置
                float estimateStrLength = [NSString widthOfString:estimateStr withFont:[UIFont systemFontOfSize:19.0f]];
                NSString *faceStr = [NSString stringWithFormat:@"%@元",couponDic.faceValue];
                NSMutableAttributedString *faceValueStr = [[NSMutableAttributedString alloc]initWithString:faceStr];
                
                [faceValueStr addAttribute:NSStrikethroughStyleAttributeName
                                     value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                                     range:NSMakeRange(0, faceStr.length)];
                
                cell.cutValueLabel.frame = CGRectMake(105+estimateStrLength+5, 69, WIDTH-estimateStrLength-120, 20);
                cell.cutValueLabel.attributedText = faceValueStr;
                
            }
                break;
            //折扣券和抵用券
            case 1:
            {
                cell.valueLabel.textColor = [UIColor grayColor];
                cell.valueLabel.font = [UIFont systemFontOfSize:12.0f];
                
                //折扣券
                if ([discountStr intValue] > 0) {
                    
                    cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_1.png"];
                    
                    //折扣券信息字体大小颜色设置
                    NSString *discountStr = [[NSString alloc]init];
                    
                    couponDic.discount%10 == 0?(discountStr = [NSString stringWithFormat:@"%.0f",couponDic.discount*0.1]):(discountStr = [NSString stringWithFormat:@"%.1f",couponDic.discount*0.1]);
                    
                    NSMutableAttributedString *countValueAtr = [[NSMutableAttributedString alloc]init];
                    NSString *miniAmountStr = [NSString stringWithFormat:@"%ld",(long)couponDic.miniAmount];
                    
                    couponDic.miniAmount == 0?(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",discountStr]]):(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%ld元享%@折",(long)couponDic.miniAmount,discountStr]]);
                    
                    couponDic.miniAmount == 0?[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                                    value:[UIColor orangeColor]
                                                                    range:NSMakeRange(0, 1+discountStr.length)]
                                             :[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                                    value:[UIColor orangeColor]
                                                                    range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                    
                    couponDic.miniAmount == 0?[countValueAtr addAttribute:NSFontAttributeName
                                                                    value:[UIFont systemFontOfSize:19.0f]
                                                                    range:NSMakeRange(0, 1+discountStr.length)]
                                             :[countValueAtr addAttribute:NSFontAttributeName
                                                                    value:[UIFont systemFontOfSize:19.0f]
                                                                    range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                    
                    cell.valueLabel.attributedText = countValueAtr;
                    
                    cell.cutValueLabel.text = nil;
                    
                } else {
                    
                    cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_2.png"];
                    
                    //抵用券信息字体大小颜色设置
                    NSString *debitValueStr = [NSString stringWithFormat:@"%@元",couponDic.debitAmount];
                    
                    NSString *miniAmountStr = [NSString stringWithFormat:@"%d",couponDic.miniAmount];
                    
                    NSMutableAttributedString *debitStr = [[NSMutableAttributedString alloc]init];
                    
                    couponDic.miniAmount == 0?(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"立减%@",debitValueStr]]):(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%@元减%@",miniAmountStr,debitValueStr]]);
                    
                    NSLog(@"%d",miniAmountStr.length);
                    
                    couponDic.miniAmount == 0?[debitStr addAttribute:NSForegroundColorAttributeName
                                                               value:[UIColor orangeColor]
                                                               range:NSMakeRange(2, debitValueStr.length)]
                                             :[debitStr addAttribute:NSForegroundColorAttributeName
                                                               value:[UIColor orangeColor]
                                                               range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                    
                    couponDic.miniAmount == 0?[debitStr addAttribute:NSFontAttributeName
                                                               value:[UIFont systemFontOfSize:19.0f]
                                                               range:NSMakeRange(2, debitValueStr.length)]
                                             :[debitStr addAttribute:NSFontAttributeName
                                                               value:[UIFont systemFontOfSize:19.0f]
                                                               range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                    
                    cell.valueLabel.attributedText = debitStr;
                    
                    cell.cutValueLabel.text =  nil;
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return cell;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlew Header 定义
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    
    CouponSelectButton *hotCouponButton = [[CouponSelectButton alloc]initWithFrame:CGRectMake(0, 0, (WIDTH-2)/3, 50)];
    [hotCouponButton initSelectButtonWith:[UIImage imageNamed:@"hit_coupon_icon"] And:@"热门券"];
    [hotCouponButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [hotCouponButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [hotCouponButton addTarget:self action:@selector(hotCouponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CouponSelectButton *bestCouponButton = [[CouponSelectButton alloc]initWithFrame:CGRectMake((WIDTH-2)/3+1, 0, (WIDTH-2)/3, 50)];
    [bestCouponButton initSelectButtonWith:[UIImage imageNamed:@"best_coupon_icon"] And:@"值得买"];
    [bestCouponButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [bestCouponButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bestCouponButton addTarget:self action:@selector(goodCouponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CouponSelectButton *newCouponButton = [[CouponSelectButton alloc]initWithFrame:CGRectMake(((WIDTH-2)/3+1)*2, 0, (WIDTH-2)/3, 50)];
    [newCouponButton initSelectButtonWith:[UIImage imageNamed:@"new_coupon_icon"] And:@"最新券"];
    [newCouponButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [newCouponButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [newCouponButton addTarget:self action:@selector(newsCouponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([tagStr isEqualToString:LIST_HOT_COUPON]) {
        
        hotCouponButton.selected = YES;
        bestCouponButton.selected = NO;
        newCouponButton.selected = NO;
        
    } else if ([tagStr isEqualToString:LIST_PREFERENTIAL_COUPON]) {
        
        hotCouponButton.selected = NO;
        bestCouponButton.selected = YES;
        newCouponButton.selected = NO;
        
    } else if ([tagStr isEqualToString:LIST_NEW_COUPON]) {
        
        hotCouponButton.selected = NO;
        bestCouponButton.selected = NO;
        newCouponButton.selected = YES;
    }
    
    for (int i = 0; i < 2; i++) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0+49*i, WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        
        UIView *verLinView = [[UIView alloc]initWithFrame:CGRectMake(((WIDTH-2)/3)+((WIDTH-2)/3)*i, 10, 1, 30)];
        verLinView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
        
        [headerView addSubview:lineView];
        [headerView addSubview:verLinView];
    }
    
    [headerView addSubview:hotCouponButton];
    [headerView addSubview:bestCouponButton];
    [headerView addSubview:newCouponButton];
    
    return headerView;
}

#pragma mark - cell separator delegate

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlewCell 重定义
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS 7
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    // iOS 8
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlew重绘
-(void)viewDidLayoutSubviews
{
    // iOS 7
    if ([couponTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [couponTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    // iOS 8
    if ([couponTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [couponTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

#pragma mark - tableView delegate

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlew重绘
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        QuanKongVoucher *couponDic = [couponListArray objectAtIndex:indexPath.row];
        
        QuanKongCouponDetailViewController *couponDetailViewController = [[QuanKongCouponDetailViewController alloc]init];
        couponDetailViewController.hidesBottomBarWhenPushed = YES;
        
        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            NSString *ID = [business objectForKey:@"id"];
            if ([i isEqualToString:@"0"]) {
                [couponDetailViewController getCouponDetailWithCouponID:[NSString stringWithFormat:@"%i",couponDic.vocherId]And:ID];
                [self.navigationController pushViewController:couponDetailViewController animated:YES];
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
        }];
    }
}


#pragma mark - button selector

/**
 *  城市选择按钮事件
 *
 *  @param sender sender
 */
- (void)selectCity:(id)sender
{
    CRNavigationController *senderNoticeNav = [[CRNavigationController alloc]initWithRootViewController:[[QuanKongCityViewController alloc]init]];
    
    senderNoticeNav.navigationBar.barTintColor = ROCKCENT_ORANGE;
    [self presentViewController:senderNoticeNav animated:YES completion:nil];
}

/**
 *  最热的券按钮事件
 *
 *  @param sender sender
 */
- (void)hotCouponButtonClick:(id)sender
{
    dataRows = 1;
    
    [self getCouponDataWithTag:LIST_HOT_COUPON andPage:@"1"];
    
    tagStr = LIST_HOT_COUPON;
    
    [couponTableView reloadData];
    
}

/**
 *  优惠的券按钮事件
 *
 *  @param sender sender
 */
- (void)goodCouponButtonClick:(id)sender
{
    dataRows = 1;
    
    [self getCouponDataWithTag:LIST_PREFERENTIAL_COUPON andPage:@"1"];
    
    tagStr = LIST_PREFERENTIAL_COUPON;
    
    [couponTableView reloadData];
    
}

/**
 *  最新的券按钮事件
 *
 *  @param sender sender
 */
- (void)newsCouponButtonClick:(id)sender
{
    dataRows = 1;
    
    [self getCouponDataWithTag:LIST_NEW_COUPON andPage:@"1"];
    
    tagStr = LIST_NEW_COUPON;
    
    [couponTableView reloadData];
}

/**
 *  个人消息按钮事件
 *
 *  @param sender sender
 */
- (void)messageButtonClick:(UIButton *)sender
{
    UINavigationController *nva_notice = [[UINavigationController alloc]initWithRootViewController:[[QuanKongNoticeViewController alloc]init]];
    
    [self presentViewController:nva_notice animated:YES completion:nil];
}

/**
 *  扫描二维码按钮事件
 *
 *  @param sender sender
 */
- (void)qrcodeButtonClick:(UIButton *)sender
{
    UINavigationController *nva_qr = [[UINavigationController alloc]initWithRootViewController:[[QuanKongQRcodeViewController alloc]init]];
    
    [self presentViewController:nva_qr animated:YES completion:nil];
    
}

/**
 *  tableView 刷新
 */
- (void)reloadData
{
    [couponTableView reloadData];
    
    [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:couponTableView];
    
    loadMoreTableFooterView.frame = CGRectMake(0.0f, couponTableView.contentSize.height, couponTableView.frame.size.width, couponTableView.bounds.size.height);
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int scrollPage = scrollView.contentOffset.x/WIDTH;
    
    pageControl.currentPage = scrollPage;
    
    [loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark LoadMoreTableFooterDelegate Methods

-(void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    isLoadMoreing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dataRows++;
        
        [self getCouponDataWithTag:tagStr andPage:[NSString stringWithFormat:@"%d",dataRows]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // complete loading...
            
        });
    });
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建搜索栏
    [self initSearchBar];
    //创建获取 最热的券 第一页 数据
    [self getCouponDataWithTag:LIST_HOT_COUPON andPage:@"1"];
    //
    [self createRightItems];
    
    _searchData = NO;
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        
        [self messageButtonClick:nil];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
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

-(void)createExitButt{
    
    //取消按钮
    UIButton * exitButt =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [exitButt setTitle:@"取消" forState:UIControlStateNormal];
    exitButt.titleLabel.font=[UIFont systemFontOfSize:17.0f];
    exitButt.tag = 100;
    [exitButt addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:exitButt];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = nil;
    
}

-(void)clickBut:(UIButton *)but{
    
    [msearchBar resignFirstResponder];
    msearchBar.text = @"";
    
    self.view = couponTableView;
    
    [self createRightItems];
    
    //判断是否有定位城市
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefaults objectForKey:@"city"];
    
    [self initNavigationItemButtonWithStr:city];
}

#pragma mark - UISearchBarDelegate方法

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    QuanKongSearchViewController *searchViewController = [[QuanKongSearchViewController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:searchViewController];
    nc.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    nc.navigationBar.translucent = YES;
    
    [self presentViewController:nc animated:NO completion:^{
        
    }];
    
    return NO;
}


#pragma mark-辅助函数

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
