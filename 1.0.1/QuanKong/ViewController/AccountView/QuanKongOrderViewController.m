//
//  QuanKongOrderViewController.m
//  QuanKong
//
//  Created by Rick on 14/11/3.
//  Copyright (c) 2014年 Rockcent. All rights reserved.

#import "QuanKongOrderViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "HTTPTool.h"
#import "QuanKongVoucher.h"
#import "couponLIstViewCell.h"
#import "UIImageView+WebCache.h"
#import "QuanKongCouponDetailViewController.h"
#import "QuanKongNoPaymentViewController.h"
#import "Prompt.h"
#import "NSDate+Help.h"
#import "NSString+DisposeStr.h"
#import "UITableView+Help.h"
#import "OrderInfo.h"

@interface QuanKongOrderViewController (){
    
    EGORefreshTableHeaderView *egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *loadMoreTableFooterView;
    BOOL isLoadMoreing;
    
    int dataRows;
    
    int _type;//券类型
    int state;//
}

@end

@implementation QuanKongOrderViewController

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
        //加入返回按钮
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    return self;
}

/**
 *  点击返回按钮处理
 *
 *  @param sender
 */

-(void)pushBack:(id)sender

{
    [self.navigationController popViewControllerAnimated:YES];
}

-(id)initWithCouponType:(NSInteger)type
{
    _type = type;
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UITableView setExtraCellLineHidden:self.tableView];
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
        //dataRows = 20; // show first 20 records after refreshing
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
//            dataRows++; // add 20 more records
            [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
}



-(void)getData{
    
    NSString *str = [NSString stringWithFormat:@"%@%@&loginName=%@&state=%d&currentPage=%d&pageSize=20&appKey=%@&keyWords=%@",NEW_HEAD_LINK,ORDER_LIST_METHOD,[UserInfo shareUserInfo].userName,_type,dataRows,APP_KEY,@""];
    MyLog(@"-------------------------%@",str);
    if (dataRows == 1) {
        [LoadingHUDView showLoadinginView:self.view];
    }
    
    [HTTPTool getWithPath:str success:^(id success) {
        NSString * i = [success objectForKey:@"event"];
        if ([i isEqualToString:@"0"]) {
            [IntnetPrompt hideIntnetPromptForView:self.view animated:YES];
            dataRows++;
            //返回的数据全部订单
            NSArray *arr = [success objectForKey:@"objList"];
            
            for (int x=0; x<arr.count; x++) {
                
                OrderInfo *order = [OrderInfo initWihtData:arr[x]];
                NSArray *couponArr = [arr[x] objectForKey:@"couponList"];
                NSMutableArray *coupons = [NSMutableArray array];
                
                for (int i=0; i<couponArr.count; i++) {
                    QuanKongVoucher *voucher = [QuanKongVoucher initWihtData:arr[x]];
                    [coupons addObject:voucher];
                }
                
                order.couponList = coupons;
                [_data addObject:order];
            }
            
            if (_data.count>0) {
                [Prompt removerPromptViewWithView:self.view animated:YES];
            }else{
                [Prompt showPromptWihtView:self.view message:@"亲！还没有订单快去逛逛吧！"];
            }
            
            [self initEgoRefreshTable];
        }else{
            [IntnetPrompt showIntnetPromptWithMessage:@"服务器链接错误，请稍后尝试！" inView:self.view];
        }
        [LoadingHUDView hideLoadingView];
    } fail:^(NSError *error) {
         [LoadingHUDView hideLoadingView];
        [Prompt removerPromptViewWithView:self.view animated:YES];
        IntnetPrompt *intnet = [IntnetPrompt showIntnetPromptWithMessage:INTNET_PROMPT_STRING inView:self.view];
        //[error.userInfo objectForKey:@"NSLocalizedDescription"]错误信息
        intnet.delegate = self;
    }];
}

-(void)clickButtonOperation:(IntnetPrompt *)intnetView{
    [self getData];
}


- (void)viewDidLoad {
    if (_type==0) {
        self.navigationItem.title = @"待付款的交易";
    }else{
        self.navigationItem.title = @"已成功的交易";
    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _data = [NSMutableArray array];
    state = -1;
    isRefreshing = NO;
    dataRows = 1;
    
    [self createrTableView];
    [self getData];
}


/**
 *  创建tableview
 */
-(void)createrTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,WIDTH, HEIGHT-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [UITableView setExtraCellLineHidden:self.tableView];
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
    
    OrderInfo *orderInfo = _data[indexPath.row];
    
    QuanKongVoucher *voucher = orderInfo.couponList[0];
    
    NSString *identifier = [NSString stringWithFormat:@"status_%d",indexPath.section];
    
    couponLIstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[couponLIstViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    NSLog(@"%i",voucher.type);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //券的的图片
//    NSString *str = [NSString stringWithFormat:@"%@%@",TEST_URL_IMAGE_HEAD,[voucher.picUrl componentsSeparatedByString:@";"][0]];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,orderInfo.logoUrl];
    
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
    
    //券的名称
    cell.titleLabel.text = voucher.name;
    cell.titleLabel.textColor = [UIColor darkGrayColor];
    
    //暂不需要
    
    //券的类型logo
    UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(85-23, 75-23, 23, 23)];
    
    //销售价格
         NSString  *estimateStr = [NSString stringWithFormat:@"总价：%.2f 元",[voucher.total doubleValue]];
    NSString *time;
    if (_type == 0) {
        //下单时间
        time = [NSString stringWithFormat:@"下单时间：%@",[NSDate timeFormatted:voucher.createTime.longLongValue model:@"yyyy-MM-dd"]];
    }else{
        //付款时间
        time = [NSString stringWithFormat:@"付款时间：%@",[NSDate timeFormatted:voucher.tradeTime.longLongValue model:@"yyyy-MM-dd"]];
    }
    

    
    NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
    
    [estimateAmountStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, estimateStr.length-4)];
    [estimateAmountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(3, estimateStr.length-4)];
    cell.valueLabel.font = [UIFont systemFontOfSize:13.f];
    cell.valueLabel.text = time;
    cell.introduceLabel.attributedText = estimateAmountStr;
    
    //原价
    float estimateStrLength = [NSString widthOfString:estimateStr withFont:[UIFont systemFontOfSize:15.0f]];

    cell.cutValueLabel.frame = CGRectMake(105+estimateStrLength+5, 69, 50, 20);
    [cell.cutValueLabel removeFromSuperview];
    [cell.logoImageView addSubview:typeImageView];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuanKongNoPaymentViewController *noPayment = [[QuanKongNoPaymentViewController alloc] init];
    [self.navigationController pushViewController:noPayment animated:YES];
    NSLog(@"%i",indexPath.row);
    OrderInfo *orderInfo = _data[indexPath.row];
    noPayment.orderId = orderInfo.number;
    noPayment.delegate = self;
}

#pragma mark 将button绘制成圆角
-(void)drawnRoundedCorners:(UIButton *)but{
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 3.f;
}


-(void)popViewControllerOptionGetData:(QuanKongNoPaymentViewController *)noPay{
    
    [_data removeAllObjects];
    
    dataRows = 1;
    [self getData];
}


@end
