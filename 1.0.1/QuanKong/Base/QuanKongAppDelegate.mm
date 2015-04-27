//
//  QuanKongAppDelegate.m
//  QuanKong
//
//  Created by POWER on 14-9-17.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongAppDelegate.h"
#import "IntroductionViewController.h"
#import "QuanKongHomeViewController.h"
#import "QuanKongNearViewController.h"
#import "QuanKongAccountViewController.h"
#import "QuanKongClassViewController.h"
#import "QuanKongMarketViewController.h"
#import "QuanKongSpecifyTransactionViewController.h"

#import "RechargeViewController.h"

#import "DataVerifier.h"
#import "WechatAndWeibo.h"

#import "UIWindow+AlertHud.h"

@implementation QuanKongAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    
    //微博微信初始化
    self.wechatAndWeibo = [WechatAndWeibo initWithSWW];
    
    //开启百度地图功能////////////////////////////////////
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        locationManager = [[CLLocationManager alloc]init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        
        [[UIApplication sharedApplication]
         registerUserNotificationSettings:[UIUserNotificationSettings
                        settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"bClQUE6hhthU7TvfoFUGbnZl" generalDelegate:nil];
    if (!ret) {
        NSLog(@"BaiduMap manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //首次提交版本屏蔽引导图
    
    /*if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        
        NSLog(@"第一次启动");
        
        [self.window setRootViewController:[[IntroductionViewController alloc]init]];
        
    }else{
        
        
        NSLog(@"已经不是第一次启动了");
        
        [self setTabbarController];
        
    }*/
    
    //首次版本直接进入首页
    [self setTabbarController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[NSString stringWithFormat:@"%@", deviceToken] substringWithRange:NSMakeRange(1, 71)]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is:%@", token);
    
    [UserInfo shareUserInfo].appleToken = token;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"appleToken"];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    } else {
        
//        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}   

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             
             NSString *result = [resultDic objectForKey:@"resultStatus"];
             
             switch ([result intValue]) {
                 case 9000:
                 {
                     [resultView showResultViewWihtTitle:@"充值成功"
                                              AndMessage:@"请检查你的券控钱包，款项将在15分钟内到账。"
                                          AndButtonTitle:@"返回"
                                             AndDelegate:self
                                                ByResult:YES
                                                  InView:self.window];
                 }
                     break;
                 case 4000:
                 {
                     [resultView showResultViewWihtTitle:@"充值失败"
                                              AndMessage:@"请确定资料是否正确，或是否正确操作。"
                                          AndButtonTitle:@"重新充值"
                                             AndDelegate:self
                                                ByResult:NO
                                                  InView:self.window];
                 }
                     break;
                 case 6001:
                 {
                     [resultView showResultViewWihtTitle:@"充值失败"
                                              AndMessage:@"充值支付被中途取消了。"
                                          AndButtonTitle:@"重新充值"
                                             AndDelegate:self
                                                ByResult:NO
                                                  InView:self.window];
                 }
                     break;
                 case 6002:
                 {
                     [resultView showResultViewWihtTitle:@"充值失败"
                                              AndMessage:@"网络出现问题了，请检查你的网络"
                                          AndButtonTitle:@"重新充值"
                                             AndDelegate:self
                                                ByResult:NO
                                                  InView:self.window];
                 }
                     break;
                 default:
                     break;
             }

         }];
        
        return YES;
    }
    
    return [WeiboSDK handleOpenURL:url delegate:self.wechatAndWeibo]||[WXApi handleOpenURL:url delegate:self.wechatAndWeibo];
}

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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)setTabbarController
{
    QuanKongHomeViewController *mainViewController = [[QuanKongHomeViewController alloc]init];
    
    UITabBarItem *mainTabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home_icon_defualt"] selectedImage:[UIImage imageNamed:@"home_icon_select"]];
    mainViewController.tabBarItem = mainTabBarItem;
    
    UINavigationController *myNav_0 = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    myNav_0.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    //自定义返回按钮令返回手势失效，重定义返回手势
    myNav_0.interactivePopGestureRecognizer.delegate = self;
    myNav_0.navigationBar.translucent = YES;
    
    QuanKongNearViewController *nearViewController = [[QuanKongNearViewController alloc]init];
    
    UITabBarItem *nearTabBarItem = [[UITabBarItem alloc]initWithTitle:@"附近" image:[UIImage imageNamed:@"near_icon_defualt"] selectedImage:[UIImage imageNamed:@"near_icon_select"]];
    nearViewController.tabBarItem = nearTabBarItem;
    
    UINavigationController *myNav_1 = [[UINavigationController alloc]initWithRootViewController:nearViewController];
    myNav_1.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    myNav_1.interactivePopGestureRecognizer.delegate = self;
    myNav_1.navigationBar.translucent = YES;
    
    
    
    QuanKongSpecifyTransactionViewController *swx = [[QuanKongSpecifyTransactionViewController alloc]init];
    
    UITabBarItem *swxTabBarItem = [[UITabBarItem alloc]initWithTitle:@"券市" image:[UIImage imageNamed:@"account_icon_defualt"] selectedImage:[UIImage imageNamed:@"account_icon_select"]];
    swx.tabBarItem = swxTabBarItem;
    
    UINavigationController *myNav_5 = [[UINavigationController alloc]initWithRootViewController:swx];
    myNav_5.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    myNav_5.interactivePopGestureRecognizer.delegate = self;
    myNav_5.navigationBar.translucent=YES;
    
    QuanKongAccountViewController *accountViewController = [[QuanKongAccountViewController alloc]init];
    UITabBarItem *accountTabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"account_icon_defualt"] selectedImage:[UIImage imageNamed:@"account_icon_select"]];
    accountViewController.tabBarItem = accountTabBarItem;
    
    UINavigationController *myNav_2 = [[UINavigationController alloc]initWithRootViewController:accountViewController];
    myNav_2.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    myNav_2.interactivePopGestureRecognizer.delegate = self;
    myNav_2.navigationBar.translucent=YES;
    
    QuanKongClassViewController *classViewController = [[QuanKongClassViewController alloc]init];
    
    UITabBarItem *classTabBarItem = [[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"class_icon_defualt"] selectedImage:[UIImage imageNamed:@"class_icon_select"]];
    classViewController.tabBarItem = classTabBarItem;
    
    UINavigationController *myNav_3 = [[UINavigationController alloc]initWithRootViewController:classViewController];
    myNav_3.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    myNav_3.interactivePopGestureRecognizer.delegate = self;
    myNav_3.navigationBar.translucent=YES;
    
    QuanKongMarketViewController *marketViewController = [[QuanKongMarketViewController alloc]init];
    
    UITabBarItem *marketTabBarItem = [[UITabBarItem alloc]initWithTitle:@"券市" image:[UIImage imageNamed:@"market_icon_defualt"] selectedImage:[UIImage imageNamed:@"market_icon_select"]];
    marketViewController.tabBarItem = marketTabBarItem;
    
    UINavigationController *myNav_4 = [[UINavigationController alloc]initWithRootViewController:marketViewController];
    myNav_4.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    myNav_4.interactivePopGestureRecognizer.delegate = self;
    myNav_4.navigationBar.translucent=YES;
    
//    NSArray *controllersArray = [[NSArray alloc]initWithObjects:myNav_0,myNav_1,myNav_5,myNav_3,myNav_2, nil];
    
    NSArray *controllersArray = [[NSArray alloc]initWithObjects:myNav_0,myNav_1,myNav_3,myNav_2, nil];
    
    UITabBarController *tabController = [[UITabBarController alloc]init];
    tabController.viewControllers = controllersArray;
    tabController.tabBar.backgroundColor = [UIColor whiteColor];
    tabController.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    tabController.tabBar.translucent = YES;
    
    if (!resultView) {
        
        resultView = [[ResultView alloc]init];
    }
    
    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];
    
}


@end
