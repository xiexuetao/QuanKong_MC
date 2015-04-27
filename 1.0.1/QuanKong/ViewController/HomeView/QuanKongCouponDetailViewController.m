//
//  QuanKongCouponDetailViewController.m
//  QuanKong
//
//  Created by POWER on 14-9-22.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongCouponDetailViewController.h"

#import "QuanKongPayViewController.h"
#import "QuanKongOrdersViewController.h"
#import "QuanKongCommentController.h"
#import "QuanKongWebViewController.h"
#import "LoginViewController.h"

#import "QuanKongShopListViewController.h"
#import "QuanKongMapViewController.h"
#import "AddictionInfoControllVIew.h"
#import "QuanKongAppDelegate.h"

#define BLUE [UIColor colorWithRed:95.0/255.0 green:163.0/255.0 blue:239.0/255.0 alpha:1.0]
#define GRAY [UIColor grayColor]

@interface QuanKongCouponDetailViewController (){
    
    UILabel *_titleLa;
    UIImageView *_imageView;
    NSString *_couponId;
    
}

@end

@implementation QuanKongCouponDetailViewController {
    
    QuanKongVoucher *couponDetailModel;
    
    NSString *_channelId;
    
    BOOL isCollect;
    BOOL isLoadMore;
    
    int couponCount;
    NSURL *collcentUrl;
    
    NSMutableArray *storeListArray;
    NSInteger storeCount;
    
    NSArray *functionBtnArray;
    NSArray *tableTitleArray;
    
    CGRect rect;
    CGFloat webViewHeight;
}

@synthesize couponTableView;
@synthesize bottomView;
@synthesize orderNowBgView;
@synthesize countSelector;
@synthesize countValueLabel;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0
                                                    green:240.0/255.0
                                                     blue:240.0/255.0
                                                    alpha:1.0];
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
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
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"券的详情";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        UIButton *cartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 19)];
        [cartButton setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
        [cartButton addTarget:self action:@selector(cartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *cartButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cartButton];
        
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 19)];
        
        [but setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:but];
        self.navigationItem.rightBarButtonItems = @[cartButtonItem];
        
        [but addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
        
        functionBtnArray = [[NSArray alloc]initWithObjects:@"收藏",@"分享", nil];
        
        tableTitleArray = [[NSArray alloc]initWithObjects:@"",@"支持门店",@"",@"使用说明",@"", nil];
        
        couponCount = 1;
        
        [LoadingHUDView showLoadinginView:self.view];
        
        isLoadMore = NO;
        webViewHeight = 1.0f;
    }
    
    return self;
}

/**
 *  页面刷新
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    if (couponTableView) {
        
        [self getCouponDetailWithCouponID:[NSString stringWithFormat:@"%d",couponDetailModel.vocherId] And:_channelId];
            
        orderNowBgView.frame = CGRectMake(0, HEIGHT-64, WIDTH, 90);
                    
        bottomView.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
        
    }
}

/**
 *  分享按钮点击事件处理
 *
 *  @param but
 */
-(void)pushView:(UIButton *)but
{
    self.share = [[QuanKongShareView alloc] initShareWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT) and:self];
    self.share.delegate = self;
}


/**
 *  分享代理方法
 *
 *  @param indext 点击的按钮
 */
-(void)clickShareButton:(int)indext{
    QuanKongAppDelegate *appDelegate = (QuanKongAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.wechatAndWeibo.delegate = self;
    [WechatAndWeibo initWithSWW].delegate = self;
//    if (indext==0) {  //新浪微博分享
//        [WechatAndWeibo shareButtonPressed:_titleLa.text image:_imageView.image];
//    }else if(indext==1) { //朋友圈
//        [appDelegate.wechatAndWeibo weixinShareButtonPressed:YES titleLa:_titleLa.text description:_titleLa.text image:_imageView.image couponId:_couponId];
//    }else if(indext==2){//会话
//        [appDelegate.wechatAndWeibo weixinShareButtonPressed:NO titleLa:_titleLa.text description:_titleLa.text image:_imageView.image couponId:_couponId];
//    }
    if(indext==0) { //朋友圈
        [appDelegate.wechatAndWeibo weixinShareButtonPressed:YES titleLa:_titleLa.text description:_titleLa.text image:_imageView.image couponId:_couponId];
    }else if(indext==1){//会话
        [appDelegate.wechatAndWeibo weixinShareButtonPressed:NO titleLa:_titleLa.text description:_titleLa.text image:_imageView.image couponId:_couponId];
    }
}

-(void)didReceiveWechatAndWeiboResponse:(id)resp{
    
    if ([resp isKindOfClass:WBBaseResponse.class]) {
        WBBaseResponse *response = (WBBaseResponse *)resp;
        //收到分享返回信息
        if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
        {
            if (response.statusCode == 0) {
                [self.view.window showHUDWithText:@"分享成功" Enabled:YES];
            }
        }
    }else if ([resp isKindOfClass:BaseResp.class]) {
        BaseResp *response = (BaseResp*)resp;
        if([response isKindOfClass:[SendMessageToWXResp class]]){
            SendMessageToWXResp *send = (SendMessageToWXResp *)response;
            
            /*NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
            NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", send.errCode];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];*/
            
            if (send.errCode == 0) {
                [self.view.window showHUDWithText:@"分享成功" Enabled:YES];
            }
        }
    }

}


/**
 *  通过券ID获取券详情信息
 *
 *  @param Id 券ID
 */
- (void)getCouponDetailWithCouponID:(NSString *)Id And:(NSString *)channelId
{
    _couponId = Id;
    _channelId = channelId;
    
    [UserInfo shareUserInfo].userName == NULL?([UserInfo shareUserInfo].userName = @""):nil;
    
    /**
     *  票券店铺信息
     */
    NSString *shopDetailUrlStr = [NSString stringWithFormat:@"%@%@&couponModelId=%@&appKey=%@",NEW_HEAD_LINK,LIST_STORE,Id,APP_KEY];
    
    [HTTPTool getWithPath:shopDetailUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if([msg isEqualToString:@"success"]) {
            
            storeListArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            [storeListArray addObject:[QuanKongStore initWihtData:[[success objectForKey:@"objList"]objectAtIndex:0]]];
            
            storeCount = ((NSMutableArray *)[success objectForKey:@"objList"]).count;
            
            [couponTableView reloadData];
            
        } else {
            
            [self.view.window showHUDWithText:@"记住店铺地址失败了" Enabled:YES];
            
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
    /**
     *  票券详细信息
     */
    NSString *couponDetailUrlStr = [NSString stringWithFormat:@"%@%@&couponModelId=%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,COUPON_MODEL,Id,[UserInfo shareUserInfo].userName,APP_KEY];
    

    [HTTPTool getWithPath:couponDetailUrlStr success:^(id success) {
        
        //券的详情 请求
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            couponDetailModel = [QuanKongVoucher initWihtData:[success objectForKey:@"obj"]];
            
            if (!couponTableView) {
                
                couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -35, WIDTH, HEIGHT-30) style:UITableViewStyleGrouped];
                couponTableView.dataSource = self;
                couponTableView.delegate = self;
                couponTableView.tag = 100;
                couponTableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
                couponTableView.backgroundColor = [UIColor clearColor];
                
                couponTableView.separatorColor = [UIColor clearColor];
                
                [self.view addSubview:couponTableView];
                
                //创建底栏
                [self initBottomBar];
                
                [self initOrderNowView:@"FUCK" And:couponDetailModel.estimateAmount];
                
                [LoadingHUDView hideLoadingView];
                
            }
            
            countSelector.limitCount = couponDetailModel.canBuyCount;
            
            [couponTableView reloadData];
            
        } else {
            
            [self.view.window showHUDWithText:@"获取券信息失败" Enabled:YES];
        }
        
    } fail:^(NSError *error) {
        
         NSLog(@"Fail");
        
    }];

}

/**
 *  创建低栏
 */
- (void)initBottomBar
{
    if (!bottomView) {
        
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-50, WIDTH, 50)];
        bottomView.backgroundColor = [UIColor clearColor];
        bottomView.userInteractionEnabled = YES;
    }

    
    UIView *clearBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    clearBlackView.backgroundColor = [UIColor blackColor];
    clearBlackView.alpha = 0.7;
    
    [bottomView addSubview:clearBlackView];
    
    [self.view insertSubview:bottomView atIndex:2];
    
    UIButton *soldOutButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH+30)/4, 10, (WIDTH-30)/2, 30)];
    [soldOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    soldOutButton.layer.cornerRadius = 2.0;
    soldOutButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    soldOutButton.backgroundColor = [UIColor grayColor];
    soldOutButton.enabled = NO;
    
    //下架的
    if (couponDetailModel.bizState == 0) {
        
        [soldOutButton setTitle:@"已下架" forState:UIControlStateDisabled];
        [bottomView insertSubview:soldOutButton aboveSubview:clearBlackView];
        
    //已售完的
    } else if ((couponDetailModel.issueCount - couponDetailModel.saleCount) == 0) {
        
        [soldOutButton setTitle:@"已售完" forState:UIControlStateDisabled];
        [bottomView insertSubview:soldOutButton aboveSubview:clearBlackView];
      
    //不下架的
    } else if (couponDetailModel.type == 0) {
        
        for (int i = 0 ; i < 2; i++) {
            
            UIButton *buyButton = [[UIButton alloc]initWithFrame:CGRectMake(10+((WIDTH-10)/2)*i, 10, (WIDTH-30)/2, 30)];
            [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buyButton.layer.cornerRadius = 2.0;
            buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            buyButton.alpha = 1.0;
            buyButton.tag = i;
            [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                buyButton.backgroundColor = [UIColor colorWithRed:254.0/255.0
                                                            green:100.0/255.0
                                                             blue:49.0/255.0
                                                            alpha:1.0];
                
                [buyButton setTitle:@"加入购物车" forState:UIControlStateNormal];
                
            } else {
                
                buyButton.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                            green:124.0/255.0
                                                             blue:49.0/255.0
                                                            alpha:1.0];
                
                [buyButton setTitle:@"直接购买" forState:UIControlStateNormal];
            }
            
            [bottomView insertSubview:buyButton aboveSubview:clearBlackView];
        }
        
    } else {
        
        UIButton *getButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH+30)/4, 10, (WIDTH-30)/2, 30)];
        [getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        getButton.layer.cornerRadius = 2.0;
        getButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        if ((couponDetailModel.issueCount - couponDetailModel.saleCount) > 0) {
            
            getButton.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                        green:124.0/255.0
                                                         blue:49.0/255.0
                                                        alpha:1.0];
            
            [getButton setTitle:@"领取" forState:UIControlStateNormal];
            
        } else {
            
            getButton.backgroundColor = [UIColor grayColor];
            [getButton setTitle:@"已领完" forState:UIControlStateDisabled];
            getButton.enabled = NO;
        }

        [getButton addTarget:self action:@selector(getButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView insertSubview:getButton aboveSubview:clearBlackView];
    }
    
}

/**
 *  创建立即购买界面
 *
 *  @param couponName  券名称
 *  @param couponValue 券价格
 */
- (void)initOrderNowView:(NSString *)couponName And:(NSString *)couponValue
{
    if (!orderNowBgView) {
        
        orderNowBgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64, WIDTH, 90)];
        orderNowBgView.backgroundColor = [UIColor clearColor];
        orderNowBgView.userInteractionEnabled = YES;
    }
    
    UIView *clearBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    clearBlackView.backgroundColor = [UIColor blackColor];
    clearBlackView.alpha = 0.7;
    
    [orderNowBgView addSubview:clearBlackView];
    
    for (int i = 0 ; i < 2; i++) {
        
        UIButton *orderButton = [[UIButton alloc]initWithFrame:CGRectMake(10+((WIDTH-10)/2)*i, 50, (WIDTH-30)/2, 30)];
        [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        orderButton.layer.cornerRadius = 2.0;
        orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        orderButton.tag = i;
        orderButton.selected = NO;
        [orderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            orderButton.backgroundColor = [UIColor lightGrayColor];
            [orderButton setTitle:@"取消" forState:UIControlStateNormal];
            
        } else {
            
            orderButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
            [orderButton setTitle:@"确认购买" forState:UIControlStateNormal];
        }
        
        [orderNowBgView addSubview:orderButton];
    }
    
    if (!countSelector) {
        
        countSelector = [[CountSelector alloc]initWithFrame:CGRectMake(WIDTH-130, 5, 120, 40)];
        
        [countSelector initViewWithCount:1
                                     And:(int)couponDetailModel.canBuyCount
                                  AndTag:0];
        
        countSelector.delegate = self;
    }

    [orderNowBgView addSubview:countSelector];
    
    if (!countValueLabel) {
        
        countValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 150, 30)];
        countValueLabel.backgroundColor = [UIColor clearColor];
        countValueLabel.textColor = [UIColor whiteColor];
        countValueLabel.textAlignment = NSTextAlignmentLeft;
        countValueLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        countValueLabel.text = [NSString stringWithFormat:@"合计：%.2f元",[couponValue floatValue]];
    }

    [orderNowBgView addSubview:countValueLabel];
    
    [self.view insertSubview:orderNowBgView atIndex:2];
    
}

#pragma mark - Table view data source
#pragma mark

//方法类型：系统方法
//编   写：peter
//方法功能：返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

//方法类型：系统方法
//编   写：peter
//方法功能：返回tableViewCell 的个数 = 问题的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 330;
    } else if (indexPath.section == 1) {
        return 135;
    } else if (indexPath.section == 2) {
        return 40;
    } else if (indexPath.section == 3) {
        
        rect = [couponDetailModel.explanation boundingRectWithSize:CGSizeMake(WIDTH, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                               context:nil];
        
        return rect.size.height + 45;
        
        
    } else {
        
        return 40+webViewHeight;
    }
}



//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlewCell 的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *shopTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 30)];
    shopTitleLabel.backgroundColor = [UIColor clearColor];
    shopTitleLabel.textAlignment = NSTextAlignmentLeft;
    shopTitleLabel.textColor = [UIColor darkGrayColor];
    shopTitleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    shopTitleLabel.text = [tableTitleArray objectAtIndex:indexPath.section];
    
    [cell.contentView addSubview:shopTitleLabel];
    
    if (indexPath.section == 0) {
        
        //券的类型logo
        UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-23, 150-23, 23, 23)];
        
        switch (couponDetailModel.type) {
            case 0:
            {
                typeImageView.image = [UIImage imageNamed:@"coupon_type_0.png"];
            }
                break;
            case 1:
            {
                if (couponDetailModel.discount > 0) {
                    
                    typeImageView.image = [UIImage imageNamed:@"coupon_type_1.png"];
                    
                } else {
                    
                    typeImageView.image = [UIImage imageNamed:@"coupon_type_2.png"];
                }
            }
                break;
            default:
                break;
        }
        
        NSArray *picArray = [couponDetailModel.picUrl componentsSeparatedByString:@";"];
        
        UIScrollView *picBgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
        picBgScrollView.backgroundColor = [UIColor whiteColor];
        picBgScrollView.delegate = self;
        picBgScrollView.tag = 101;
        picBgScrollView.bounces = YES;
        picBgScrollView.showsHorizontalScrollIndicator = NO;
        picBgScrollView.pagingEnabled = YES;
        
        if (!pageControl) {
            
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(80, 125, 160, 25)];
            pageControl.numberOfPages = picArray.count;
            pageControl.currentPage = 0;
        }

        for (int i = 0; i < picArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+WIDTH*i, 0, WIDTH, 150)];
            _imageView = imageView;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[picArray objectAtIndex:i]]]
                         placeholderImage:[UIImage imageNamed:@"image_placeholder"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    float imageHeight = image.size.height;
                                    float imageWidth = image.size.width;
                                    
                                    if (imageHeight > 0) {
                                        
                                        float imageViewWidth = imageWidth*(150/imageHeight);
                                        
                                        imageView.frame = CGRectMake((WIDTH-imageViewWidth)/2+WIDTH*i, 0, imageViewWidth, 150);
                                    }
                                    
                                }];
            
            [picBgScrollView addSubview:imageView];
        }
        
        [picBgScrollView setContentSize:CGSizeMake(WIDTH*picArray.count, 150)];
        
        [cell.contentView addSubview:picBgScrollView];
        [cell.contentView insertSubview:pageControl aboveSubview:picBgScrollView];
        [cell.contentView insertSubview:typeImageView aboveSubview:picBgScrollView];
        
        UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 155, WIDTH-20, 40)];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textColor = [UIColor orangeColor];
        valueLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UILabel *cutValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 175, 60, 20)];
        cutValueLabel.backgroundColor = [UIColor clearColor];
        cutValueLabel.textAlignment = NSTextAlignmentLeft;
        cutValueLabel.textColor = [UIColor lightGrayColor];
        cutValueLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UILabel *couponNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, WIDTH-20, 40)];
        couponNameLabel.backgroundColor = [UIColor clearColor];
        couponNameLabel.textAlignment = NSTextAlignmentLeft;
        couponNameLabel.textColor = [UIColor darkTextColor];
        couponNameLabel.font = [UIFont systemFontOfSize:16.0f];
        couponNameLabel.text = couponDetailModel.name;
        _titleLa = couponNameLabel;
        
        UIButton *collectButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-32, 165, 21, 20)];
        [collectButton setImage:[UIImage imageNamed:@"big_star"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"big_star_select"] forState:UIControlStateSelected];
        [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        
        collectButton.selected = couponDetailModel.isFavorite==0?NO:YES;
        
        [cell.contentView addSubview:collectButton];
        
        [cell.contentView addSubview:couponNameLabel];
        
        switch (couponDetailModel.type) {
            case 0:
            {
                NSString *estimateStr = [NSString stringWithFormat:@"%@元",couponDetailModel.estimateAmount];
                
                NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
                
                [estimateAmountStr addAttribute:NSFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:32.0f]
                                          range:NSMakeRange(0, estimateStr.length-1)];
                
                valueLabel.attributedText = estimateAmountStr;
                
                //原价

                float estimateStrLength = [NSString widthOfString:estimateStr withFont:[UIFont systemFontOfSize:32.0f]];
                
                NSString *faceStr = [NSString stringWithFormat:@"%@元",couponDetailModel.faceValue];
                
                NSMutableAttributedString *faceValueStr = [[NSMutableAttributedString alloc]initWithString:faceStr];
                
                [faceValueStr addAttribute:NSStrikethroughStyleAttributeName
                                     value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                                     range:NSMakeRange(0, faceStr.length)];
                
                cutValueLabel.frame = CGRectMake(estimateStrLength, 172, WIDTH-estimateStrLength-50, 20);
                cutValueLabel.attributedText = faceValueStr;
                
            }
                break;
            case 1:
            {
                
                if (couponDetailModel.discount > 0) {
                    
                    
                    NSString *discountStr = [[NSString alloc]init];
                    
                    (int)couponDetailModel.discount%10 == 0?(discountStr = [NSString stringWithFormat:@"%.0f",(int)couponDetailModel.discount*0.1]):(discountStr = [NSString stringWithFormat:@"%.1f",(int)couponDetailModel.discount*0.1]);
                    
                    NSMutableAttributedString *countValueAtr = [[NSMutableAttributedString alloc]init];
                    NSString *miniAmountStr = [NSString stringWithFormat:@"%ld",(long)couponDetailModel.miniAmount];
                    
                    couponDetailModel.miniAmount == 0?(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",discountStr]]):(countValueAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%ld元享%@折",(long)couponDetailModel.miniAmount,discountStr]]);
                    
                    couponDetailModel.miniAmount == 0?[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                                            value:[UIColor orangeColor]
                                                                            range:NSMakeRange(0, 1+discountStr.length)]
                                                     :[countValueAtr addAttribute:NSForegroundColorAttributeName
                                                                            value:[UIColor orangeColor]
                                                                            range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                    
                    couponDetailModel.miniAmount == 0?[countValueAtr addAttribute:NSFontAttributeName
                                                                            value:[UIFont systemFontOfSize:32.0f]
                                                                            range:NSMakeRange(0, 1+discountStr.length)]
                                                     :[countValueAtr addAttribute:NSFontAttributeName
                                                                            value:[UIFont systemFontOfSize:32.0f]
                                                                            range:NSMakeRange(3+miniAmountStr.length, 1+discountStr.length)];
                    
                    valueLabel.textColor = [UIColor grayColor];
                    valueLabel.font = [UIFont systemFontOfSize:15.0f];
                    
                    valueLabel.attributedText = countValueAtr;
                    
                    cutValueLabel.text = @"";
                    
                } else {
                    
                    NSString *debitValueStr = [NSString stringWithFormat:@"%@元",couponDetailModel.debitAmount];
                    
                    NSString *miniAmountStr = [NSString stringWithFormat:@"%ld",(long)couponDetailModel.miniAmount];
                    
                    NSMutableAttributedString *debitStr = [[NSMutableAttributedString alloc]init];
                    
                    couponDetailModel.miniAmount == 0?(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"立减%@",debitValueStr]]):(debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"满%@元减%@",miniAmountStr,debitValueStr]]);
                    
                    couponDetailModel.miniAmount == 0?[debitStr addAttribute:NSForegroundColorAttributeName
                                                                       value:[UIColor orangeColor]
                                                                       range:NSMakeRange(2, debitValueStr.length)]
                    :[debitStr addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor orangeColor]
                                      range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                    
                    couponDetailModel.miniAmount == 0?[debitStr addAttribute:NSFontAttributeName
                                                                       value:[UIFont systemFontOfSize:32.0f]
                                                                       range:NSMakeRange(2, debitValueStr.length)]
                    :[debitStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:32.0f]
                                      range:NSMakeRange(3+miniAmountStr.length, debitValueStr.length)];
                    
                    valueLabel.textColor = [UIColor grayColor];
                    valueLabel.font = [UIFont systemFontOfSize:15.0f];
                    
                    valueLabel.attributedText = debitStr;
                
                }
            }
                break;
            default:
                break;
        }
        
        [cell.contentView addSubview:valueLabel];
        [cell.contentView addSubview:cutValueLabel];
        
        /**
         券的资料视图，包括退款信息，已售数量，剩余数量，到期日期
         */
        couponDetailView *detailView = [[couponDetailView alloc]init];
        [detailView initViewWithTag:couponDetailModel.isOverdueRefund
                       AndSaleCount:couponDetailModel.saleCount
                     AndRemainCount:couponDetailModel.issueCount - couponDetailModel.saleCount
                      AndUseEndTime:couponDetailModel.useEndTime
                            AndRect:CGRectMake(0, 240, WIDTH, 90)
                       AndCouponTag:couponDetailModel.type];
        
        [cell.contentView addSubview:detailView];
        
        for (int j = 0; j < 3; j++) {
            
            UIImageView *dottedLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 199.5+40*j, WIDTH-10, 1)];
            dottedLine.image = [UIImage imageNamed:@"dotted_line"];
            
            if (j == 2) {
                
                dottedLine.frame = CGRectMake(5, 207.5+91, WIDTH-10, 1);
            }
            
            [cell.contentView addSubview:dottedLine];
            
        }
        
    } else if (indexPath.section == 9) {
        
        //先屏蔽二手券市场选项
        /*
        UILabel *marketTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
        marketTitleLabel.backgroundColor = [UIColor clearColor];
        marketTitleLabel.textAlignment = NSTextAlignmentLeft;
        marketTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        marketTitleLabel.textColor = [UIColor orangeColor];
        marketTitleLabel.text = @"二手交易市场行情";
        
        UIImageView *blueArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15, 15, 6, 10)];
        blueArrowView.image = [UIImage imageNamed:@"arrow"];
        
        [cell.contentView addSubview:marketTitleLabel];
        [cell.contentView addSubview:blueArrowView];*/
        
    } else if (indexPath.section == 1) {
        
        NSArray *titleArray = [[NSArray alloc]initWithObjects:@"map_icon",@"phone_icon", nil];
        
        for (int i = 0; i < 2; i++) {
            
            UIImageView *dottedLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30+75*i, WIDTH-10, 1)];
            dottedLine.image = [UIImage imageNamed:@"dotted_line"];
            
            UIButton *functionButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-40, 35+35*i, 35, 30)];
            [functionButton setBackgroundImage:[UIImage imageNamed:[titleArray objectAtIndex:i]]
                                      forState:UIControlStateNormal];
            functionButton.tag = i;
            [functionButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:dottedLine];
            [cell.contentView addSubview:functionButton];
        }
        
        UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, WIDTH-20, 30)];
        shopNameLabel.backgroundColor = [UIColor clearColor];
        shopNameLabel.textAlignment = NSTextAlignmentLeft;
        shopNameLabel.textColor = [UIColor darkGrayColor];
        shopNameLabel.font = [UIFont systemFontOfSize:14.0f];
        shopNameLabel.text = ((QuanKongStore *)[storeListArray objectAtIndex:0]).name;
        
        [cell.contentView addSubview:shopNameLabel];
        
        UILabel *shopAdressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, WIDTH-65, 20)];
        shopAdressLabel.backgroundColor = [UIColor clearColor];
        shopAdressLabel.textAlignment = NSTextAlignmentLeft;
        shopAdressLabel.textColor = [UIColor grayColor];
        shopAdressLabel.font = [UIFont systemFontOfSize:13.0f];
        shopAdressLabel.text = [NSString stringWithFormat:@"地址：%@",((QuanKongStore *)[storeListArray objectAtIndex:0]).address];
        
        [cell.contentView addSubview:shopAdressLabel];
        
        UILabel *shopTelphoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, WIDTH-50, 20)];
        shopTelphoneLabel.backgroundColor = [UIColor clearColor];
        shopTelphoneLabel.textAlignment = NSTextAlignmentLeft;
        shopTelphoneLabel.textColor = [UIColor grayColor];
        shopTelphoneLabel.font = [UIFont systemFontOfSize:13.0f];
        shopTelphoneLabel.text = [NSString stringWithFormat:@"电话：%@",((QuanKongStore *)[storeListArray objectAtIndex:0]).telephone];
        
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-45, 40, 1, 55)];
        verLine.backgroundColor = LIGHT_GRAY;
        
        UIButton *otherShopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 40)];
        otherShopButton.backgroundColor = [UIColor clearColor];
        [otherShopButton addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *otherShopLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, WIDTH-20, 30)];
        otherShopLabel.textAlignment = NSTextAlignmentLeft;
        otherShopLabel.textColor = [UIColor orangeColor];
        
        [otherShopButton addSubview:otherShopLabel];
        
        otherShopLabel.font = [UIFont systemFontOfSize:14.0f];
        otherShopLabel.text = [NSString stringWithFormat:@"查看所有支持门店（%ld）",(unsigned long)storeCount];
        
        UIImageView *blueArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15, 115, 6, 10)];
        blueArrowView.image = [UIImage imageNamed:@"arrow"];
        
        [cell.contentView addSubview:shopTelphoneLabel];
        [cell.contentView addSubview:verLine];
        [cell.contentView addSubview:otherShopButton];
        [cell.contentView addSubview:blueArrowView];
        
    } else if (indexPath.section == 2) {
        
        RatingView *ratingView = [[RatingView alloc]initWithFrame:CGRectMake(10, 12, 160, 20)];
        [ratingView setImagesDeselected:@"star_empty"
                         partlySelected:@"star_half"
                           fullSelected:@"star_select"
                            andDelegate:nil];
        
        [ratingView displayRating:couponDetailModel.commentAvg];
        
        ratingView.userInteractionEnabled = NO;
        
        UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 10, 60, 20)];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        ratingLabel.textColor = [UIColor orangeColor];
        ratingLabel.font = [UIFont systemFontOfSize:15.0f];
        ratingLabel.text = [NSString stringWithFormat:@"（%.1f）",couponDetailModel.commentAvg];
        
        UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-130, 10, 100, 20)];
        personLabel.textAlignment = NSTextAlignmentRight;
        personLabel.textColor = [UIColor lightGrayColor];
        personLabel.font = [UIFont systemFontOfSize:14.0f];
        personLabel.text = [NSString stringWithFormat:@"%ld人评论",(long)couponDetailModel.commentCount];
        
        UIImageView *blueArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15, 15, 6, 10)];
        blueArrowView.image = [UIImage imageNamed:@"arrow"];
        
        [cell.contentView addSubview:ratingView];
        [cell.contentView addSubview:ratingLabel];
        [cell.contentView addSubview:personLabel];
        [cell.contentView addSubview:blueArrowView];
        
    } else if (indexPath.section == 3){
        
        UIImageView *dottedLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, WIDTH-10, 1)];
        dottedLine.image = [UIImage imageNamed:@"dotted_line"];
        
        UILabel *explanationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, WIDTH-20, rect.size.height)];
        explanationLabel.backgroundColor = [UIColor clearColor];
        explanationLabel.textAlignment = NSTextAlignmentLeft;
        explanationLabel.font = [UIFont systemFontOfSize:13.0f];
        explanationLabel.textColor = [UIColor lightGrayColor];
        explanationLabel.numberOfLines = 0;
        explanationLabel.text = couponDetailModel.explanation;
        
        [cell.contentView addSubview:dottedLine];
        [cell.contentView addSubview:explanationLabel];
        
    } else if (indexPath.section == 4) {
        
        UILabel *couponDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
        couponDetailLabel.backgroundColor = [UIColor clearColor];
        couponDetailLabel.textAlignment = NSTextAlignmentLeft;
        couponDetailLabel.font = [UIFont boldSystemFontOfSize:15.0];
        couponDetailLabel.textColor = [UIColor orangeColor];
        couponDetailLabel.text = @"券详情";
        
        if (isLoadMore) {
            
            UIImageView *dottedLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 42, WIDTH-10, 1)];
            dottedLine.image = [UIImage imageNamed:@"dotted_line"];
            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            cell.accessoryView = loadingView;
            
            UIWebView *detialView = [self loadCouponDetailViewWith:couponDetailModel.introduceHTML];
            detialView.frame = CGRectMake(0, 45, WIDTH, webViewHeight);
            detialView.scrollView.scrollEnabled = NO;
            
            [cell.contentView addSubview:dottedLine];
            [cell.contentView addSubview:detialView];
        }

        [cell.contentView addSubview:couponDetailLabel];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        
        return 10;
        
    } else {
    
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 5;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if(indexPath.section == 2) {
            
            //票券图片
            NSArray *picArray = [couponDetailModel.picUrl componentsSeparatedByString:@";"];
        
            QuanKongCommentController *commentController = [[QuanKongCommentController alloc]init];
            
            //创建评论列表
            [commentController initCommentListViewWithId:[NSString stringWithFormat:@"%d",couponDetailModel.vocherId]
                                                     And:[NSString stringWithFormat:@"%.2f",couponDetailModel.commentAvg]
                                                     And:couponDetailModel.name
                                                     And:[picArray objectAtIndex:0]];
        
            [self.navigationController pushViewController:commentController animated:YES];
        
        } else if (indexPath.section == 4) {
            
            QuanKongWebViewController *webViewController = [[QuanKongWebViewController alloc]init];
            
            [webViewController initWebViewWithHtml:couponDetailModel.introduceHTML];
            
            [self.navigationController pushViewController:webViewController animated:YES];
            
            
        }
}

#pragma mark - countSelector delegate

- (void)changeCount:(NSString *)count AndState:(BOOL)state AndTag:(int)tag
{
    countValueLabel.text = [NSString stringWithFormat:@"合计：%.2f元",[couponDetailModel.estimateAmount floatValue] * [count intValue]];
    
    couponCount = [count intValue];
}

#pragma mark - button selector

- (void)backButtonClick:(id)sender
{
    [self.delegate popViewControllerGetData:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)otherButtonClick:(UIButton *)sender
{
    QuanKongShopListViewController *shopController = [[QuanKongShopListViewController alloc]init];
    [shopController getShopListWithCouponId:[NSString stringWithFormat:@"%d",couponDetailModel.vocherId]];
    
    [self.navigationController pushViewController:shopController animated:YES];
}

/**
 *  加入购物车按钮
 *
 *  @param sender 加入购物车请求
 */
- (void)buyButtonClick:(UIButton *)sender
{
        switch (sender.tag) {
            case 0:
            {
                
                NSString *addToCartUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%d&count=1&appKey=%@&channelId=%@",NEW_HEAD_LINK,ADD_TO_MY_CART,[UserInfo shareUserInfo].userName,couponDetailModel.vocherId,APP_KEY,_channelId];
                
                [HTTPTool getWithPath:addToCartUrlStr success:^(id success) {
                    
                    NSString *msg = [success objectForKey:@"msg"];
                    
                    if ([msg isEqualToString:@"success"]) {
                        
                        [self.view.window showHUDWithText:@"添加购物车成功" Enabled:YES];
                        
                    } else {
                        
                        [[UserInfo shareUserInfo].userName isEqualToString:@""]?[self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES]:[self.view.window showHUDWithText:[NSString stringWithFormat:@"添加失败,%@",msg] Enabled:YES];
                    }
                    
                } fail:^(NSError *error) {
                    
                    NSLog(@"Fail");
                    
                }];
                
            }
                break;
            case 1:
            {
                
                if ([UserInfo shareUserInfo].phone == NULL || [UserInfo shareUserInfo].userName == NULL || [UserInfo shareUserInfo].isLogined == NO) {
                    
                    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
                } else {
                    
                    if (couponDetailModel.canBuyCount > 0) {
                        
                        [UIView animateWithDuration:0.2 animations:^{
                            
                            bottomView.frame = CGRectMake(0, HEIGHT-64, WIDTH, 50);
                            
                        } completion:^(BOOL finished) {
                            
                            if (finished) {
                                
                                [UIView animateWithDuration:0.3 animations:^{
                                    
                                    orderNowBgView.frame = CGRectMake(0, HEIGHT-64-90, WIDTH, 100);
                                }];
                            }
                            
                        }];
                        
                    } else {
                        
                        [self.view.window showHUDWithText:@"已超过购买数量" Enabled:YES];
                    }
                    
                }
                
            }
                break;
            default:
                break;
        }
    
}

/**
 *  直接购买券按钮
 *
 *  @param sender 弹出直接获取券界面，及请求操作
 */
- (void)orderButtonClick:(UIButton *)sender
{
    
    if ([UserInfo shareUserInfo].userName == NULL || [UserInfo shareUserInfo].isLogined==NO) {
        [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    }else{
        switch (sender.tag) {
            case 0:
            {
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    orderNowBgView.frame = CGRectMake(0, HEIGHT-64, WIDTH, 90);
                    
                } completion:^(BOOL finished) {
                    
                    if(finished) {
                        
                        [UIView animateWithDuration:0.2 animations:^{
                            
                            bottomView.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
                            
                        }];
                    }
                }];
            }
                break;
            case 1:
            {
                /**
                 *  直接购买生成订单请求
                 */
                
                NSString *creatOrderUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%d&count=%d&appKey=%@&channelId=%@",NEW_HEAD_LINK,CREATE_ORDER_NOW,[UserInfo shareUserInfo].userName,couponDetailModel.vocherId,couponCount,APP_KEY,_channelId];
                
                [HTTPTool getWithPath:creatOrderUrlStr success:^(id success) {
                    
                    int code = [[success objectForKey:@"code"] intValue];
                    
                    NSString *msg = [success objectForKey:@"msg"];
                    
                    NSString *orderNumber = [[success objectForKey:@"obj"]objectForKey:@"number"];
                    
                    if (code == 0) {
                        
                        QuanKongPayViewController *payViewController = [[QuanKongPayViewController alloc]init];
                        
                        [payViewController getOrderDetailWith:orderNumber];
                        
                        [self.navigationController pushViewController:payViewController animated:YES];
                        
                    } else {
                        
                        [[UserInfo shareUserInfo].userName isEqualToString:@""]?[self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES]:[self.view.window showHUDWithText:[NSString stringWithFormat:@"出错了,%@",msg] Enabled:YES];

                    }
                    
                } fail:^(NSError *error) {
                    
                     NSLog(@"Fail");
                    
                }];
            
        }
            break;
        default:
            break;
        }
    }
    
}

/**
 *  直接获取券按钮(非现金券类别)
 *
 *  @param sender 直接获取券请求
 */
- (void)getButtonClick:(UIButton *)sender
{
//    if ([UserInfo shareUserInfo].phone == NULL || [UserInfo shareUserInfo].userName == NULL) {
    if ([UserInfo shareUserInfo].userName == NULL || [UserInfo shareUserInfo].isLogined==NO) {
    
//        [UserInfo shareUserInfo].isLogined == NULL?[self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES]:([self.navigationController pushViewController:[[AddictionInfoControllVIew alloc]init] animated:YES]);
        [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    } else {
        
        if (couponDetailModel.canBuyCount > 0){
            
            NSString *getCouponUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%d&count=1&appKey=%@&channelId=%@",NEW_HEAD_LINK,ADD_FREE_COUPON,[UserInfo shareUserInfo].userName,couponDetailModel.vocherId,APP_KEY,_channelId];
            
            [HTTPTool getWithPath:getCouponUrlStr success:^(id success) {
                
                NSString *msg = [success objectForKey:@"msg"];
                
                if ([msg isEqualToString:@"success"]) {
                    
                    [self.view.window showHUDWithText:@"领取成功" Enabled:YES];
                    
                    NSString *number = [[success objectForKey:@"obj"]objectForKey:@"number"];
                    
                    NSString *mingQuanUrlStr = [NSString stringWithFormat:@"%@/common/createOrder_act.jsp?loginName=%@&orderNumber=%@",MC_HEAD_LINK,[UserInfo shareUserInfo].userName,number];
                    
                    [HTTPTool getWithPath:mingQuanUrlStr success:^(id success) {
                        
                        NSLog(@"%@",[success objectForKey:@"msg"]);
                        
                    } fail:^(NSError *error) {
                        
                        NSLog(@"NetWork Fail");
                    }];
                    
                    if (couponTableView) {
                        
                        [self getCouponDetailWithCouponID:[NSString stringWithFormat:@"%d",couponDetailModel.vocherId]
                                                      And:_channelId];
                    }
                    
                } else {
                    
                    [[UserInfo shareUserInfo].userName isEqualToString:@""]?[self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES]:[self.view.window showHUDWithText:[NSString stringWithFormat:@"出错了,%@",msg] Enabled:YES];
                    
                }
                
            } fail:^(NSError *error) {
                
                NSLog(@"fail");
                
            }];
            
        } else {
            
            [self.view.window showHUDWithText:@"已超过限领数量" Enabled:YES];
            
        }
        
    }
}

/**
 *  今日购物车按钮
 *
 *  @param sender 进入购物车界面
 */
- (void)cartButtonClick:(UIButton *)sender
{
    if ([[UserInfo shareUserInfo].userName isEqualToString:@""]) {
        
        [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
        
    } else {
        
        QuanKongOrdersViewController *ordersViewController = [[QuanKongOrdersViewController alloc]init];
        
        [self.navigationController pushViewController:ordersViewController animated:YES];
        
    }
}

/**
 *  收藏按钮
 *
 *  @return 收藏及取消收藏操作
 */
- (void)collectButtonClick:(UIButton *)sender
{
    if ([[UserInfo shareUserInfo].userName isEqualToString:@""]) {
        
        [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
        
    } else {
        
        /**
         *  (block)根据按钮状态选择收藏操作，取消或进行
         *
         *  @param NSString 取消和操作的link_part
         *
         *  @return 操作链接字符串
         */
        NSString* (^selectCollectUrlStr)(NSString *) = ^(NSString *urlTag)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%d&appKey=%@",NEW_HEAD_LINK,urlTag,[UserInfo shareUserInfo].userName,couponDetailModel.vocherId,APP_KEY];
            
            return urlStr;
        };
        
        [HTTPTool getWithPath:sender.selected==NO?selectCollectUrlStr(ADD_FAVORITE):selectCollectUrlStr(DELETE_FAVORITE) success:^(id success) {
            
            NSString *msg = [success objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"success"]) {
                
                /**
                 *  (block)(block)根据按钮状态显示操作显示->同一接口
                 *
                 *  @param select 需要改变的状态
                 *  @param text   提示语
                 *
                 *  @return nil
                 */
                void (^changeCollect)(BOOL select, NSString *text) = ^(BOOL select, NSString *text)
                {
                    sender.selected = select;
                    
                    isCollect = select;
                    
                    [self.view.window showHUDWithText:text Enabled:YES];
                };
                
                sender.selected==NO?changeCollect(YES,@"收藏成功"):changeCollect(NO,@"取消收藏");
                
            } else {
                
                [self.view.window showHUDWithText:msg Enabled:NO];
            }
            
        }fail:^(NSError *error) {
            
            NSLog(@"NetWork Fail");
            
        }];
    }
}

/**
 *  功能按钮
 *
 *  @return 进行查看店铺地址和拨打电话操作
 */
- (void)functionButtonClick:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            QuanKongMapViewController *mapViewController = [[QuanKongMapViewController alloc]init];
            
            [mapViewController setMapViewWith:((QuanKongStore *)[storeListArray objectAtIndex:0]).lat
                                          And:((QuanKongStore *)[storeListArray objectAtIndex:0]).lng
                                          And:((QuanKongStore *)[storeListArray objectAtIndex:0]).name
                                          And:((QuanKongStore *)[storeListArray objectAtIndex:0]).address];
            
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
            break;
        case 1:
        {
            if ([self checkDevice:@"iPhone"]) {
                
                NSMutableString *phoneNumStr = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",((QuanKongStore *)[storeListArray objectAtIndex:0]).telephone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
                
            } else {
                
                UIAlertView *warningAlertView = [[UIAlertView alloc]initWithTitle:@"你使用的设备不可以拨打电话"
                                                                          message:@"请更换设备再尝试"
                                                                         delegate:nil
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"确定", nil];
                
                [warningAlertView show];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 101) {
        
        int scrollPage = scrollView.contentOffset.x/WIDTH;
        
        pageControl.currentPage = scrollPage;
        
    }
    
    if (!isLoadMore) {
        //way-1
        CGPoint contentOffsetPoint = self.couponTableView.contentOffset;
        CGRect frame = self.couponTableView.frame;
        
        if (contentOffsetPoint.y > self.couponTableView.contentSize.height - frame.size.height + 100 || self.couponTableView.contentSize.height < frame.size.height)
        {
            NSLog(@"scroll to the end");
            
            isLoadMore = YES;
            
            [couponTableView reloadData];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)loadCouponDetailViewWith:(NSString *)html
{
    NSString *css =[NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "img{max-width:100%%;\n}"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>",html];
    
    UIWebView *detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 45, WIDTH, 1)];
    detailWebView.delegate = self;
    [detailWebView loadHTMLString:css baseURL:nil];
    
    return detailWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webViewHeight != webView.scrollView.contentSize.height)
    {
        webViewHeight = webView.scrollView.contentSize.height;
        [couponTableView reloadData];
    }
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
