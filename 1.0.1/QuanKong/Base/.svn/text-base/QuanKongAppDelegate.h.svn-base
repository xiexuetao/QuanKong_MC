//
//  QuanKongAppDelegate.h
//  QuanKong
//
//  Created by POWER on 14-9-17.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BMapKit.h"
#import "BMKMapManager.h"
#import <AlipaySDK/AlipaySDK.h>

#import "UserInfo.h"
#import "ResultView.h"

@class WechatAndWeibo;
@interface QuanKongAppDelegate : UIResponder <UIApplicationDelegate,UIGestureRecognizerDelegate,ResultViewDelegate>
{
    CLLocationManager *locationManager;
    BMKMapManager *_mapManager;
    ResultView *resultView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)WechatAndWeibo * wechatAndWeibo;

- (void)setTabbarController;

@end
