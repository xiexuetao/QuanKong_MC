//
//  QuanKongQRcodeViewController.m
//  QuanKong
//
//  Created by POWER on 14/10/27.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongQRcodeViewController.h"

#import "QuanKongCouponDetailViewController.h"

@interface QuanKongQRcodeViewController ()

@end

@implementation QuanKongQRcodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn_og.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor orangeColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"扫一扫";
        
        self.navigationItem.titleView = titleLabel;
        
    }
    return self;
}

/**
 *  退出页面
 *
 *  @param sender nil
 */
- (void)pushBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        //关闭计时器
        [timer invalidate];
        
    }];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

/**
 *  图像解析方法
 *
 *  @param captureOutput   ？
 *  @param metadataObjects 获取数据
 *  @param connection      链接？
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    [_session stopRunning];
    
    //判断数据是否为空
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        NSLog(@"%@",stringValue);
        
        //根据获得字符串提取有效couponID
        
        NSRange rang = [stringValue rangeOfString:@"couponModelId="];
        
        _strArray = [stringValue componentsSeparatedByString:@"couponModelId="];

        NSArray *subStrArray = [(NSString *)[_strArray objectAtIndex:0] componentsSeparatedByString:@"channelId="];
        QuanKongCouponDetailViewController *couponDetailViewController = [[QuanKongCouponDetailViewController alloc]init];

        NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
        [HTTPTool getWithPath:url success:^(id success) {
            NSString * i = [success objectForKey:@"event"];
            NSArray *arr = [success objectForKey:@"objList"];
            NSDictionary *business =  arr[0];
            NSString *ID = [business objectForKey:@"id"];
            if ([i isEqualToString:@"0"]) {
                //如果可以提取有效id
                if(_strArray.count > 1 && rang.length > 0) {
                    /**
                     根据couponId加载券详情页面
                     */
//                    NSLog(@"%@,%@",[_strArray objectAtIndex:1],[subStrArray objectAtIndex:1]);
                    
                    [couponDetailViewController getCouponDetailWithCouponID:[_strArray objectAtIndex:1] And:ID];
                    
                    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
                    
                    [self.navigationController pushViewController:couponDetailViewController animated:YES];
                    
                } else {
                    _strArray = [stringValue componentsSeparatedByString:@"couponModelId="];
                    if (_strArray.count > 1) {
                        [couponDetailViewController getCouponDetailWithCouponID:[_strArray objectAtIndex:1] And:ID];
                        
                        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
                        
                        [self.navigationController pushViewController:couponDetailViewController animated:YES];
                    }else{
                        UIAlertView *failQrcodeAlertView = [[UIAlertView alloc]initWithTitle:@"你扫描的不是有效二维码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新扫描", nil];
                        
                        [failQrcodeAlertView show];
                    }
                }
            }else{
                [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
            }
        } fail:^(NSError *error) {
            [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
        }];
        
    } else {
        
        NSLog(@"fail");
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //创建二维码表层视图
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, WIDTH-30, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/32, 100, WIDTH-WIDTH/16, WIDTH-WIDTH/16)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, WIDTH-100, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

/**
 *  扫描线动画
 */
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

/**
 *  页面出现,状态栏颜色为默认黑色，初始化摄像头
 *
 *  @param animated nil
 */
-(void)viewWillAppear:(BOOL)animated{
    
    [self setupCamera];
    
    self.navigationController.navigationBar.barTintColor = nil;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 *  页面消失,状态栏设为白色，关闭摄像头、计时器
 *
 *  @param animated
 */
-(void)viewWillDisappear:(BOOL)animated{
    
    [timer invalidate];
    
    [self endCamera];
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

/**
 *  初始化摄像头
 */
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
//        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}

/**
 *  alert提示刷新摄像头
 *
 *  @param alertView   nil
 *  @param buttonIndex nil
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        [self endCamera];
        
        [self setupCamera];
    }
}

/**
 *  关闭摄像头，移除获得图像
 */
- (void)endCamera
{
    [_preview removeFromSuperlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
