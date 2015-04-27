//
//  QuanKongPayViewController.m
//  QuanKong
//
//  Created by POWER on 14-10-9.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongPayViewController.h"
#import "PartnerConfig.h"

#import "DataSigner.h"
#import "Order.h"

#import "QuanKongNoPaymentViewController.h"
#import "PasswrodMangerViewController.h"
#import "QuanKongCouponDetailViewController.h"
#import "RechargeViewController.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@implementation QuanKongPayViewController
{
    NSUInteger orderCount;
    NSDictionary *orderInfoDic;
    
    NSMutableArray *itemListArray;
    NSMutableArray *couponListArray;
    
    NSMutableDictionary *selectDic;
    
    NSString *paySelectPayCount;
    NSString *welletCount;
    
    UIButton *payButton;
    
    BOOL isShow;
}

@synthesize payTableView;
@synthesize resultView;
@synthesize result = _result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.tabBarController.tabBar.hidden = YES;
        
        self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
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
        titleLabel.text = @"选择支付方式";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        selectDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [selectDic setValue:@[@"enable",@"disable",@"disable",@"disable"] forKey:@"0"];
        [selectDic setValue:@[@"disable",@"enable",@"disable",@"disable"] forKey:@"1"];
        [selectDic setValue:@[@"disable",@"disable",@"enable",@"disable"] forKey:@"2"];
        [selectDic setValue:@[@"disable",@"disable",@"disable",@"enable"]  forKey:@"3"];
        
        [LoadingHUDView showLoadinginView:self.view];
        
        resultView = [[ResultView alloc]init];
        
    }
    
    paySelectPayCount = @"0";
    
    isShow = NO;
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshWellDetail];
}

/**
 *  创建支付低栏
 */
- (void)initBottomView
{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-50, WIDTH, 50)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.userInteractionEnabled = YES;
    
    UIView *clearBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    clearBackView.backgroundColor = [UIColor blackColor];
    clearBackView.alpha = 0.7;
    
    payButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH+30)/4, 10, (WIDTH-30)/2, 30)];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 2.0;
    payButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [payButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    payButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
    
    [self.view insertSubview:bottomView aboveSubview:payTableView];
    [bottomView addSubview:clearBackView];
    [bottomView addSubview:payButton];
    
    if (([welletCount floatValue] - [[orderInfoDic objectForKey:@"total"]floatValue]) < 0) {
        
        [payButton setTitle:@"去充值" forState:UIControlStateNormal];
        [payButton setBackgroundColor:[UIColor grayColor]];
        
    } else {
        
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [payButton setBackgroundColor:[UIColor orangeColor]];
    }

}

/**
 *  //创建支付宝订单模型
 *
 *  @param orderDic      订单数据字典
 *  @param couponInfoDic 券信息字典
 *
 *  @return 支付宝合并支付字符串
 */
- (NSString *)createProductWith:(NSDictionary *)orderDic And:(NSDictionary *)couponInfoDic
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [[Product alloc]init];
    product.subject = [orderDic objectForKey:@"name"];
    product.body = [couponInfoDic objectForKey:@"introduce"];
    product.price = [[NSString stringWithFormat:@"%.2f",[[orderDic objectForKey:@"total"] floatValue]] floatValue];
    
    Order *payOrder = [[Order alloc]init];
    payOrder.partner = PartnerID;
    payOrder.seller = SellerID;
    
    payOrder.tradeNO = [NSString stringWithFormat:@"%@_%@",[UserInfo shareUserInfo].userName,[orderDic objectForKey:@"number"]];
    payOrder.productName = product.subject; //商品标题
    payOrder.productDescription = product.body; //商品描述
    payOrder.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    
    //测试环境
//    payOrder.notifyURL = @"http://203.195.192.178/payment/alipay/notifySecureMsg.a";
    
    //UAT环境
//    payOrder.notifyURL = @"http://uat.b.quancome.com/payment/alipay/notifySecureMsg.a";
    
    //生产
    payOrder.notifyURL = [NSString stringWithFormat:@"%@/alipay/quanNotify_url.jsp",MC_HEAD_LINK];
    
    payOrder.service = @"mobile.securitypay.pay";
    payOrder.paymentType = @"1";
    payOrder.inputCharset = @"utf-8";
    payOrder.itBPay = @"30m";
    payOrder.showUrl = @"m.alipay.com";

    return [payOrder description];
}

/**
 *  获取我的钱包详情
 */
- (void)getWelletDetail
{
    NSString *myWelletUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,GET_MY_WALLET,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:myWelletUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            NSDictionary *obj_Dic = [success objectForKey:@"obj"];
            
            //我的钱包数目
            welletCount = [NSString stringWithFormat:@"%@",[obj_Dic objectForKey:@"account"]];
            
            [self initBottomView];
            
            [payTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"fail");
        
    }];
}

/**
 *  刷新我的钱包
 */
- (void)refreshWellDetail
{
    NSString *myWelletUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,GET_MY_WALLET,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:myWelletUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            NSDictionary *obj_Dic = [success objectForKey:@"obj"];
            
            //我的钱包数目
            welletCount = [NSString stringWithFormat:@"%@",[obj_Dic objectForKey:@"account"]];
            
            if (([welletCount floatValue] - [[orderInfoDic objectForKey:@"total"]floatValue]) < 0) {
                
                [payButton setTitle:@"去充值" forState:UIControlStateNormal];
                [payButton setBackgroundColor:[UIColor grayColor]];
                
            } else {
                
                [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
                [payButton setBackgroundColor:[UIColor orangeColor]];
            }
            
            [payTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"fail");
        
    }];
}

/**
 *  通过orderNumber获取订单详情
 *
 *  @param orderNumber 订单号 -> orderNumber
 */
- (void)getOrderDetailWith:(NSString *)orderNumber
{
    NSString *orderDetailUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&orderNumber=%@&appKey=%@",NEW_HEAD_LINK,ORDER_DETAIL,[UserInfo shareUserInfo].userName,orderNumber,APP_KEY];
    
    [HTTPTool getWithPath:orderDetailUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            itemListArray = [[NSMutableArray alloc]initWithCapacity:0];
            itemListArray = [[success objectForKey:@"obj"]objectForKey:@"couponList"];
            
            couponListArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            for (int i = 0; i < itemListArray.count; i++) {
                
                orderCount += [[[itemListArray objectAtIndex:i]objectForKey:@"count"] intValue];
                
            }
            
            [couponListArray addObject:[itemListArray objectAtIndex:0]];
            
            orderInfoDic = [success objectForKey:@"obj"];
            
            //创建页面
            [self initPayTableView];
            
            [self getWelletDetail];
            
            [LoadingHUDView hideLoadingView];
            
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
}

/**
 *  付款方式列表
 */
- (void)initPayTableView
{
    if (!payTableView) {
        
        payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        payTableView.backgroundColor = [UIColor clearColor];
        payTableView.dataSource = self;
        payTableView.delegate = self;
        payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self.view insertSubview:payTableView atIndex:1];
}

- (void)reloadData
{
    [payTableView reloadData];
}

#pragma mark - TableView data source

//方法类型：系统方法
//编   写：peter
//方法功能：返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

//方法类型：系统方法
//编   写：peter
//方法功能：返回tableViewCell 的个数 = 问题的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        
        return 2;
        
    } else if(section == 0){
        
        NSInteger tableCount;
        
        itemListArray.count > 1?(tableCount = couponListArray.count + 1):(tableCount=1);
        
        return tableCount;
        
    } else {
        
        return 1;
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == couponListArray.count) {
            
            return 35;
            
        } else {
            
            return 80;
        }
        
    } else if (indexPath.section == 1) {
        
        return 70;
    
    } else {
    
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        
        return 40;
        
    } else {
        
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        return 5;
        
    } else {
        
        return 15;
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
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == couponListArray.count) {
            
            UILabel *otherCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
            otherCouponLabel.textAlignment = NSTextAlignmentLeft;
            otherCouponLabel.textColor = [UIColor colorWithRed:5.0/255.0
                                                         green:184.0/255.0
                                                          blue:229.0/255.0
                                                         alpha:1.0];
            
            otherCouponLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            
            isShow==0?(otherCouponLabel.text = @"显示全部"):(otherCouponLabel.text = @"收起全部");
            
            UILabel *orderCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 80, 35)];
            orderCountLabel.textAlignment = NSTextAlignmentLeft;
            orderCountLabel.textColor = [UIColor lightGrayColor];
            orderCountLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            orderCountLabel.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)itemListArray.count-1];
            
            UIImageView *blueArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15, 12.5, 6, 10)];
            blueArrowView.image = [UIImage imageNamed:@"arrow"];
            
            [cell.contentView addSubview:otherCouponLabel];
            [cell.contentView addSubview:orderCountLabel];
            [cell.contentView addSubview:blueArrowView];
            
        } else {
            
            NSArray *picArray = [[[couponListArray objectAtIndex:indexPath.row] objectForKey:@"picUrl"] componentsSeparatedByString:@";"];
            
            //券的的图片
            UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 75, 60)];
            
            [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[picArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
            
            CGRect rect = [[orderInfoDic objectForKey:@"name"] boundingRectWithSize:CGSizeMake(WIDTH-115, MAXFLOAT)
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]}
                                                                            context:nil];
            
            NSArray *titleArray = [[orderInfoDic objectForKey:@"name"] componentsSeparatedByString:@"、"];
            
            //券的名称
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, WIDTH-115, rect.size.height+5)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            
            //券的总数
            UILabel *totalCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 52, 80, 20)];
            totalCountLabel.backgroundColor = [UIColor clearColor];
            totalCountLabel.font = [UIFont systemFontOfSize:14.0f];
            totalCountLabel.textAlignment = NSTextAlignmentLeft;
            totalCountLabel.textColor = [UIColor lightGrayColor];
            totalCountLabel.text = [NSString stringWithFormat:@"数量：%d张",[[[couponListArray objectAtIndex:indexPath.row]objectForKey:@"count"] intValue]];
            
            //券的总价值介绍
            UILabel *totalValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(185, 52, 125, 20)];
            totalValueLabel.backgroundColor = [UIColor clearColor];
            totalValueLabel.font = [UIFont systemFontOfSize:14.0f];
            totalValueLabel.textAlignment = NSTextAlignmentRight;
            totalValueLabel.textColor = [UIColor orangeColor];
            totalValueLabel.text = [NSString stringWithFormat:@"小计：%.2f元",[[[couponListArray objectAtIndex:indexPath.row]objectForKey:@"estimateAmount"]floatValue] * [[[couponListArray objectAtIndex:indexPath.row]objectForKey:@"count"] intValue]];
            
            [cell.contentView addSubview:logoImageView];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:totalValueLabel];
            [cell.contentView addSubview:totalCountLabel];
        
        }
    
    } else if (indexPath.section == 1) {
        
        UIImageView *dottedLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 35, WIDTH-10, 1)];
        dottedLine.image = [UIImage imageNamed:@"dotted_line"];
        
        NSArray *titleArray = @[@"合计:",@"还需支付:"];
        
        for (int i = 0; i < 2; i++) {
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0+35*i, 160, 35)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.text = [titleArray objectAtIndex:i];
            
            UILabel *payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0+35*i, WIDTH-170, 35)];
            payCountLabel.backgroundColor = [UIColor clearColor];
            payCountLabel.textAlignment = NSTextAlignmentRight;
            payCountLabel.textColor = [UIColor grayColor];
            payCountLabel.font = [UIFont systemFontOfSize:14.0f];
            payCountLabel.text = [NSString stringWithFormat:@"%@元",[orderInfoDic objectForKey:@"total"]];
            
            if (i == 1) {
                
                payCountLabel.textColor = [UIColor orangeColor];
            }
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:payCountLabel];
            [cell.contentView addSubview:dottedLine];
        }
        
    } else if (indexPath.section == 2) {
        
        NSArray *titleArray = @[@"钱包支付",@"支付宝支付",@"微信支付",@"银联支付"];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 60, 28)];
        iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pay_icon_%zd",indexPath.row]];
        
        UILabel *payWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 140, 30)];
        payWayLabel.backgroundColor = [UIColor clearColor];
        payWayLabel.textAlignment = NSTextAlignmentLeft;
        payWayLabel.textColor = [UIColor grayColor];
        payWayLabel.font = [UIFont systemFontOfSize:15.0f];
        payWayLabel.text = [titleArray objectAtIndex:indexPath.row];
        
        UIButton *selcetButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-40, 12.5, 25, 25)];
        [selcetButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_disable"] forState:UIControlStateNormal];
        [selcetButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_enable"] forState:UIControlStateNormal];
        selcetButton.tag = indexPath.row;
        
        UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-45, 2.5, 40, 45)];
        selectImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pay_btn_%@_all",[[selectDic objectForKey:paySelectPayCount] objectAtIndex:indexPath.row]]];
        selectImageView.tag = indexPath.row;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49.5, WIDTH-10, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        
        if (indexPath.row == 0) {
            
            UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 120, 30)];
            accountLabel.backgroundColor = [UIColor clearColor];
            accountLabel.textAlignment = NSTextAlignmentLeft;
            accountLabel.textColor = [UIColor orangeColor];
            accountLabel.font = [UIFont systemFontOfSize:15.0f];
            
            if ([welletCount floatValue] - [[orderInfoDic objectForKey:@"total"]floatValue] < 0) {
                
                accountLabel.text = @"（余额不足）";
                
            } else {
                
                accountLabel.text = [NSString stringWithFormat:@"（%.2f元）",[welletCount floatValue]];
                
            }
        
            [cell.contentView addSubview:accountLabel];
        }
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:payWayLabel];
        [cell.contentView addSubview:selectImageView];
        [cell.contentView addSubview:lineView];
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2) {
        
        UIView *headBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        headBg.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
        headerLabel.backgroundColor= [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:15.0f];
        headerLabel.text = [NSString stringWithFormat:@"选择支付方式"];
        
        [headBg addSubview:headerLabel];
        
        return headBg;
        
    } else {
        
        return nil;
    }
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == couponListArray.count) {
            
            if (!isShow) {
                
                NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:0];
                
                for (int i = 1; i < itemListArray.count; i++) {
                    
                    [couponListArray addObject:[itemListArray objectAtIndex:i]];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    
                    [indexPaths addObject:indexPath];
                }
                
                [payTableView beginUpdates];
                
                [payTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [payTableView endUpdates];
                
                [self performSelector:@selector(reloadData)withObject:nil afterDelay:0.35];
                
                isShow = YES;
                
            } else {
                
                NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:0];
                
                couponListArray = [[NSMutableArray alloc]initWithCapacity:0];
                
                [couponListArray addObject:[itemListArray objectAtIndex:0]];
                
                for (int i = 1; i < itemListArray.count; i++) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    
                    [indexPaths addObject:indexPath];
                }
                
                [payTableView beginUpdates];
                
                [payTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [payTableView endUpdates];
                
                [self performSelector:@selector(reloadData)withObject:nil afterDelay:0.35];
                
                isShow = NO;
            }
            
        } else {
            
            QuanKongCouponDetailViewController *couponDetailViewCtrl = [[QuanKongCouponDetailViewController alloc]init];
            
            [couponDetailViewCtrl getCouponDetailWithCouponID:[[couponListArray objectAtIndex:indexPath.row]objectForKey:@"id"]
                                                          And:@"0"];
            
            [self.navigationController pushViewController:couponDetailViewCtrl animated:YES];
        }
        
    }
    
    if (indexPath.section == 2) {
        
        paySelectPayCount = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        [payTableView reloadData];
        
        if (indexPath.row == 0) {
            
            if ([welletCount floatValue] - [[orderInfoDic objectForKey:@"total"]floatValue] < 0) {
                
                [payButton setTitle:@"去充值" forState:UIControlStateNormal];
                [payButton setBackgroundColor:[UIColor grayColor]];
                
            } else {
                
                [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
                [payButton setBackgroundColor:[UIColor orangeColor]];
            }
            
        } else {
            
            [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
            [payButton setBackgroundColor:[UIColor orangeColor]];
        }
    }
}

#pragma mark - button selector

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  支付按钮操作
 *
 *  @param sender -> 根据支付方式进行操作
 */
- (void)buyButtonClick:(UIButton *)sender
{
    switch ([paySelectPayCount intValue]) {
            
        case 0:
        {
            
            if ([[UserInfo shareUserInfo].isSetPayPass isEqualToString:@"0"]) {
                
                UIAlertView *setPayPassAlertView = [[UIAlertView alloc]initWithTitle:@"你还没有设置交易密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置交易密码", nil];
                setPayPassAlertView.tag = 103;
                [setPayPassAlertView show];
                
            } else {
                
                if ([welletCount floatValue] - [[orderInfoDic objectForKey:@"total"]floatValue] < 0) {
                    
                    /*RechargeViewController *rechargeViewController = [[RechargeViewController alloc]init];
                    
                    [self.navigationController pushViewController:rechargeViewController animated:YES];*/

                    
                } else {
            
                    UIAlertView *confrimAlertView = [[UIAlertView alloc]initWithTitle:@"确认支付" message:@"请输入交易密码确认支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    confrimAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    confrimAlertView.tag = 101;
                    [confrimAlertView show];
                    
                }
                
            }
            
        }
            break;
        case 1:
        {
            /*
             *生成订单信息及签名
             *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
             */
            
            NSString *appScheme = @"QuanKong";
            
            NSString* orderInfo = [self createProductWith:orderInfoDic And:[itemListArray objectAtIndex:0]];
            
            NSString* signedStr = [self doRsa:orderInfo];
            
            if (signedStr) {
                
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                         orderInfo, signedStr, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSString *result = [resultDic objectForKey:@"resultStatus"];
                    
                    NSLog(@"%@",result);
                    
                        switch ([result intValue]) {
                            case 9000:
                            {
                                [resultView showResultViewWihtTitle:@"支付成功"
                                                         AndMessage:@"你可以立刻在我的券包中找到并使用了！"
                                                     AndButtonTitle:@"返回"
                                                        AndDelegate:self
                                                           ByResult:YES
                                                             InView:self.view.window];
                            }
                                break;
                            case 4000:
                            {
                                [resultView showResultViewWihtTitle:@"支付失败"
                                                         AndMessage:@"请确定资料是否正确，或是否正确操作。"
                                                     AndButtonTitle:@"重新支付"
                                                        AndDelegate:self
                                                           ByResult:NO
                                                             InView:self.view.window];
                            }
                                break;
                            case 6001:
                            {
                                [resultView showResultViewWihtTitle:@"支付失败"
                                                         AndMessage:@"支付被中途取消了。"
                                                     AndButtonTitle:@"重新支付"
                                                        AndDelegate:self
                                                           ByResult:NO
                                                             InView:self.view.window];
                            }
                                break;
                            case 6002:
                            {
                                [resultView showResultViewWihtTitle:@"支付失败"
                                                         AndMessage:@"网络出现问题了，请检查你的网络"
                                                     AndButtonTitle:@"重新支付"
                                                        AndDelegate:self
                                                           ByResult:NO
                                                             InView:self.view.window];
                            }
                                break;
                            default:
                                break;
                        }
                }];
                
            }

        }
            break;
        default:
            break;
    }
}

#pragma ailipay delegate

/**
 *  支付宝前面RSA加密
 *
 *  @param orderInfo 订单信息
 *
 *  @return 签名信息
 */
-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    
    signer = CreateRSADataSigner(PartnerPrivKey);
    
    NSString *signedString = [signer signString:orderInfo];
    
    return signedString;
}

#pragma mark alertView delegate

/**
 *  钱包交易 密码填写操作
 *
 *  @param alertView   nil
 *  @param buttonIndex 按钮标识
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 101:
        {
            
            if (buttonIndex == 1) {
                
                if ([[(UITextField *)[alertView textFieldAtIndex:0]text] isEqualToString:@""]) {
                    
                    UIAlertView *failAlertView = [[UIAlertView alloc]initWithTitle:@"请输入交易密码" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 认", nil];
                    
                    [failAlertView show];
                    
                } else {
                    
                    NSString *password_md5 = [self md5:[(UITextField *)[alertView textFieldAtIndex:0]text]];
                    
                    NSString *payByWelletUrlStr = [NSString stringWithFormat:@"%@%@&orderNumber=%@&loginName=%@&payPass=%@&appKey=%@",NEW_HEAD_LINK,PAY_BY_WALLET,[orderInfoDic objectForKey:@"number"],[UserInfo shareUserInfo].userName,password_md5,APP_KEY];
                    
                    [HTTPTool getWithPath:payByWelletUrlStr success:^(id success) {
                        
                        if ([[success objectForKey:@"msg"] isEqualToString:@"success"]) {
                            
                            UIAlertView *successAlertView = [[UIAlertView alloc]initWithTitle:@"购买成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确 认", nil];
                            successAlertView.delegate = self;
                            successAlertView.tag = 102;
                            [successAlertView show];
                            
                        } else {
                            
                            UIAlertView *failAlertView = [[UIAlertView alloc]initWithTitle:[success objectForKey:@"购买失败"] message:[success objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 认", nil];
                            
                            [failAlertView show];
                        }

                    } fail:^(NSError *error) {
                        
                         NSLog(@"Fail");
                        
                    }];
                    
                }
            }
            
        }
            break;
        case 102:
        {
            
            [self.delegate backOrderDelegate:self];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 103:
        {
            if (buttonIndex == 1) {
                
                PasswrodMangerViewController *passwordManagerViewController = [[PasswrodMangerViewController alloc]initWithPasswrodType:0];
                [self.navigationController pushViewController:passwordManagerViewController animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - resultView delegate

/**
 *  支付结果提示界面委托操作
 *
 *  @param sender nil
 */
- (void)resultButtonClick:(UIButton *)sender
{
    /**
     *  根据button.tag做相应操作
     */
    switch (sender.tag) {
        case 0:
        {
            [resultView dismiss];
        }
            break;
        case 1:
        {
            [resultView dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  生成MD5
 *
 *  @param str 原始字符串
 *
 *  @return 转化后的MD5码
 */
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


-(void)dealloc
{
    
#if ! __has_feature(objc_arc)
    
    [_products release];
    [super dealloc];
    
#endif
    
}

@end
