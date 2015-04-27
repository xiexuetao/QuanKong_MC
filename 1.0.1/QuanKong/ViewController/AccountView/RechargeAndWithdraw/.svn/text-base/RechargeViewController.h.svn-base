//
//  RechargeViewController.h
//  QuanKong
//
//  Created by POWER on 12/18/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>

#import "UIWindow+AlertHud.h"
#import "ResultView.h"

#import "HTTPTool.h"

#import "UserInfo.h"

@interface RechargeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,ResultViewDelegate>
{
    NSDictionary *selectDic;
    
    NSString *paySelectPayCount;
    
    NSMutableArray *_products;
    SEL _result;
}

@property (strong, nonatomic) UITableView *rechargeTableView;

@property (strong, nonatomic) UITextField *rechargeTextField;

@property (strong, nonatomic) ResultView *resultView;

@property (strong, nonatomic) UIButton *rechargeButton;

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

@end
