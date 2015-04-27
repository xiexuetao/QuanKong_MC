//
//  QuanKongSpecifyTransactionViewController.m
//  QuanKong
//
//  Created by Rick on 15/1/22.
//  Copyright (c) 2015年 Rockcent. All rights reserved.
//

#import "QuanKongSpecifyTransactionViewController.h"
#import "QuanKongWebViewController.h"
#import "NSString+DisposeStr.h"

@interface QuanKongSpecifyTransactionViewController (){
    UITableView *_mTableView;
    UIImageView  *_hedaer;
    
    UILabel *_priceLabel;
    UILabel *_costLable;
    UILabel *_buyLabel;
    
    UITextField *_toUsernameTextField;
    UITextField *_countTextField;
    UITextField *_priceTextField;
    
    BOOL registerTag;
}
@end

@implementation QuanKongSpecifyTransactionViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"指定交易";
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self createHeaderView];
        [self createTable];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    registerTag = YES;
    
}

-(void)createHeaderView{
    _hedaer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    _hedaer.backgroundColor = [UIColor grayColor];
    _hedaer.image = [UIImage imageNamed:@"pick_bg"];
}

/**
 *  创建
 */
-(void)createTable{
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.tableHeaderView = _hedaer;
    _mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0000000001;
    }
    return 0.25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.25;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 2:{
            return 130;
        }
            break;
        case 3:{
            return 150;
        }
            break;
            
        default:{
            return 30.f;
        }
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asd"];
    cell.selectionStyle = NO;
    
    
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxx券";
            cell.textLabel.font = [UIFont systemFontOfSize:14.f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
            break;
        case 1:{
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"售价：¥ 1000     原价：¥ 6000"];
            
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attrStr.length)];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(0, attrStr.length)];
            
           NSInteger i = @"¥ 1000".length;
            
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, i)];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.f] range:NSMakeRange(3, i)];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(3+i+8, attrStr.length - (3+i+8))];
            
            [attrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:NSMakeRange(3+i+8, attrStr.length - (3+i+8))];
            cell.textLabel.attributedText = attrStr;
        }
            break;
        case 2:{
            
            [cell addSubview:
                [self createLable:CGRectMake(10, 10, 60, 30) andStr:@"接收人："]
             ];
            
            _toUsernameTextField = (UITextField *)[self createTextField:CGRectMake(70, 10, (WIDTH-100), 30) andStr:@" 请输入接收人账号"];
            [cell addSubview:_toUsernameTextField];
            
            [cell addSubview:
             [self createLable:CGRectMake(10, 50, 60, 30) andStr:@"数量："]];
            _countTextField = (UITextField *)[self createTextField:CGRectMake(70, 50, (WIDTH-100)/2, 30) andStr:@" 请输入数量"];
            [cell addSubview:_countTextField];
            
            [cell addSubview:
             [self createLable:CGRectMake(10, 90, 60, 30) andStr:@"价格："]];
            _priceTextField = (UITextField *)[self createTextField:CGRectMake(70, 90, (WIDTH-100)/2, 30) andStr:@" 请输入价格"];
            [cell addSubview:_priceTextField];
        }
            break;
            
        default:{
            
            //初始化label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,5,WIDTH-20,30)];
            //设置自动行数与字符换行
            [label setNumberOfLines:0];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            // 测试字串
            NSString *s = @"说明：指定交易的有效期为三天，三天后未处理将自动取消交易，请及时联系您的接收人确认交易.";
            UIFont *font = [UIFont fontWithName:@"Arial" size:12];
            label.text = s;
            label.font = [UIFont systemFontOfSize:12.f];
            label.numberOfLines = 2;
            label.textColor = [UIColor lightGrayColor];
            [cell addSubview:label];
            
            UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 20, 20)];
            [but setBackgroundImage:[UIImage imageNamed:@"register_btn_on"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(clickregisterTag:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *protocol = [[UIButton alloc]initWithFrame:CGRectMake(35, 45, 250, 30)];
            [protocol setTitle:@"我已阅读并同意《会员魔方交易协议》" forState:UIControlStateNormal];
            [protocol setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            protocol.titleLabel.font = [UIFont systemFontOfSize:13.f];
            protocol.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [protocol addTarget:self action:@selector(clickProtocol:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(10, 90, WIDTH-20, 35)];
            [confirm setTitle:@"确定" forState:UIControlStateNormal];
            [confirm setBackgroundColor:[UIColor orangeColor]];
//            confirm.layer.b
            [confirm.layer setCornerRadius:5.f]; //设置矩形四个圆角半径
//            [confirm.layer setBorderWidth:1.0]; //边框宽度]
            [cell addSubview:confirm];
            [cell addSubview:but];
            [cell addSubview:protocol];
        }
            break;
    }
    
    return cell;
}


-(void)clickProtocol:(UIButton *)but{
    QuanKongWebViewController *webVC = [[[QuanKongWebViewController alloc] init]initWebViewWithRequestUrl:PROTOCOL_WEB_URL];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"券控用户协议";
    
    webVC.navigationItem.titleView = titleLabel;
    
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 *
 *
 *  @param but
 */
-(void)clickregisterTag:(UIButton *) but{
    if (registerTag == YES) {
        registerTag = NO;
        [but setBackgroundImage:[UIImage imageNamed:@"register_btn_off"] forState:UIControlStateNormal];
    }else{
        registerTag = YES;
        [but setBackgroundImage:[UIImage imageNamed:@"register_btn_on"] forState:UIControlStateNormal];
    }
}

-(UIView *)createTextField:(CGRect)frame andStr:(NSString *)str{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
//    textField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    textField.layer.borderWidth = 0.3;
    textField.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    textField.placeholder = str;
    textField.font = [UIFont systemFontOfSize:14.f];
    return textField;
}


-(UIView *)createLable:(CGRect) frame andStr:(NSString *) str{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

#pragma mark 查找键盘第一响应者
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
