//
//  QuanKongPayViewController.h
//  QuanKong
//
//  Created by POWER on 14-10-9.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>

#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "LoadingHUDView.h"
#import "ResultView.h"

@class QuanKongPayViewController;
@protocol PayDelegate<NSObject>
-(void)backOrderDelegate:(QuanKongPayViewController *)payViewController;
@end

@interface Product : NSObject{
@private
    float _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end

@interface QuanKongPayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ResultViewDelegate>
{
    NSMutableArray *_products;
    SEL _result;
}

@property (strong, nonatomic) UITableView *payTableView;
@property (nonatomic,retain)id<PayDelegate> delegate;
@property (nonatomic, strong) ResultView *resultView;

- (void)getOrderDetailWith:(NSString *)orderNumber;

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

@end
