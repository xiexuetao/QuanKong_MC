//
//  QuanKongCuponPackageViewController.h
//  QuanKong
//
//  Created by rick on 14/10/21.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "ExchangeViewController.h"
#import "QuanKongTakeCommentViewController.h"
#import "QuanKongCouponDetailViewController.h"
#import "IntnetPrompt.h"
@interface CuponPackageViewController : UIViewController<EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate,UITableViewDelegate,UITableViewDataSource,ExchangePopViewControllerDelegate,CommentViewDelegate,CouponDetailDelegate,IntnetPromptDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger category;

-(id)initWithCouponType:(NSInteger)type;

@end
