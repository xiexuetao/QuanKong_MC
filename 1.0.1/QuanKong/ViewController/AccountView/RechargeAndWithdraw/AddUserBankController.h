//
//  UserBankInfoController.h
//  QuanKong
//
//  Created by POWER on 1/6/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
#import "UserInfo.h"

@interface AddUserBankController : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *bankInfoTextField;

@property (strong, nonatomic) UILabel *buttonTitleLabel;

@property (copy, nonatomic) NSString *bankLogoUrlStr;
@property (copy, nonatomic) NSString *selectBankId;

@end
