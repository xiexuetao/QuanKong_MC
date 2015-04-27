//
//  QuanKongCategoryViewController.h
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/29.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "IntnetPrompt.h"
@class QuanKongVoucher;
@class QuanKongClass;
@interface QuanKongCategoryViewController : UIViewController<EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate,UITableViewDelegate,UITableViewDataSource,IntnetPromptDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)QuanKongVoucher *voucher;
@property(nonatomic,retain)QuanKongClass *cla;
@end
