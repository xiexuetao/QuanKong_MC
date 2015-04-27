//
//  QuanKongNoPaymentViewController.m
//  QuanKong
//
//  Created by rick on 14/10/28.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongNoPaymentViewController.h"
#import "couponLIstViewCell.h"
#import "QuanKongVoucher.h"
#import "UIImageView+WebCache.h"
#import "QuanKongCouponDetailViewController.h"
#import "QuanKongPayViewController.h"
#import "HTTPTool.h"
#import "QuanKongOrderViewController.h"
#import "QuanKongTakeCommentViewController.h"
#import "OrderInfo.h"
#import "OrderTableViewCell.h"
#import "Prompt.h"  
#import "LoadingHUDView.h"

#import "NSDate+Help.h"
#import "NSString+DisposeStr.h"

@interface QuanKongNoPaymentViewController (){
    UITableView *_tableView;
    NSInteger _count;
    OrderInfo *_orderInfo;
}

@end

@implementation QuanKongNoPaymentViewController


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

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(setPayTag:) name:@"payTag" object:nil];
    
        self.navigationItem.title = @"订单详情";
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

-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

/**
 *  创建底部view
 */
-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    [_tableView setTableFooterView:view];
    if(_orderInfo.state.integerValue == 0){
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-114, WIDTH, 50)];
        botView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        but.frame = CGRectMake(10+((WIDTH-10)/2), 10, (WIDTH-30)/2, 30);
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [botView addSubview:but];
        [but setTitle:@"付款" forState:UIControlStateNormal];
        [but setBackgroundColor:[UIColor orangeColor]];
        [but addTarget:self action:@selector(clickBut) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.frame = CGRectMake(10, 10, (WIDTH-30)/2, 30);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancel setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:100.0/255.0
                                                                       blue:49.0/255.0
                                                                      alpha:1.0]];
        [cancel addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:cancel];
        [self.view insertSubview:botView aboveSubview:_tableView];
    }else if(_orderInfo.state.integerValue == 2){
        
    }

//    if (self.payTag == 1) {
//        NSLog(@"-------------->>>>>>%i",self.payTag);
//    }else{
//        
//    }
}


-(void)deleteOrder{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UserInfo *userInfo = [UserInfo shareUserInfo];
        NSString *str = [NSString stringWithFormat:@"%@%@&appKey=%@&orderNumber=%@&loginName=%@",NEW_HEAD_LINK,DELETE_ORDER_METHOD,APP_KEY,_orderInfo.number,userInfo.userName];
        
        [HTTPTool getWithPath:str success:^(id success) {
            NSNumber *i = [success objectForKey:@"code"];
            if ([i integerValue]==0) {
                [self.view.window showHUDWithText:@"取消订单成功" Enabled:YES];
                [self.delegate popViewControllerOptionGetData:self];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"取消订单失败" Enabled:YES];
        }];
    }
}


-(void)backOrderDelegate:(QuanKongPayViewController *)payViewController{
    
    [self getData];
}

/**
 *  获取订单
 */
-(void)getData{
    
    _count = 0;
    
    [LoadingHUDView showLoadinginView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@&orderNumber=%@",NEW_HEAD_LINK,ORDER_ITEM_METHOD,[UserInfo shareUserInfo].userName,APP_KEY,self.orderId];
    [HTTPTool getWithPath:str success:^(id success) {
        NSString * i = [success objectForKey:@"event"];
        [IntnetPrompt hideIntnetPromptForView:self.view animated:YES];
        
        if ([i isEqualToString:@"0"]) {
            //返回的数据订单子项
            
            
            NSDictionary *dic = [success objectForKey:@"obj"];
            NSArray *coupons = [dic objectForKey:@"couponList"];
            
            NSMutableArray *couponArr = [NSMutableArray array];
            
            _orderInfo = [OrderInfo initWihtData:dic];
            
            for (int x=0; x<coupons.count; x++) {
                
                QuanKongVoucher *voucher = [QuanKongVoucher initWihtData:coupons[x]];
                
                _count = _count + voucher.count;
                
                [couponArr addObject:voucher];
            }
            
            _orderInfo.couponList = couponArr;
            
             [self createTableView];
            [self createFootView];
            
            [LoadingHUDView hideLoadingView];
        }
    } fail:^(NSError *error) {
        
        [LoadingHUDView hideLoadingView];
        IntnetPrompt *intnet = [IntnetPrompt showIntnetPromptWithMessage:INTNET_PROMPT_STRING inView:self.view];
        intnet.delegate = self;
        
    }];
}

-(void)clickButtonOperation:(IntnetPrompt *)intnetView{
    [self getData];
}


#pragma mark-按钮点击处理
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate popViewControllerOptionGetData:self];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _orderInfo.couponList.count;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 200;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.000000001;
    }else{
        return 40;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
        la.text = @"订单详情";
        la.font = [UIFont systemFontOfSize:15.f];
        la.textColor = [UIColor darkGrayColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        [view addSubview:la];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 0.000000000001f;
    }else{
        return 0.000000000001f;
    }
}


-(void)clickBut{
    
    BOOL boolean = NO;
    for (int x=0; x<_orderInfo.couponList.count; x++) {
        
        QuanKongVoucher *vc = _orderInfo.couponList[x];
        
        int saleCount = vc.saleCount;
        int issueCount = vc.issueCount;
        if (vc.bizState != 0 && issueCount != saleCount) {
            boolean = YES;
        }else{
            boolean = NO;
        }
    }

    if (boolean) {
        
#warning orderId需要转为orderNumber
        
        QuanKongPayViewController *pay = [[QuanKongPayViewController alloc] init];
        pay.delegate = self;
        [pay getOrderDetailWith:_orderInfo.number];
        [self.navigationController pushViewController:pay animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"订单内包含已下架或已售完的券请重新下单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        QuanKongVoucher *vc = _orderInfo.couponList[indexPath.row];
        QuanKongCouponDetailViewController *couponDetailViewController = [[QuanKongCouponDetailViewController alloc]init];
        couponDetailViewController.hidesBottomBarWhenPushed = YES;
        
        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            NSString *ID = [business objectForKey:@"id"];
            if ([i isEqualToString:@"0"]) {
                [couponDetailViewController getCouponDetailWithCouponID:[NSString stringWithFormat:@"%i",vc.vocherId]And:ID];
                [self.navigationController pushViewController:couponDetailViewController animated:YES];
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
        }];
    }
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"status_%d",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = [[couponLIstViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        QuanKongVoucher *vc = _orderInfo.couponList[indexPath.row];
        
        couponLIstViewCell *listCell = (couponLIstViewCell *)cell;
        //券的的图片
        
        NSString *str = [NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[vc.picUrl componentsSeparatedByString:@";"][0]];
        [listCell.logoImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
        
        //券的名称
        listCell.titleLabel.text = vc.name;
        MyLog(@"------------%@",vc.name);
        listCell.titleLabel.textColor = [UIColor darkGrayColor];
        
        //券的介绍
        //销售价格
        NSString *text = [NSString stringWithFormat:@"单价：%@ 元    数量：%i",vc.estimateAmount,vc.count];
        listCell.introduceLabel.text = text;
        
        //暂不需要
        
        //券的类型logo
        UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(85-23, 75-23, 23, 23)];
        
        NSString *estimateStr = [NSString stringWithFormat:@"金额：%@ 元",vc.total];
        NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
        
        [estimateAmountStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, estimateStr.length-4)];
        [estimateAmountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(3, estimateStr.length-4)];
        
        listCell.valueLabel.attributedText = estimateAmountStr;
        
        //原价
        float estimateStrLength = [NSString widthOfString:estimateStr withFont:[UIFont systemFontOfSize:15.0f]];
        
        listCell.cutValueLabel.frame = CGRectMake(105+estimateStrLength+5, 69, 50, 20);
        
        [listCell.logoImageView addSubview:typeImageView];
        return listCell;
    }else{
        OrderTableViewCell *orderCell = (OrderTableViewCell *)cell;
        orderCell.orderId.text = [NSString stringWithFormat:@"订单编号：%@",_orderInfo.number];
        orderCell.time.text = [NSString stringWithFormat:@"%@%@",@"下单时间：",[NSDate timeFormatted:_orderInfo.createTime.longLongValue model:@"yyyy-MM-dd HH:mm:ss"]];
        NSMutableAttributedString *c = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"数量：%i",_count]];
        [c addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, c.length-3)];
        orderCell.count.attributedText = c;
        NSMutableAttributedString *t = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价：%.2f 元",[_orderInfo.total doubleValue]]];
        [t addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, t.length-4)];
        orderCell.total.attributedText = t;
        NSString *orderStr;
        if (_orderInfo.state.integerValue == 2) {
            orderStr = [NSString stringWithFormat:@"订单状态：%@",@"已支付"];
        }else{
            orderStr = [NSString stringWithFormat:@"订单状态：%@",@"未支付"];
        }
        NSMutableAttributedString *os = [[NSMutableAttributedString alloc] initWithString:orderStr];
        [os addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, 3)];
        [os addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(5, 3)];
        orderCell.orderState.attributedText = os;
        return orderCell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
