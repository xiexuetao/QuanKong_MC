//
//  ExchangeViewController.h
//  Kaiquan
//
//  Created by rockcent on 14-8-27.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//
@class QuanKongVoucher;
#import <UIKit/UIKit.h>
#import "CountSelector.h"
@class ExchangeViewController;

@protocol ExchangePopViewControllerDelegate
@optional
-(void)popViewControllerGetData:(id)viewController;
@end

@interface ExchangeViewController : UIViewController<CountSelectorDelegate>
@property UIView * couponview;
@property NSInteger couponId;
@property(nonatomic,strong)QuanKongVoucher *voucher;
@property(nonatomic,strong)id<ExchangePopViewControllerDelegate> delegate;
@end
