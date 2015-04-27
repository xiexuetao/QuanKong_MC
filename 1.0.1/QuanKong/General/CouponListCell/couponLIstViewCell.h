//
//  QuanKongCouponLIstViewCell.h
//  QuanKong
//
//  Created by POWER on 14-9-29.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface couponLIstViewCell : UITableViewCell

@property (copy, nonatomic) UIImageView *logoImageView;

@property (copy, nonatomic) UIImageView *typeTagImageView;

@property (copy, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) UILabel *introduceLabel;

@property (copy, nonatomic) UILabel *valueLabel;

@property (copy, nonatomic) UILabel *cutValueLabel;

@property (copy, nonatomic) UILabel *distanceLabel;

@property (strong,nonatomic)UIButton *but;

//+ (instancetype)cellWIthTableView:(UITableView *)tableView;

@end
