//
//  QuanKongCityViewController.h
//  QuanKong
//
//  Created by POWER on 14-9-18.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanKongCityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *cityTableView;

@property (strong, nonatomic) NSMutableDictionary *cities;

@end
