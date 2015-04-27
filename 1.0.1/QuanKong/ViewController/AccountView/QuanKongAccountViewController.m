//

//  QuanKongAccountViewControllerTableViewController2.m

//  QuanKong

//

//  Created by Rick on 14/10/19.

//  Copyright (c) 2014年 Rockcent. All rights reserved.

//

#import "QuanKongAccountViewController.h"

#import "UserInfo.h"
#import "HTTPTool.h"
#import "UIImageView+WebCache.h"

#import "QuanKongAppDelegate.h"
#import "QuanKongAccountItem.h"

#import "CuponPackageViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "QuanKongOrderViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "AuthoriseRealNameController.h"
#import "AddUserBankController.h"


typedef NS_ENUM(NSInteger, category){
    MyCollection,//我的收藏
    MyVoucherPackage,//我的券包
    MyTrading//我的交易
};

typedef NS_ENUM(NSInteger, state){
    DonotUse,
    Overdue,
    HasBeenUsed
};


@interface QuanKongAccountViewController (){
    
    NSMutableArray *_data;//数据源
    
    int _selectSection;
    
    UILabel *_label;
    
    UILabel *_username;
    
    UITableView *_tableView;
    
    UIButton *_login;
    
    UILabel *_wc;
    
    UIImageView *_headerImage;
    
    UserInfo *userInfo;
    
    BOOL bankSelect;
    
}

@end



@implementation QuanKongAccountViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectSection = 1;
    
    [self createrTableView];
    
    [self createrHeader];
    
    [self initTableViewData];
    
}

/**
 
 *  创建tableview
 
 */

-(void)createrTableView{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    
    
    _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
}



/**
 
 *  初始化显示数据
 
 */

-(void)initTableViewData{
    
    _data = [NSMutableArray array];
    
    
    
    //第0组数据
    
    NSMutableArray *voucherPackage = [NSMutableArray array];
    
    QuanKongAccountItem *donotuse = [[QuanKongAccountItem alloc] init];
    
    donotuse.headerTitle = @"我的券包";
    
    donotuse.imageName = @"donotuser_icon";
    
    donotuse.title =  [[NSMutableAttributedString alloc] initWithString:@"未使用的券"];
    
    
    donotuse.operation = ^{
        
        [self pushCuponPackageViewController:DonotUse category:MyVoucherPackage];
        
    };
    
    [voucherPackage addObject:donotuse];
    
    
    
    QuanKongAccountItem *hasBeenUsed = [[QuanKongAccountItem alloc] init];
    
    hasBeenUsed.imageName = @"used_icon";
    
    hasBeenUsed.title = [[NSMutableAttributedString alloc] initWithString:@"已使用的券"];
    
    hasBeenUsed.operation = ^{
        
        [self pushCuponPackageViewController:HasBeenUsed category:MyVoucherPackage];
        
    };
    
    [voucherPackage addObject:hasBeenUsed];
    
    
    
    [_data addObject:voucherPackage];
    
    
    
    //第1组数据
    
    NSMutableArray *trading = [NSMutableArray array];
    
    
    
    QuanKongAccountItem *noPayment = [[QuanKongAccountItem alloc] init];
    
    noPayment.headerTitle = @"我的交易";
    
    noPayment.imageName = @"transaction_icon";
    
    noPayment.title = [[NSMutableAttributedString alloc] initWithString:@"待付款"];
    
    noPayment.operation = ^{
        
        [self pushCuponPackageViewController:DonotUse category:MyTrading];
        
    };
    
    [trading addObject:noPayment];
    
    
    
    QuanKongAccountItem *successfully = [[QuanKongAccountItem alloc] init];
    
    successfully.imageName = @"transaction_icon";
    
    successfully.title = [[NSMutableAttributedString alloc] initWithString:@"已成功"];
    
    successfully.operation = ^{
        
        [self pushCuponPackageViewController:HasBeenUsed category:MyTrading];
        
    };
    
    [trading addObject:successfully];
    
    
    
    [_data addObject:trading];
    
    
    
    //第2组数据
    
    /*
     
     NSMutableArray *activity = [NSMutableArray array];
     
     QuanKongAccountItem *item = [[QuanKongAccountItem alloc] init];
     
     item.headerTitle = @"我的活动";
     
     item.imageName = @"";
     
     item.accImageName = @"";
     
     item.title = @"开发中···";
     
     [activity addObject:item];
     
     
     
     [_data addObject:activity];
     
     */
    
    //第3组数据
    
    NSMutableArray *collection = [NSMutableArray array];
    
    QuanKongAccountItem *cash = [[QuanKongAccountItem alloc] init];
    
    cash.headerTitle = @"我的收藏";
    
    cash.imageName = @"donotuser_icon";
    
    cash.accImageName = @"";
    
    cash.title = [[NSMutableAttributedString alloc] initWithString:@"收藏"];
    [cash.title addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, cash.title.length)];
    cash.operation = ^{
        
        [self pushCuponPackageViewController:3 category:MyCollection];
        
    };
    
    [collection addObject:cash];
    
    /*
    QuanKongAccountItem *preferential = [[QuanKongAccountItem alloc] init];
    
    preferential.imageName = @"donotuser_icon";
    
    preferential.accImageName = @"";
    
    preferential.title = [[NSMutableAttributedString alloc] initWithString:@"优惠券"];
    
    preferential.operation = ^{
        
        [self pushCuponPackageViewController:3 category:0];
        
    };
    
    [collection addObject:preferential];
    
    QuanKongAccountItem *all = [[QuanKongAccountItem alloc] init];
    
    all.imageName = @"donotuser_icon";
    
    all.accImageName = @"";
    
    all.title = [[NSMutableAttributedString alloc] initWithString:@"全部券"];
    
    all.operation = ^{
        
        [self pushCuponPackageViewController:3 category:0];
        
    };
    
    [collection addObject:all];
     */
    
    [_data addObject:collection];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAsyn) name:@"userinfoneedrefresh" object:nil];
}





/**
 
 *  创建视图头部
 
 */

-(void)createrHeader{
    
    //头部view
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_background"]];
    
    backImage.tag = 100;
    
    backImage.userInteractionEnabled = YES;
    
    backImage.frame = CGRectMake(0, 0, WIDTH, 200);
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    [backImage addGestureRecognizer:singleRecognizer];
    
    backImage.frame = CGRectMake(0, 0, WIDTH, 190);
    
    [view addSubview:backImage];
    
    
    
    _headerImage = [[UIImageView alloc] init];
    
    _headerImage.bounds = CGRectMake(0,0, 60, 60);
    
    _headerImage.center = CGPointMake(45, (190-50)/2);
    
    _headerImage.layer.masksToBounds = YES;
    
    _headerImage.layer.cornerRadius = _headerImage.frame.size.height / 2;
    
    [view addSubview:_headerImage];
    
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(85, (190-50)/2-5, 250, 30)];
    
    _label.text = @"";
    
    _label.textColor = [UIColor whiteColor];
    
    _label.textAlignment = NSTextAlignmentLeft;
    
    _label.font = [UIFont systemFontOfSize:15.f];
    
    [view addSubview:_label];
    
    
    
    _username = [[UILabel alloc] initWithFrame:CGRectMake(85, (190-50)/2-25, 200, 30)];
    
    _username.text = @"";
    
    _username.textColor = [UIColor whiteColor];
    
    _username.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:_username];
    
    
    _wc = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-75, 50, 160, 30)];
    
    _wc.textAlignment = NSTextAlignmentCenter;
    
    _wc.text = @"欢迎来到会员魔方！";
    
    _wc.textColor = [UIColor whiteColor];
    
    _wc.textAlignment = NSTextAlignmentCenter;
    
    _wc.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:_wc];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0,190-50 , WIDTH, 50)];
    
    view2.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton *topUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    topUp.frame = CGRectMake(0, 0, WIDTH/2-10, 50);
    
    [topUp setTitle:@"充值" forState:UIControlStateNormal];
    
    [topUp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [topUp setBackgroundImage:[UIImage imageNamed:@"recharge_icon"] forState:UIControlStateNormal];
    
    [topUp setTitleEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    
    topUp.tag = 90;
    
//    [view2 addSubview:topUp];
    
    
    
    UIImageView *lien = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    
    lien.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    
    [view2 addSubview:lien];
    
    
    
    UIImageView *lien2 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2, 15, 0.5, 20)];
    
    lien2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    
    [view2 addSubview:lien2];
    
    
    
    UIImageView *lien3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-5, WIDTH, 0.5)];
    
    lien3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    
    [view2 addSubview:lien3];
    
    
    
    UIButton *withdrawal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    withdrawal.frame = CGRectMake(WIDTH/2+10, 0, WIDTH/2-10, 50);
    
    [withdrawal setTitle:@"提现" forState:UIControlStateNormal];
    
    [withdrawal setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [withdrawal setBackgroundImage:[UIImage imageNamed:@"withdraw_icon"] forState:UIControlStateNormal];
    
    [withdrawal setTitleEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    
    withdrawal.tag = 91;
    
//    [view2 addSubview:withdrawal];
    
    [view addSubview:view2];
    
    
    
    
    
    _login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [_login setTitle:@"登录/注册" forState:UIControlStateNormal];
    
    _login.bounds = CGRectMake(0, 0, 120, 40);
    
    _login.center = CGPointMake(WIDTH/2, 190/2);
    
    _login.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_login addTarget:self action:@selector(profilePressed) forControlEvents:UIControlEventTouchUpInside];
    
    _login.layer.cornerRadius = 5.f;
    
    [view addSubview:_login];
    
    //第一行箭头
    [withdrawal addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    [topUp addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *acc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    
    acc.frame = CGRectMake(WIDTH-20, (190-50)/2+6, 10, 12);
    
    [view addSubview:acc];
    
    _tableView.tableHeaderView = view;
    
}



-(void)clickImage{
    
    if ([UserInfo shareUserInfo].isLogined) {
        
        SettingViewController * settingViewControllerTmp=[[SettingViewController alloc]init];
        
        settingViewControllerTmp.hidesBottomBarWhenPushed=YES;
        
        [[self navigationController] pushViewController:settingViewControllerTmp animated:YES];
        
    }else{
        
        [self profilePressed];
        
    }
    
}







#pragma mark tableCell的button点击

-(void)clickBut:(UIButton *)but{
    
    switch (but.tag) {
            
        case 90://充值
            
        {
            
            if ([UserInfo shareUserInfo].isLogined==NO) {
                
                LoginViewController *loginViewControlltmp=[[LoginViewController alloc]init];
                
                loginViewControlltmp.hidesBottomBarWhenPushed = YES;
                
                [[self navigationController] pushViewController:loginViewControlltmp animated:YES];
                
            } else {
                
                RechargeViewController *rechangeViewController = [[RechargeViewController alloc]init];
                
                rechangeViewController.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:rechangeViewController animated:YES];
                
            }
            
        }
            
            break;
            
        case 91://提现
            
        {
            
            if ([UserInfo shareUserInfo].isLogined == NO) {
                
                LoginViewController *loginViewControlltmp=[[LoginViewController alloc]init];
                
                loginViewControlltmp.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:loginViewControlltmp animated:YES];
                
            } else {
                
                if ([UserInfo shareUserInfo].isRealnameAuth == NULL) {
                    
                    AuthoriseRealNameController *realNameController = [[AuthoriseRealNameController alloc]initWithStyle:UITableViewStyleGrouped];
                    
                    realNameController.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:realNameController animated:YES];
                    
                } else {
                    
                    if([UserInfo shareUserInfo].bankSelect)
                    {
                        WithdrawViewController *withdrawViewController = [[WithdrawViewController alloc]init];
                        
                        withdrawViewController.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:withdrawViewController animated:YES];
                        
                    } else {
                        
                        AddUserBankController *addUserBankController = [[AddUserBankController alloc]init];
                        
                        addUserBankController.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:addUserBankController animated:YES];
                    }
                    
                }
                
            }
            
        }
            
            break;
            
        case 92://资金管理
            
        {
            
            /*
             
             CapitalManagerViewController * tmp =[[CapitalManagerViewController alloc]init];
             
             tmp.hidesBottomBarWhenPushed=YES;
             
             [self.navigationController pushViewController:tmp animated:YES];
             
             */
            
            [self.view.window showHUDWithText:@"开发中敬请关注···" Enabled:YES];
            
        }
            
            break;
            
        case 100:
            
        {
            
            SettingViewController * settingViewControllerTmp=[[SettingViewController alloc]init];
            
            settingViewControllerTmp.hidesBottomBarWhenPushed=YES;
            
            [[self navigationController] pushViewController:settingViewControllerTmp animated:YES];
            
        }
            
        default:
            
            break;
            
    };
    
}



-(void)createSettingButton{
    
    //加入设置按钮
    
    UIButton * settBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [settBtn setTitle:@"设置" forState:UIControlStateNormal];
    
    settBtn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
    
    settBtn.tag = 100;
    
    [settBtn addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:settBtn];
    
    self.navigationItem.rightBarButtonItem = item;
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
}



//始终隐藏导航栏

- (void)viewWillAppear:(BOOL)animated {
    
    if ([UserInfo shareUserInfo].isLogined) {
        
        [self setUserInfo:self];
        
        [self getUserBankInfo];
        
        _login.hidden = YES;
        
        _wc.hidden = YES;
        
        _headerImage.hidden = NO;
        
    }else{
        
        _login.hidden = NO;
        
        _wc.hidden = NO;
        
        _headerImage.hidden = YES;
        
        _label.text = @"";
        
        _username.text = @"";
        
        //        QuanKongAccountItem *transaction = (QuanKongAccountItem *)_data[0][0];
        
        //        transaction.title = @"交易中";
        
        QuanKongAccountItem *donotuse = (QuanKongAccountItem *)_data[0][0];
        
        donotuse.title = [[NSMutableAttributedString alloc] initWithString:@"未使用的券"];
        
        QuanKongAccountItem *hasBeenUsed = (QuanKongAccountItem *)_data[0][1];
        
        hasBeenUsed.title = [[NSMutableAttributedString alloc] initWithString:@"已使用的券"];
        
        QuanKongAccountItem *item = _data[1][0];
        item.title = [[NSMutableAttributedString alloc] initWithString:@"待付款"];
        
        QuanKongAccountItem *item2 = _data[1][1];
        item2.title = [[NSMutableAttributedString alloc] initWithString:@"已成功"];
        
        [_tableView reloadData];
        
    }
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    
    [super viewWillDisappear:animated];
    
    
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}



-(void)headerButtonClick:(UIButton *)but{
    
    _selectSection = but.tag;
    
    [_tableView reloadData];
    
    
    
}

/**
 
 *  设置界面的用户信息,由LoginViewControll发送通知userinfoneedrefresh，调用这个方法
 
 *  @param sender
 
 */

-(void)setUserInfo:(id)sender
{
    userInfo = [UserInfo shareUserInfo];
    [[UserInfo shareUserInfo] getUserInfoUsername:userInfo.userName Token:userInfo.token];
    
}



/**
 
 *我的券包跳转
 
 **/
-(void)pushCuponPackageViewController:(int)type category:(NSInteger) category{
    
    if ([UserInfo shareUserInfo].isLogined) {
        
        if(category == 2){
            QuanKongOrderViewController *order = [[QuanKongOrderViewController alloc] initWithCouponType:type];
            order.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:order animated:YES];
        }else{
            CuponPackageViewController * tmp = [[CuponPackageViewController alloc] initWithCouponType:type];
            tmp.category = category;
            tmp.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:tmp animated:YES];
        }
    }else{
        
        [self profilePressed];
        
    }
    
}





#pragma mark - Table view data source



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame = CGRectMake(0, 10, WIDTH, 25);
    
    QuanKongAccountItem *item = _data[section][0];
    
    [but setTitle:item.headerTitle forState:UIControlStateNormal];
    
    but.backgroundColor = [UIColor whiteColor];
    
    but.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, WIDTH-100);
    
    but.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    but.tag = section+1;
    
    [but addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_selectSection-1 == section) {
        
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
    }else{
        
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    
    but.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 30)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.cornerRadius = 10;
    
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    
    view.layer.shadowOffset = CGSizeMake(-0, -5);
    
    view.layer.shadowOpacity = 0.2f;
    
    [view addSubview:but];
    
    return view;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001f;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50.f;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _data.count;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_selectSection-1 == section) {
        
        NSMutableArray *arr = _data[section];
        
        return arr.count;
        
    }
    
    return 0;
    
}



#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //0.用static修饰局部变量，只会初始化一次
    
    static NSString *ID = @"Cell";
    
    
    
    //1.拿到一个标识先去缓冲池中查找对应的cell
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    
    //2.如果缓冲池中没有，才需要传入一个标识创新的cell
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];

    }
    
    
    
    //3.覆盖数据
    
    QuanKongAccountItem *item = _data[indexPath.section][indexPath.row];
    
    
    [item.title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, item.title.length)];
    cell.textLabel.attributedText = item.title;
    
    cell.imageView.image = [UIImage imageNamed:item.imageName];
    
    UIImageView * arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    
    arrow.frame=CGRectMake(0, 0, 8, 12);
    
    cell.accessoryView = arrow;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



#pragma maek - 代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuanKongAccountItem *item = _data[indexPath.section][indexPath.row];
    
    if (item.operation) {
        
        item.operation();
        
    }
    
}

#pragma mark - 网络请求

-(void)sendAsyn{
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:userInfo.headimgurl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]completed:nil];
    
    NSString *customerWallet = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,CUSTOMER_WALLET_METHOD,userInfo.userName,APP_KEY];
    
    [HTTPTool getWithPath:customerWallet success:^(id success) {
        NSString *event = [success objectForKey:@"event"];
        if ([event isEqualToString:@"0"]) {
            NSDictionary *obj = [success objectForKey:@"obj"];
            NSNumber *acc = [obj objectForKey:@"account"];
            userInfo.account = acc;
            
            NSString *account = [NSString stringWithFormat:@"可用券 %@张   余额 %0.2f元",userInfo.donotUse,[userInfo.account doubleValue]];
            _label.text = account;
        }else{
//            [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"网络错误" Enabled:YES];
    }];
    
    NSString *str = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@&keyword=",NEW_HEAD_LINK,CUSTOMER_TOOTAL_METHOD,userInfo.userName,APP_KEY];
    if (userInfo.isLogined) {
        [HTTPTool getWithPath:str success:^(id success) {
            NSString * i=[success objectForKey:@"event"];
            if ([i isEqualToString:@"0"]) {
                NSDictionary *obj = [success objectForKey:@"obj"];
                NSDictionary *unused = [obj objectForKey:@"unused"];
                NSNumber *unusedCount = [unused objectForKey:@"count"];
                QuanKongAccountItem *donotuse = (QuanKongAccountItem *)_data[0][0];
                //                donotuse.title = [NSString stringWithFormat:@"未使用的券(%@)",unusedCount];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未使用的券(%@)",unusedCount]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, str.length)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6, str.length-7)];
                
                donotuse.title = str;
                userInfo.donotUse = unusedCount;
                
                NSDictionary *used = [obj objectForKey:@"used"];
                NSDictionary *usedCount = [used objectForKey:@"count"];
                QuanKongAccountItem *hasBeenUsed = (QuanKongAccountItem *)_data[0][1];
                
                NSMutableAttributedString *uc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已使用的券(%@)",usedCount]];
                [uc addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, uc.length)];
                [uc addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6, uc.length-7)];
                hasBeenUsed.title = uc;
                
            }
            [_tableView reloadData];
        
            //刷新头部数据
            if (userInfo.nickname && ![userInfo.nickname isEqualToString:@"匿名"]) {
                [_username setText:userInfo.nickname];
            }else{
                [_username setText:userInfo.userName];
            }
            
            
            NSString *account = [NSString stringWithFormat:@"可用券 %@张   余额 %0.2f元",userInfo.donotUse,[userInfo.account doubleValue]];
            
            _label.text = account;
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络错误" Enabled:YES];
        }];
        
        
        
        //我的交易
        NSString *str = [NSString stringWithFormat:@"%@%@&loginName=%@&state=%d&currentPage=%d&appKey=%@&keyWords=%@&pageSize=20",NEW_HEAD_LINK,ORDER_LIST_METHOD,userInfo.userName,0,0,APP_KEY,@""];
        
        [HTTPTool getWithPath:str success:^(id success) {
            NSString * i=[success objectForKey:@"event"];
            if ([i isEqualToString:@"0"]) {
                QuanKongAccountItem *item = _data[1][0];
                
                NSMutableAttributedString *mc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"待付款(%@)",[success objectForKey:@"maxCount"]]];
                [mc addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, mc.length)];
                [mc addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, mc.length-5)];
                item.title = mc;
                
                [_tableView reloadData];
            }else{
//                [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络错误" Enabled:YES];
            
        }];
        
        NSString *str1 = [NSString stringWithFormat:@"%@%@&loginName=%@&state=%d&appKey=%@&keyWords=%@&pageSize=20&currentPage=1",NEW_HEAD_LINK,ORDER_LIST_METHOD,userInfo.userName,2,APP_KEY,@""];
        
        [HTTPTool getWithPath:str1 success:^(id success) {
            NSString * i=[success objectForKey:@"event"];
            if ([i isEqualToString:@"0"]) {
                QuanKongAccountItem *item = _data[1][1];
                
                NSMutableAttributedString *mc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已成功(%@)",[success objectForKey:@"maxCount"]]];
                [mc addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, mc.length)];
                [mc addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, mc.length-5)];
                item.title = mc;
                
                [_tableView reloadData];
            }else{
//                [self.view.window showHUDWithText:[success objectForKey:@"message"] Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络错误" Enabled:YES];
        }];
    }

}


/**
 
 *  头像点击处理
 
 */

-(void)profilePressed
{
    
    if ([UserInfo shareUserInfo].isLogined==NO) {
        
        LoginViewController *loginViewControlltmp=[[LoginViewController alloc]init];
        
        loginViewControlltmp.hidesBottomBarWhenPushed = YES;
        
        [[self navigationController] pushViewController:loginViewControlltmp animated:YES];
        
    }
    
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
            
            NSMutableDictionary *bankDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            bankDic = [success objectForKey:@"obj"];
            
            bankDic==NULL?(bankSelect=NO):(bankSelect=YES);
            
            [userInfo setBankSelect:bankSelect];
            
        } else {
            
            NSLog(@"NO");
            bankSelect=NO;
            
            [userInfo setBankSelect:bankSelect];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
}


@end

