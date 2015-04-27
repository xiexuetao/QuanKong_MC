//
//  QuanKongNoPaymentViewController.h
//  QuanKong
//
//  Created by rick on 14/10/28.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuanKongPayViewController.h"
#import "IntnetPrompt.h"
@class QuanKongVoucher;
@class QuanKongNoPaymentViewController;
@class OrderInfo;
@protocol popViewControllerDelegate <NSObject>
-(void)popViewControllerOptionGetData:(QuanKongNoPaymentViewController *) noPay;
@end
@interface QuanKongNoPaymentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PayDelegate,IntnetPromptDelegate>
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,assign)int payTag;
@property(nonatomic,strong)id<popViewControllerDelegate> delegate;

@end
