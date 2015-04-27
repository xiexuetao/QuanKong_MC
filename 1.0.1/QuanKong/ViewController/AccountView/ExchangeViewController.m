//
//  ExchangeViewController.m
//  Created by rockcent on 14-8-27.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "ExchangeViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "HTTPTool.h"
#import "exchangeHeader.h"
#import "MBProgressHUD+Add.h"
#import "QuanKongVoucher.h"
#import "CountSelector.h"
#import "UIWindow+AlertHud.h"

@interface ExchangeViewController ()
{
    UILabel * couponCodeLB;
    
    UIImageView * _QRPicImageView;
    
    UILabel *_code;
    
    ExchangeHeader *_exchangeHeader;
    
    NSString *_count;
    
    int exchangeCount;
    
    BOOL _exchangTag;
}

@end

@implementation ExchangeViewController
@synthesize couponview;
@synthesize couponId;
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
        self.navigationItem.title = @"兑换";
        
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

- (void)viewDidLoad
{
    _count = [NSString stringWithFormat:@"%i",self.voucher.count];
    [super viewDidLoad];
    [self initMyView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _exchangTag = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark-加入视图


-(void)initMyView{
    
    _exchangeHeader = (ExchangeHeader *)[[[NSBundle mainBundle] loadNibNamed:@"ExchangeHeader" owner:nil options:nil] lastObject];
    
    _exchangeHeader.but_WS.hidden = YES;
    _exchangeHeader.but_SH.hidden = YES;
    
    CGRect cFrame = _exchangeHeader.countTF.frame;
    cFrame.origin.x = cFrame.origin.x - 15;
    cFrame.size.height = cFrame.size.height - 10;
    
    CountSelector *count = [[CountSelector alloc] initWithFrame:cFrame];

    [count initViewWithCount:self.voucher.count And:self.voucher.count AndTag:0];
    count.delegate = self;
    [_exchangeHeader addSubview:count];
    _exchangeHeader.countTF.hidden=YES;
    
    UIView *offline = [[UIView alloc] initWithFrame:CGRectMake(0,100, WIDTH, HEIGHT-110)];
    offline.backgroundColor = [UIColor whiteColor];
    
    _QRPicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/4, 5, WIDTH/2, WIDTH/2+(WIDTH/3/7))];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/4, WIDTH/3+(WIDTH/3/7)+40, 70, 20)];
    lab.text = @"兑换码:";
    
    _code = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/4+57, WIDTH/3+(WIDTH/3/7)+40, 150, 20)];
    _code.textColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5f];
    
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10,WIDTH/3+(WIDTH/3/7)+80, WIDTH, 20)];
    instructions.text = @"说明:";
    instructions.font = [UIFont systemFontOfSize:13.f];
    instructions.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    UILabel *la1 = [[UILabel alloc] initWithFrame:CGRectMake(10,WIDTH/3+(WIDTH/3/7)+100, WIDTH, 20)];
    la1.font = [UIFont systemFontOfSize:13.f];
    la1.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    la1.text = @"1.二维码和兑换码已包含所兑换数量的券;";
    UILabel *la2 = [[UILabel alloc] initWithFrame:CGRectMake(10,WIDTH/3+(WIDTH/3/7)+120, WIDTH, 20)];
    la2.font = [UIFont systemFontOfSize:13.f];
    la2.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    la2.text = @"2.出示该二维码或兑换码给商家即可以享受优惠;";
    UILabel *la3 = [[UILabel alloc] initWithFrame:CGRectMake(10,WIDTH/3+(WIDTH/3/7)+140, WIDTH-10, 40)];
    la3.font = [UIFont systemFontOfSize:13.f];
    la3.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    la3.lineBreakMode = NSLineBreakByWordWrapping;
    la3.numberOfLines = 0;
    NSString *str =  @"3.兑换码和二维码20分钟内有效,20分钟后需要重新进行兑换.";
    la3.text = str;
    CGSize labelsize = [str sizeWithFont:la3.font constrainedToSize:la3.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    la3.frame = CGRectMake(10, WIDTH/3+(WIDTH/3/7)+140, labelsize.width, labelsize.height);
    
    _exchangeHeader.titleLab.text = self.voucher.name;
    _exchangeHeader.countTF.text = [NSString stringWithFormat:@"%i",self.voucher.count];
    _exchangeHeader.countTF.keyboardType = UIKeyboardTypeNumberPad;
    
    int i = self.voucher.faceValue.integerValue;//原价
    int x = self.voucher.estimateAmount.integerValue;//折扣价
    int y = i - x;//立赚价格
    _exchangeHeader.describe.text = [NSString stringWithFormat:@"¥ %i ¥ %i",x,i];
    _exchangeHeader.saveMoney.text = [NSString stringWithFormat:@"¥ %i",y];
    
    [_exchangeHeader.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[self.voucher.picUrl componentsSeparatedByString:@";"][0]]]];
    
    _exchangeHeader.Date.text = [self DataConversion:[NSString stringWithFormat:@"%@",self.voucher.useEndTime]];
    
    _exchangeHeader.exchange.layer.cornerRadius = 5.f;
    [_exchangeHeader.exchange addTarget:self action:@selector(getQRInfo) forControlEvents:UIControlEventTouchDown];
    
    
    switch (self.voucher.type) {
        case 0:
        {
            _exchangeHeader.typeImage.image = [UIImage imageNamed:@"coup-type0.png"];
        }
            break;
        case 1:
        {
            if (self.voucher.discount > 0) {
                _exchangeHeader.typeImage.image = [UIImage imageNamed:@"coup-type1.png"];
            } else {
                _exchangeHeader.typeImage.image = [UIImage imageNamed:@"coup-type2.png"];
            }
        }
            break;
        default:
            break;
    }
    
    
    [offline addSubview:_QRPicImageView];
    [offline addSubview:lab];
    [offline addSubview:_code];
    [offline addSubview:instructions];
    [offline addSubview:la1];
    [offline addSubview:la2];
    [offline addSubview:la3];
    
    [self.view addSubview:_exchangeHeader];
    [self.view addSubview:offline];
}

- (void)changeCount:(NSString *)count AndState:(BOOL)state AndTag:(int)tag{
    _exchangTag = YES;
    _exchangeHeader.exchange.backgroundColor = [UIColor orangeColor];
    
    _count = count;
}


#pragma mark-网络申请
/**
 *  获取券的兑换信息
 */
-(void)getQRInfo{
    
    int i = _count.integerValue;
    if(_exchangTag == NO){
    }else if (i==0) {
        [self.view.window showHUDWithText:@"兑换数量不能为0" Enabled:YES];
    }else if(i > self.voucher.count){
        [self.view.window showHUDWithText:@"兑换数量不能大于总数量" Enabled:YES];
    }else{
        
        exchangeCount = _count.intValue;
        
        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            if ([i isEqualToString:@"0"]) {
                NSString * str = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%ld&count=%@&appKey=%@&channelId=%@",NEW_HEAD_LINK,QRINFO_METHOD,[UserInfo shareUserInfo].userName,(long)couponId,_count,APP_KEY,[business objectForKey:@"id"]];
                NSLog(@"-----------%@",str);
                [HTTPTool getWithPath:str success:^(id success) {
                    
                    NSString * i=[success objectForKey:@"event"];
                    NSDictionary * dic=[success objectForKey:@"obj"];
                    
                    if([i isEqualToString:@"0"]){
                        
                        _exchangTag = NO;
                        _exchangeHeader.exchange.backgroundColor = [UIColor lightGrayColor];
                        
                        NSString * str=[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[dic objectForKey:@"qrCodeUrl"]];
                        //设置二维码图像
                        [_QRPicImageView sd_setImageWithURL:[NSURL URLWithString:str]];
                        _code.text = [dic objectForKey:@"randCode"];
                        [self.view.window showHUDWithText:@"生成二维码成功" Enabled:YES];
                    }else{
                        [self.view.window showHUDWithText:[success objectForKey:@"msg"] Enabled:YES];
                    }
                    
                } fail:^(NSError *error) {
                    [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
                }];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
        }];
    }
}


-(NSString *)DataConversion:(NSString *) str{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:str.longLongValue/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    return [dateFormatter stringFromDate:date];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_exchangeHeader.countTF resignFirstResponder];
}

/**
 *  返回按钮点击处理
 *
 *  @param sender
 */
-(void)pushBack:(id)sender
{
    [self.delegate popViewControllerGetData:self];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
