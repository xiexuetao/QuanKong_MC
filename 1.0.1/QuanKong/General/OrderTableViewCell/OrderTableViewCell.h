//
//  OrderTableViewCell.h
//  QuanKong
//
//  Created by Rick on 14/11/14.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *orderId;
@property(nonatomic,retain)UILabel *time;
@property(nonatomic,retain)UILabel *count;
@property(nonatomic,retain)UILabel *total;
@property(nonatomic,retain)UILabel *orderState;
@end
