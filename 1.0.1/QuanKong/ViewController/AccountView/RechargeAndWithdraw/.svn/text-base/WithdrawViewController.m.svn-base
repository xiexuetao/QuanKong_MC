//
//  WithdrawViewController.m
//  QuanKong
//
//  Created by POWER on 1/4/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import "WithdrawViewController.h"

#import "AddUserBankController.h"
#import "UserBankInfoController.h"

@implementation WithdrawViewController
{
    BOOL bankSelect;
    BOOL isHaveDian;
    NSString *bankNoStr;
    NSArray *wellectTitleArray;
    NSMutableDictionary *bankDic;
}

@synthesize withdrawTableView;
@synthesize welletCount;
@synthesize withdrawTextField;
@synthesize withdrawButton;
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
        titleLabel.text = @"提现";
        
        self.navigationItem.titleView = titleLabel;
        
        wellectTitleArray = @[@"钱包余额",@"金　　额"];
        
        resultView = [[ResultView alloc]init];
        
        [LoadingHUDView showLoadinginView:self.view];

    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getWellectDetail];
    [self getUserBankInfo];
    [self initRealNameAuthentication];
}

- (void)initRealNameAuthentication
{
    if ([UserInfo shareUserInfo].isRealnameAuth == NULL) {
        
        UIButton *warnningBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        warnningBt.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:240.0/255.0 blue:167.0/255.0 alpha:1.0];
        [warnningBt addTarget:self action:@selector(realNameAuthentication:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *warnningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 30)];
        warnningLabel.backgroundColor = [UIColor clearColor];
        warnningLabel.textAlignment = NSTextAlignmentCenter;
        warnningLabel.font = [UIFont systemFontOfSize:13.0f];
        warnningLabel.textColor = [UIColor redColor];
        warnningLabel.text = @"你还没有进行实名认证，点击进行实名认证";
        
        withdrawTableView.frame = CGRectMake(0, 30, WIDTH, HEIGHT-64-30);
        
        [warnningBt addSubview:warnningLabel];
        [self.view insertSubview:warnningBt aboveSubview:withdrawTableView];
        
    } else {
        
        UILabel *warnningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 225, WIDTH-20, 50)];
        warnningLabel.backgroundColor = [UIColor clearColor];
        warnningLabel.textAlignment = NSTextAlignmentLeft;
        warnningLabel.numberOfLines = 0;
        warnningLabel.font = [UIFont systemFontOfSize:13.0f];
        warnningLabel.textColor = [UIColor colorWithRed:32.0/255.0 green:135.0/255.0 blue:238.0/255.0 alpha:1.0];
        warnningLabel.text = @"*可提现金额超过200元才能申请提现，提现后3个工作日进行处理，具体到账时间以银行到账为准，节假日顺延。";
        
        [withdrawTableView addSubview:warnningLabel];
    }
}

/**
 *  创建提现界面
 */
- (void)initWithdrawTableView
{
    if (!withdrawTableView) {
        
        withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        withdrawTableView.delegate = self;
        withdrawTableView.dataSource = self;
        withdrawTableView.backgroundColor = [UIColor clearColor];
        withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    [self.view addSubview:withdrawTableView];
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
    
    if (!withdrawButton) {
        
        withdrawButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH+30)/4, 10, (WIDTH-30)/2, 30)];
        withdrawButton.layer.cornerRadius = 2.0;
        withdrawButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [withdrawButton setTitle:@"提交申请" forState:UIControlStateNormal];
        
        [withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        withdrawButton.backgroundColor = [UIColor lightGrayColor];
    }

    [self.view insertSubview:bottomView aboveSubview:withdrawTableView];
    [bottomView addSubview:clearBackView];
    [bottomView addSubview:withdrawButton];
    
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
        
        return 2;
        
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
        
        return 70;
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
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39.75, WIDTH-10, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = [wellectTitleArray objectAtIndex:indexPath.row];
        
        UILabel *wellectLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, WIDTH-95, 30)];
        wellectLabel.backgroundColor = [UIColor clearColor];
        wellectLabel.textAlignment = NSTextAlignmentLeft;
        wellectLabel.font = [UIFont systemFontOfSize:16.0f];
        wellectLabel.textColor = [UIColor orangeColor];
        wellectLabel.text = [NSString stringWithFormat:@"%@",welletCount];
        
        if (!withdrawTextField) {
            
            withdrawTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 5, WIDTH-95, 30)];
            withdrawTextField.backgroundColor = [UIColor clearColor];
            withdrawTextField.textAlignment = NSTextAlignmentLeft;
            withdrawTextField.font = [UIFont systemFontOfSize:16.0f];
            withdrawTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            withdrawTextField.placeholder = @"提现金额";
            withdrawTextField.delegate = self;
        }
        
        [cell.contentView addSubview:titleLabel];
        indexPath.row == 0?[cell.contentView addSubview:lineView]:nil;
        indexPath.row == 0?[cell.contentView addSubview:wellectLabel]:nil;
        indexPath.row == 1?[cell.contentView addSubview:withdrawTextField]:nil;
        
    } else if (indexPath.section == 1) {
        
        if (bankSelect) {
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 130, 42)];
            
            [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[bankDic objectForKey:@"bankLogo"]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            iconView.contentMode = UIViewContentModeScaleAspectFill;
            iconView.clipsToBounds = YES;
            
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
            UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-45, 12.5, 40, 45)];
            selectView.image = [UIImage imageNamed:@"pay_btn_enable_all"];
            
            [cell.contentView addSubview:iconView];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:selectView];
            
        } else {
            
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            cell.textLabel.text = @"绑定银行卡";
        }
        
        /*UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 12)];
        arrowImageView.image = [UIImage imageNamed:@"arrow_gray"];
        cell.accessoryView = arrowImageView;*/
        
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
        headerLabel.text = [NSString stringWithFormat:@"选择银行卡"];
        
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
        
        if (indexPath.row == 0) {
            
            if (bankSelect) {
                
                /*UserBankInfoController *userBankInfoController = [[UserBankInfoController alloc]initWithStyle:UITableViewStyleGrouped];
                
                [userBankInfoController buildTableViewWith:bankDic];
                
                [self.navigationController pushViewController:userBankInfoController animated:YES];*/
                
            } else {
                
                    AddUserBankController *addUserBankController = [[AddUserBankController alloc]initWithStyle:UITableViewStyleGrouped];
                
                    [self.navigationController pushViewController:addUserBankController animated:YES];
                
            }
            
        }
    }
}

/**
 *  获取钱包信息
 */
- (void)getWellectDetail
{
    NSString *myWelletUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,GET_MY_WALLET,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:myWelletUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            NSDictionary *obj_Dic = [success objectForKey:@"obj"];
            
            //我的钱包数目
            welletCount = [NSString stringWithFormat:@"%.2f元",[[obj_Dic objectForKey:@"account"]floatValue]];
            
            [LoadingHUDView hideLoadingView];
            
            [withdrawTableView reloadData];
            
        } else {
            
            [LoadingHUDView hideLoadingView];
            
            welletCount = @"加载失败";
            
            [withdrawTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"fail");
        
        [LoadingHUDView hideLoadingView];
        
    }];

}

/**
 *  获取用户绑定卡信息
 */
- (void)getUserBankInfo
{
    NSString *userBankInfoStr = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,USER_BANK_INFO,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:userBankInfoStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            bankDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            bankDic = [success objectForKey:@"obj"];
            
            NSString *accountNo = [bankDic objectForKey:@"accountNo"];
            NSRange rang = NSMakeRange(accountNo.length-4, 4);
            bankNoStr = [accountNo substringWithRange:rang];
            
            bankDic==NULL?(bankSelect=NO):(bankSelect=YES);
            
            [withdrawTableView reloadData];
            
        } else {
            
            bankNoStr = @"加载失败";
            
            [withdrawTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
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
    
    [nc addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:withdrawTextField];
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
    if ([withdrawTextField.text isEqualToString:@""]) {
        
        withdrawButton.backgroundColor = [UIColor lightGrayColor];
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
    if ([withdrawTextField.text rangeOfString:@"."].location==NSNotFound) {
        
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        [withdrawButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0]];
        
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([withdrawTextField.text length]==0){
                if(single == '.'){
                    
                    [self.view.window showHUDWithText:@"亲，第一个数字不能为小数点" Enabled:YES];
                    [withdrawTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    
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
                    
                }else {
                    
                    [self.view.window showHUDWithText:@"亲，您已经输入过小数点了" Enabled:YES];
                    [withdrawTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[withdrawTextField.text rangeOfString:@"."];
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
            
            [withdrawTextField.text stringByReplacingCharactersInRange:range withString:@""];
            
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
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    [self initWithdrawTableView];
    
    [self initBottomView];
    
    [self setUpForDismissKeyboard];
    
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)withdrawButtonClick:(UIButton *)sender
{
    if (![withdrawTextField.text isEqualToString:@""] && bankSelect == YES && [welletCount floatValue] > [withdrawTextField.text floatValue] && [withdrawTextField.text floatValue] >= 200) {
        
        NSString *withdrawUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&amount=%.2f&bankId=%@&appKey=%@",NEW_HEAD_LINK,WITHDARW,[UserInfo shareUserInfo].userName,[withdrawTextField.text doubleValue],[bankDic objectForKey:@"bankDefId"],APP_KEY];
        
        [HTTPTool getWithPath:withdrawUrlStr success:^(id success) {
            
            NSString *msg = [success objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"success"]) {
                
                [resultView showResultViewWihtTitle:@"提现申请成功" AndMessage:@"已提交申请，我们会在3个工作日内进行处理，请留意站内信" AndButtonTitle:@"返回" AndDelegate:self ByResult:YES InView:self.view.window];
                
            } else {
                
                [resultView showResultViewWihtTitle:@"提现申请失败" AndMessage:@"请确认的信息及网络正确" AndButtonTitle:@"重新提现" AndDelegate:self ByResult:NO InView:self.view.window];
            }
            
        } fail:^(NSError *error) {
            
            NSLog(@"netWork Fail");
        }];
        
    } else if(bankSelect == NO){
        
        [self.view.window showHUDWithText:@"请选择你的银行卡" Enabled:YES];
        
    } else if([welletCount floatValue] < [withdrawTextField.text floatValue]) {
            
        [self.view.window showHUDWithText:@"你的钱包余额不足" Enabled:YES];

    } else if([withdrawTextField.text floatValue] < 200) {
        
        [self.view.window showHUDWithText:@"最低提现金额为200元" Enabled:YES];
        
    }else {
        
        [self.view.window showHUDWithText:@"请输入提现金额" Enabled:YES];
    }
}

/**
 *  进行实名认证
 *
 *  @param sender nil
 */
- (void)realNameAuthentication:(UIButton *)sender
{
    NSLog(@"setMyRealName");
}

#pragma mark - resultView

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
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

@end
