//
//  QuanKongCouponDetailViewController.h
//  QuanKong
//
//  Created by POWER on 14-9-22.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RatingView.h"

#import "UserInfo.h"
#import "QuanKongVoucher.h"
#import "QuanKongStore.h"
#import "NSString+DisposeStr.h"
#import "NSDate+Help.h"

#import "CountSelector.h"
#import "UIWindow+AlertHud.h"
#import "QuanKongShareView.h"
#import "couponDetailView.h"
#import "LoadFooterView.h"

#import "HTTPTool.h"

#import "WechatAndWeibo.h"

@class QuanKongShareView;

@protocol CouponDetailDelegate <NSObject>

-(void)popViewControllerGetData:(id) viewController;

@end

@interface QuanKongCouponDetailViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CountSelectorDelegate,UIAlertViewDelegate,UIActionSheetDelegate,ShareDelegate,WechatAndWeiboDelegate,UIWebViewDelegate>


- (void)getCouponDetailWithCouponID:(NSString *)Id And:(NSString *)channelId;

@property (strong, nonatomic) UITableView *couponTableView;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *orderNowBgView;

@property (strong, nonatomic) UILabel *countValueLabel;

@property (strong, nonatomic) CountSelector *countSelector;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong,nonatomic) QuanKongShareView *share;

@property (strong,nonatomic) UIView *showView;

@property (strong,nonatomic)id<CouponDetailDelegate> delegate;

@end
