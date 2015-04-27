//
//  QuanKongClassViewController.h
//  QuanKong
//
//  Created by POWER on 14-9-16.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntnetPrompt.h"

@interface QuanKongClassViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IntnetPromptDelegate>

@property (strong, nonatomic) UITableView *testTableView;

@end
