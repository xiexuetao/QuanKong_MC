//
//  RechargeViewController.m
//  QuanKong
//
//  Created by POWER on 12/18/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import "RechargeViewController.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "Order.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RechargeViewController
{
    BOOL isHaveDian;
}

@synthesize rechargeTableView;
@synthesize rechargeTextField;
@synthesize rechargeButton;

@synthesize result = _result;
@synthesize resultView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        titleLabel.text = @"充值";
        
        self.navigationItem.titleView = titleLabel;
        
        resultView = [[ResultView alloc]init];
        
        /**
         支付方式标识
         */
        if (!selectDic) {
            
            selectDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            
            [selectDic setValue:@[@"enable",@"disable",@"disable",@"disable"] forKey:@"0"];
            [selectDic setValue:@[@"disable",@"enable",@"disable",@"disable"] forKey:@"1"];
            [selectDic setValue:@[@"disable",@"disable",@"enable",@"disable"] forKey:@"2"];
            [selectDic setValue:@[@"disable",@"disable",@"disable",@"enable"]  forKey:@"3"];
        }
        
        paySelectPayCount = @"0";
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
}

/**
 *  创建充值界面
 */
- (void)initRechargeView
{
    if (!rechargeTableView) {
        
        rechargeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        rechargeTableView.delegate = self;
        rechargeTableView.dataSource = self;
        rechargeTableView.backgroundColor = [UIColor clearColor];
        rechargeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self.view insertSubview:rechargeTableView atIndex:1];
}

/**
 *  //创建支付宝订单模型
 *
 *  @param orderDic      订单数据字典
 *  @param couponInfoDic 券信息字典
 *
 *  @return 支付宝合并支付字符串
 */
- (NSString *)creatRechargeOrderInfo
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    Order *payOrder = [[Order alloc]init];
    payOrder.partner = PartnerID;
    payOrder.seller = SellerID;
    
    payOrder.tradeNO = [self setRechargeOrderNumber];
    payOrder.productName = @"钱包充值"; //商品标题
    payOrder.productDescription = [NSString stringWithFormat:@"钱包充值:%@元",rechargeTextField.text]; //商品描述
    payOrder.amount = [NSString stringWithFormat:@"%.2f",[rechargeTextField.text floatValue]]; //商品价格
    
//    payOrder.notifyURL = @"http://203.195.192.178:81/payment/alipay/notifyRechargeSecureMsg.a"; //开发充值回调URL
    
//    payOrder.notifyURL = @"http://uat.b.quancome.com/payment/alipay/notifyRechargeSecureMsg.a"; //测试充值回调URL
    
    payOrder.notifyURL = @"http://b.quancome.com/payment/alipay/notifyRechargeSecureMsg.a"; //生产充值回调URL
    
    payOrder.service = @"mobile.securitypay.pay";
    payOrder.paymentType = @"1";
    payOrder.inputCharset = @"utf-8";
    payOrder.itBPay = @"30m";
    payOrder.showUrl = @"m.alipay.com";
    
    return [payOrder description];
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
    
    if (!rechargeButton) {
        
        rechargeButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH+30)/4, 10, (WIDTH-30)/2, 30)];
        rechargeButton.layer.cornerRadius = 2.0;
        rechargeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rechargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
        
        [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rechargeButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.view insertSubview:bottomView aboveSubview:rechargeTableView];
    [bottomView addSubview:clearBackView];
    [bottomView addSubview:rechargeButton];
}

#pragma mark - button selector

/**
 *  退出界面
 *
 *  @param sender nil
 */
- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paySuccess:(NSNotification *)notification
{
    NSLog(@"success");
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  充值操作
 *
 *  @param sender nil
 */
- (void)rechargeButtonClick:(UIButton *)sender
{
    
    [rechargeTextField resignFirstResponder];
    
    if (![rechargeTextField.text isEqualToString:@""] && [rechargeTextField.text floatValue] >= 1) {
        
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        
        NSString *appScheme = @"QuanKong";
        
        NSString* orderInfo = [self creatRechargeOrderInfo];
        
        NSString* signedStr = [self doRsa:orderInfo];
        
        if (signedStr) {
            
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString
                                      fromScheme:appScheme
                                        callback:^(NSDictionary *resultDic) {
                
                                            NSString *result = [resultDic objectForKey:@"resultStatus"];
                                            
                                            NSLog(@"%@",result);
                                            
                                            switch ([result intValue]) {
                                                case 9000:
                                                {
                                                    [resultView showResultViewWihtTitle:@"充值成功"
                                                                             AndMessage:@"请检查你的钱包，款项将在15分钟内到账。"
                                                                         AndButtonTitle:@"返回"
                                                                            AndDelegate:self
                                                                               ByResult:YES
                                                                                 InView:self.view.window];
                                                }
                                                    break;
                                                case 4000:
                                                {
                                                    [resultView showResultViewWihtTitle:@"充值失败"
                                                                             AndMessage:@"请确定资料是否正确，或是否正确操作。"
                                                                         AndButtonTitle:@"重新充值"
                                                                            AndDelegate:self
                                                                               ByResult:NO
                                                                                 InView:self.view.window];
                                                }
                                                    break;
                                                case 6001:
                                                {
                                                    [resultView showResultViewWihtTitle:@"充值失败"
                                                                             AndMessage:@"充值支付被中途取消了。"
                                                                         AndButtonTitle:@"重新充值"
                                                                            AndDelegate:self
                                                                               ByResult:NO
                                                                                 InView:self.view.window];
                                                }
                                                    break;
                                                case 6002:
                                                {
                                                    [resultView showResultViewWihtTitle:@"充值失败"
                                                                             AndMessage:@"网络出现问题了，请检查你的网络"
                                                                         AndButtonTitle:@"重新充值"
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
        
    } else if([rechargeTextField.text floatValue] < 1){
        
        NSLog(@"textField nothing");
        
        [self.view.window showHUDWithText:@"请输入大于1元的金额" Enabled:YES];
        
    }
}

#pragma mark - TableView data source

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

        return 1;
    }
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 40;
        
    } else {
        
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return 20;
        
    } else {
        
        return 35;
    } 
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 10;
        
    } else {
        
        return 0.1;
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
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"充值金额";
        
        if (!rechargeTextField) {
            
            rechargeTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 5, WIDTH-95, 30)];
            rechargeTextField.backgroundColor = [UIColor clearColor];
            rechargeTextField.placeholder = @"金额";
            rechargeTextField.delegate = self;
            rechargeTextField.font = [UIFont systemFontOfSize:15.0f];
            rechargeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            rechargeTextField.returnKeyType = UIReturnKeyGo;
            rechargeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        [cell addSubview:rechargeTextField];
        [cell addSubview:titleLabel];
        
    } else {
        
        NSArray *titleArray = @[@"钱包支付",@"支付宝支付",@"微信支付",@"银联支付"];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 60, 28)];
        iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pay_icon_%d",indexPath.row+1]];
        
        UILabel *payWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 140, 30)];
        payWayLabel.backgroundColor = [UIColor clearColor];
        payWayLabel.textAlignment = NSTextAlignmentLeft;
        payWayLabel.textColor = [UIColor grayColor];
        payWayLabel.font = [UIFont systemFontOfSize:15.0f];
        payWayLabel.text = [titleArray objectAtIndex:indexPath.row+1];
        
        UIButton *selcetButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-40, 12.5, 25, 25)];
        [selcetButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_disable"] forState:UIControlStateNormal];
        [selcetButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_enable"] forState:UIControlStateNormal];
        selcetButton.tag = indexPath.row;
        
        UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-45, 2.5, 40, 45)];
        selectImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pay_btn_%@_all",[[selectDic objectForKey:paySelectPayCount] objectAtIndex:indexPath.row]]];
        selectImageView.tag = indexPath.row;
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:payWayLabel];
        [cell.contentView addSubview:selectImageView];
    }
 
    return cell;
}

/**
 *  设置充值方式的标题
 *
 *  @param tableView rechargeTableView
 *  @param section   section-1
 *
 *  @return headerView
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 1) {
        
        UIView *headBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        headBg.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
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
    if (indexPath.section == 1) {
        
        paySelectPayCount = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        [rechargeTableView reloadData];
    }
}

#pragma mark - textField delegate

/**
 *  键盘收起监听
 */
- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:rechargeTextField];
}

/**
 *  键盘手势监听操作
 *
 *  @param gestureRecognizer 手势
 */
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    
    [self.view endEditing:YES];
}

- (void)textFieldChanged:(id)sender
{
    if ([rechargeTextField.text isEqualToString:@""]) {
        
        rechargeButton.backgroundColor = [UIColor lightGrayColor];
    }
    
}

/**
 *  充值数值格式限制
 *
 *  @param textField rechargeTextField
 *  @param range     range
 *  @param string    输入string
 *
 *  @return BOOL
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([rechargeTextField.text rangeOfString:@"."].location==NSNotFound) {
        
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        rechargeButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
        
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([rechargeTextField.text length]==0){
                if(single == '.'){
                    
                    [self.view.window showHUDWithText:@"亲，第一个数字不能为小数点" Enabled:YES];
                    [rechargeTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
                /*if (single == '0') {
                    
                    [self.view.window showHUDWithText:@"亲，第一个数字不能为0" Enabled:YES];
                    [rechargeTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }*/

            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self.view.window showHUDWithText:@"亲，您已经输入过小数点了" Enabled:YES];
                    [rechargeTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[rechargeTextField.text rangeOfString:@"."];
                    int tt=range.location-ran.location;
                    
                    if (tt <= 2){
                        
                        return YES;
                        
                    }else{

//                        [self.view.window showHUDWithText:@"亲，您最多输入两位小数" Enabled:YES];
                        
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
            
        }else{//输入的数据格式不正确
            
            [self.view.window showHUDWithText:@"亲，您输入的格式不正确" Enabled:YES];
            
            [rechargeTextField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
        }
    }
    else
    {
        return YES;
    
    }
    
}

/**
 *  键盘确定按钮操作
 *
 *  @param textField nil
 *
 *  @return 结果
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSelector:@selector(rechargeButtonClick:) withObject:nil];
    
    return YES;
}

- (void)viewDidLoad
{
    [self initRechargeView];
    
    [self initBottomView];
    
    [self setUpForDismissKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Alipay的方法

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

/**
 *  生成充值订单号(两位随机数+yyyyMMddHHmmss+loginName)
 */
- (NSString *)setRechargeOrderNumber
{
    NSString *randomStr = [NSString stringWithFormat:@"%d",(arc4random()%90)+10];
    
    NSDateFormatter *nsDate = [[NSDateFormatter alloc]init];
    
    [nsDate setDateFormat:@"yyyyMMddHHmmSS"];
    
    NSString *dateStr = [nsDate  stringFromDate:[NSDate date]];
    
    NSString *rechargeOrderNum = [NSString stringWithFormat:@"%@%@%@",randomStr,dateStr,[UserInfo shareUserInfo].userName];
    
    return rechargeOrderNum;
}

@end
