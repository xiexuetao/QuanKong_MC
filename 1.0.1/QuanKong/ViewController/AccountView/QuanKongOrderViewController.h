//
//  QuanKongOrderViewController.h
//  QuanKong
//
//  Created by Rick on 14/11/3.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "QuanKongNoPaymentViewController.h"
#import "IntnetPrompt.h"

@interface QuanKongOrderViewController : UIViewController<EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate,UITableViewDelegate,UITableViewDataSource,popViewControllerDelegate,IntnetPromptDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
-(id)initWithCouponType:(NSInteger)type;

@end
