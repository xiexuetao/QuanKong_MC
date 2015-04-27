//
//  QuanKongNoticeViewController.h
//  QuanKong
//
//  Created by POWER on 14/10/31.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfo.h"
#import "UIImageView+WebCache.h"

#import "HTTPTool.h"

@interface QuanKongNoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *notceTableView;

@end
