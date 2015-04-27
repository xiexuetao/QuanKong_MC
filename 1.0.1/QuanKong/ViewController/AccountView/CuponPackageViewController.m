//
//  QuanKongCuponPackageViewController.m
//  QuanKong
//
//  Created by rick on 14/10/21.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//
#define BUT_WIDTH WIDTH/3
#define BUT_HEIGHT 45
#import "CuponPackageViewController.h"
#import "UserInfo.h"
#import "QuanKongVoucher.h"
#import "HTTPTool.h"
#import "UIImageView+WebCache.h"
#import "ExchangeViewController.h"
#import "QuanKongCouponDetailViewController.h"
#import "QuanKongNoPaymentViewController.h"
#import "QuanKongTakeCommentViewController.h"
#import "IntnetPrompt.h"
#import "couponLIstViewCell.h"
#import "QuanKongVoucher.h"
#import "Prompt.h"
#import "LoadingHUDView.h"
#import "NSString+DisposeStr.h"
#import "NSDate+Help.h"
#import "UITableView+Help.h"

typedef NS_ENUM(NSInteger, category){
    MyCollection,//我的收藏
    MyVoucherPackage,//我的券包
    MyTrading//我的交易
};

typedef NS_ENUM(NSInteger, kstate){
    DonotUse,
    Overdue,
    HasBeenUsed,
    Collection
};


@interface CuponPackageViewController (){
    
    NSMutableArray *_data;
    
    int _selectBut;
    
    EGORefreshTableHeaderView *egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *loadMoreTableFooterView;
    BOOL isLoadMoreing;
    
    int dataRows;
    
    int _type;//券类型 0 全部 1 现金  2 折扣
    int state;//0:未使用,2:已使用,3:交易中
    int _index;
    
    QuanKongVoucher *_vouch;
}

@end

@implementation CuponPackageViewController

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
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
        
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                               }];
    }
    return self;
}

-(id)initWithCouponType:(NSInteger)type
{
    state = type;
    
    return [super init];
}

/**
 *  初始化
 */
-(void)initEgoRefreshTable{
    if (egoRefreshTableHeaderView == nil)
    {
        egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height )];
        egoRefreshTableHeaderView.delegate = self;
        [self.tableView addSubview:egoRefreshTableHeaderView];
    }
    [egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    if (_data.count>5) {
        if (loadMoreTableFooterView == nil)
        {
            loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            loadMoreTableFooterView.delegate = self;
            [self.tableView addSubview:loadMoreTableFooterView];
        }
    }else{
        if (loadMoreTableFooterView != nil)
        {
            [loadMoreTableFooterView removeFromSuperview];
        }
    }
    
    [self reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [UITableView setExtraCellLineHidden:self.tableView];
    loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    isRefreshing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(2);
        //        dataRows = 20; // show first 20 records after refreshing
        dispatch_sync(dispatch_get_main_queue(), ^{
            // complete refreshing
            isRefreshing = NO;
            [self reloadData]; 
            
            [egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return isRefreshing;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    isLoadMoreing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(3);
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            isLoadMoreing = NO;
            [self getData];
            [self reloadData];
            //            dataRows = 20; // add 20 more records
            [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getData{
    NSString * str;
    CGRect fr = CGRectMake(0,BUT_HEIGHT,WIDTH,HEIGHT-BUT_WIDTH);
    NSString *urlStr = @"%@%@&loginName=%@&state=%d&currentPage=%d&pageSize=%i&appKey=%@&type=%i";
    
    if (self.category == MyVoucherPackage) {//我的券包
        
        str = [NSString stringWithFormat:urlStr,NEW_HEAD_LINK,DONOTUSE_METHOD,[UserInfo shareUserInfo].userName,state,dataRows,20,APP_KEY,_type];
        
    }else if(self.category== MyTrading){//我的交易
        
        str = [NSString stringWithFormat:urlStr,NEW_HEAD_LINK,ORDER_LIST_METHOD,[UserInfo shareUserInfo].userName,state,dataRows,20,APP_KEY,_type];
        
    }else{//我的收藏
        
        fr = CGRectMake(0, 0, WIDTH, HEIGHT);
        str = [NSString stringWithFormat:urlStr,NEW_HEAD_LINK,COLLECTION_METHOD,[UserInfo shareUserInfo].userName,state,dataRows,20,APP_KEY,_type];
    }
    
    if (dataRows == 1) {
        [LoadingHUDView showLoadinginView:self.view AndFrame:fr AndString:@"加载中···"];
    }
    
    [IntnetPrompt hideIntnetPromptForView:self.view animated:YES];
    
    [HTTPTool getWithPath:str success:^(id success) {
        NSString * i = [success objectForKey:@"event"];
        if ([i isEqualToString:@"0"]) {
            dataRows++;
            //返回的数据全部的券
            NSArray *arr = [success objectForKey:@"objList"];
            
            for (int x=0; x<arr.count; x++) {
                
                QuanKongVoucher *voucher = [QuanKongVoucher initWihtData:arr[x]];
                
                [_data addObject:voucher];
            }
            if (_data.count > 0) {
                
                [Prompt removerPromptViewWithView:self.view animated:YES];
                
            }else{
                [Prompt showPromptWihtView:self.view
                                   message:@"亲！还没有券快去逛逛吧！"
                                     frame:fr];
            }
            
            [self initEgoRefreshTable];
            
        }else{
            IntnetPrompt *intnet = [IntnetPrompt showIntnetPromptWithMessage:INTNET_PROMPT_STRING inView:self.view frame:fr];
            intnet.delegate = self;
        }
        
        [LoadingHUDView hideLoadingView];
        
    } fail:^(NSError *error) {
        
        [LoadingHUDView hideLoadingView];
        [Prompt removerPromptViewWithView:self.view animated:YES];
        
        IntnetPrompt *intnet = [IntnetPrompt showIntnetPromptWithMessage:INTNET_PROMPT_STRING inView:self.view frame:fr];
        intnet.delegate = self;
    }];
}

-(void)clickButtonOperation:(IntnetPrompt *)intnetView{
    [self getData];
}


- (void)viewDidLoad {
    if (state == DonotUse) {
        self.navigationItem.title = @"未使用的券";
    }else{
        self.navigationItem.title = @"已使用的券";
    }
    
    switch (state) {
        case DonotUse:
            self.navigationItem.title = @"未使用的券";
            break;
        case HasBeenUsed:
            self.navigationItem.title = @"已使用的券";
            break;
        case Collection:
            self.navigationItem.title = @"我的收藏";
            break;
        default:
            break;
    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _data = [NSMutableArray array];
    _selectBut = 1;
    _type = 0;
    isRefreshing = NO;
    dataRows = 1;
    
    if (self.category == MyCollection) {
        
    }else{
        [self topButton];
    }
    [self createrTableView];
    [self getData];

}

/**
 *  创建tableview
 */
-(void)createrTableView{
    if (self.category == MyCollection) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,WIDTH, HEIGHT) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BUT_HEIGHT ,WIDTH, HEIGHT-BUT_HEIGHT-64) style:UITableViewStylePlain];
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [UITableView setExtraCellLineHidden:self.tableView];
}

/**
 *  创建顶部3个button
 */
-(void)topButton{
    
    UIButton *all = [self createrButton:@"全部券" tag:1];
    UIButton *cash = [self createrButton:@"现金券" tag:2];
    UIButton *preferential = [self createrButton:@"抵用券" tag:3];
    UIButton *discount = [self createrButton:@"折扣券" tag:4];
    [self.view addSubview:all];
    [self.view addSubview:cash];
    [self.view addSubview:preferential];
    [self.view addSubview:discount];
    
}

/**
 *  创建button
 *
 *  @param str 按钮标题
 *  @param i   tag
 *
 *  @return button
 */
-(UIButton *)createrButton:(NSString *) str tag:(NSInteger) i{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake((i-1)*(WIDTH/4), 0, WIDTH/4, BUT_HEIGHT);
    [but setTitle:str forState:UIControlStateNormal];
    but.tag = i;
    [but addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
    if (i == 1) {
        [but setBackgroundImage:[UIImage imageNamed:@"topbut_h"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [but setBackgroundImage:[UIImage imageNamed:@"topbut_b"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return but;
}

/**
 *  top button click
 *
 *  @param but 点击的按钮
 */
-(void)clickTopButton:(UIButton *)but{
    //    MyLog(@"%i",but.tag);
    if (but.tag == (_type+1)) {
        
    }else{
        _type = but.tag - 1;
        dataRows = 1;
        [_data removeAllObjects];
        [self getData];
    }
    
    UIButton *button = (UIButton *)[self.view viewWithTag:_selectBut];
    [button setBackgroundImage:[UIImage imageNamed:@"topbut_b"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _selectBut = but.tag;
    [but setBackgroundImage:[UIImage imageNamed:@"topbut_h"] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return _data.count;
    }
    else {
        return 1;
    }
}




#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuanKongVoucher *vc = _data[indexPath.row];
    
    NSString *identifier = [NSString stringWithFormat:@"status%i",state];
    
    couponLIstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[couponLIstViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        if (state!=Collection) {
           cell.but.backgroundColor = [UIColor orangeColor];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //券的的图片
        [cell.logoImageView sd_setImageWithURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,
                               [vc.picUrl componentsSeparatedByString:@";"][0]]]
                              placeholderImage:[UIImage imageNamed:@"image_placeholder"]
                                     completed:nil];
    
    //券的名称
    cell.titleLabel.text = vc.name;
    
    //券的介绍
    if (state == Collection){
        cell.introduceLabel.text =[NSString stringWithFormat:@"有效期至:%@",[NSDate timeFormatted:vc.useEndTime.longLongValue model:@"yyyy-MM-dd"]];
    }else{
        cell.introduceLabel.text =  [NSString stringWithFormat:@"数量：%i",vc.count];
    }
    
    //券的类型
    NSString *couponTypeStr = [NSString stringWithFormat:@"%i",vc.type];
    //券的折扣
    NSString *discountStr = [NSString stringWithFormat:@"%i",vc.discount];

    //根据couponTypeStr对不同的
    switch ([couponTypeStr intValue]) {
        case 0:
        {
            
            //销售价格
            cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_0.png"];
            
            NSString *estimateStr = [[NSString alloc]init];
            
            estimateStr = [NSString stringWithFormat:@"%@元",vc.estimateAmount];
            
            NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
            
            [estimateAmountStr addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor orangeColor]
                                      range:NSMakeRange(0, estimateStr.length)];
            
            [estimateAmountStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:19.0f]
                                      range:NSMakeRange(0, estimateStr.length)];
            
            //原价
            float estimateStrLength = [NSString widthOfString:estimateStr withFont:[UIFont systemFontOfSize:19.0f]];
            
            NSString *faceStr = [NSString stringWithFormat:@"%@元",vc.faceValue];
            
            NSMutableAttributedString *faceValueStr = [[NSMutableAttributedString alloc]initWithString:faceStr];
            
            [faceValueStr addAttribute:NSStrikethroughStyleAttributeName
                                 value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                                 range:NSMakeRange(0, faceStr.length)];
            
            cell.cutValueLabel.frame = CGRectMake(105+estimateStrLength+5, 69, WIDTH-estimateStrLength-120, 20);
            
            [self couponSetButtonAndText:estimateAmountStr cutVaule:faceValueStr tableViewCell:cell voucher:vc type:state];

        }
            break;
        case 1:
        {
            
            cell.valueLabel.textColor = [UIColor grayColor];
            cell.valueLabel.font = [UIFont systemFontOfSize:12.0f];
            
            if ([discountStr integerValue] == 0) {
                
                NSString *debitValueStr = [NSString stringWithFormat:@"%@元",vc.debitAmount];
                
                NSString *miniAmountStr = [NSString stringWithFormat:@"%d",vc.miniAmount];
                
                NSMutableAttributedString *debitStr = [[NSMutableAttributedString alloc]init];
                
                vc.miniAmount == 0?(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"立减%@",debitValueStr]]):(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%@元减%@",miniAmountStr,debitValueStr]]);
                
                vc.miniAmount == 0?[debitStr addAttribute:NSForegroundColorAttributeName
                                                    value:[UIColor orangeColor]
                                                    range:NSMakeRange(2, debitValueStr.length)]
                                  :[debitStr addAttribute:NSForegroundColorAttributeName
                                                    value:[UIColor orangeColor]
                                                    range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                
                vc.miniAmount == 0?[debitStr addAttribute:NSFontAttributeName
                                                    value:[UIFont systemFontOfSize:19.0f]
                                                    range:NSMakeRange(2, debitValueStr.length)]
                                  :[debitStr addAttribute:NSFontAttributeName
                                                    value:[UIFont systemFontOfSize:19.0f]
                                                    range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                
                cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_2.png"];
                
                [self couponSetButtonAndText:debitStr cutVaule:nil tableViewCell:cell voucher:vc type:state];
                
                cell.cutValueLabel.text = @"";
                
            }else{
                
                NSString *discountStr = [[NSString alloc]init];
                
                vc.discount%10 == 0?(discountStr = [NSString stringWithFormat:@"%.0f",vc.discount*0.1]):(discountStr = [NSString stringWithFormat:@"%.1f",vc.discount*0.1]);
                
                NSMutableAttributedString *countValueAtr = [[NSMutableAttributedString alloc]init];
                NSString *miniAmountStr = [NSString stringWithFormat:@"%ld",(long)vc.miniAmount];
                
                vc.miniAmount == 0?(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",discountStr]]):(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%ld元享%@折",(long)vc.miniAmount,discountStr]]);
                
                vc.miniAmount == 0?[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                         value:[UIColor orangeColor]
                                                         range:NSMakeRange(0, 1+discountStr.length)]
                                  :[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                         value:[UIColor orangeColor]
                                                         range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                
                vc.miniAmount == 0?[countValueAtr addAttribute:NSFontAttributeName
                                                         value:[UIFont systemFontOfSize:19.0f]
                                                         range:NSMakeRange(0, 1+discountStr.length)]
                                  :[countValueAtr addAttribute:NSFontAttributeName
                                                         value:[UIFont systemFontOfSize:19.0f]
                                                         range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                
                cell.typeTagImageView.image = [UIImage imageNamed:@"coupon_type_1.png"];
                
                [self couponSetButtonAndText:countValueAtr cutVaule:nil tableViewCell:cell voucher:vc type:state];
                
                cell.cutValueLabel.text = @"";
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)couponSetButtonAndText:(NSMutableAttributedString *) str cutVaule:(NSMutableAttributedString *) cut tableViewCell:(couponLIstViewCell *) cell voucher:(QuanKongVoucher *) vc type:(int) type{

    if (state == HasBeenUsed) {
        
        NSString *createTime = vc.useTime;
        long long time = createTime.longLongValue+15*24*60*60*1000;
        long i = time - [[NSDate date] timeIntervalSince1970]*1000;
        cell.valueLabel.text = [NSString stringWithFormat:@"使用时间:%@",[NSDate timeFormatted:createTime.longLongValue model:@"yyyy-MM-dd"]];
        
        if (vc.isComment==1 || i < 0) {
            [cell.but setBackgroundColor:[UIColor whiteColor]];
            [cell.but setTitle:@"已评价" forState:UIControlStateNormal];
            [cell.but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else{
            cell.but.backgroundColor = [UIColor orangeColor];
            [cell.but setTitle:@"评价" forState:UIControlStateNormal];
            [cell.but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.but addTarget:self action:@selector(commentBtnPressed:event:) forControlEvents:UIControlEventTouchDown];
        }
    }else if(state == DonotUse){
        cell.valueLabel.text = [NSString stringWithFormat:@"有效期至:%@",[NSDate timeFormatted:vc.useEndTime.longLongValue model:@"yyyy-MM-dd"]];
        [cell.but setTitle:@"兑换" forState:UIControlStateNormal];
        [cell.but addTarget:self action:@selector(exchangeBtnPressed:event:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.valueLabel.attributedText = str;
        if (cut != nil) {
            cell.cutValueLabel.attributedText = cut;
        }
    }
}

/**
 *  获取券类型图片
 *
 *  @return 类型图
 */
-(UIImage *)getImage:(QuanKongVoucher *)voucher{
    
    switch (voucher.type) {
        case 0:
        {
            return [UIImage imageNamed:@"coup-type0.png"];
        }
            break;
        case 1:
        {
            if (voucher.discount > 0) {
                return [UIImage imageNamed:@"coup-type1.png"];
            } else {
                return [UIImage imageNamed:@"coup-type2.png"];
            }
        }
            break;
        default:
            return nil;
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(self.category==1){
        return 95;
    }else{
        return 90;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.category == 2) {
        QuanKongNoPaymentViewController *noPayment = [[QuanKongNoPaymentViewController alloc] init];
        [self.navigationController pushViewController:noPayment animated:YES];
        QuanKongVoucher *voucher = _data[indexPath.row];
        noPayment.orderId = [NSString stringWithFormat:@"%i",voucher.vocherId];
    }else{
        QuanKongCouponDetailViewController *couponDetailViewController = [[QuanKongCouponDetailViewController alloc]init];
        
        couponDetailViewController.hidesBottomBarWhenPushed = YES;
        if (self.category == 0) {
            couponDetailViewController.delegate = self;
        }
        
        QuanKongVoucher *voucher = _data[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            NSString *ID = [business objectForKey:@"id"];
            if ([i isEqualToString:@"0"]) {
                [couponDetailViewController getCouponDetailWithCouponID:[NSString stringWithFormat:@"%i",voucher.vocherId]And:ID];
                [self.navigationController pushViewController:couponDetailViewController animated:YES];
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
        }];
    }
}





/**
 *  兑换按钮点击处理
 *
 *  @param sender
 *  @param event
 */
-(void)exchangeBtnPressed:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    //按钮所在的行表示indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        ExchangeViewController * tmp=[[ExchangeViewController alloc]init];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        tmp.couponview=[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cell.contentView]];
        QuanKongVoucher *voucher = [_data objectAtIndex:indexPath.row];
        NSInteger idNum = voucher.vocherId;
        tmp.couponId = idNum;
        tmp.voucher = voucher;
        tmp.delegate = self;
        [self.navigationController pushViewController:tmp animated:YES];
    }
}



/**
 *  评论按钮点击处理
 *
 *  @param sender
 *  @param event
 */
-(void)commentBtnPressed:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    //按钮所在的行标示indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        QuanKongTakeCommentViewController * tmp = [[QuanKongTakeCommentViewController alloc]init];
        _index = indexPath.row;
        _vouch = _data[_index];
        tmp.delegate = self;
        tmp.couponId= [NSString stringWithFormat:@"%i",_vouch.vocherId];
        tmp.verificationId = _vouch.verificationId;
        [self.navigationController pushViewController:tmp animated:YES];
    }
}


-(void)popViewControllerGetData:(id)viewController{
    [_data removeAllObjects];
    dataRows = 1;
    [self getData];
}



#pragma mark 将button绘制成圆角
-(void)drawnRoundedCorners:(UIButton *)but{
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 3.f;
}



#pragma mark-按钮点击处理
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
