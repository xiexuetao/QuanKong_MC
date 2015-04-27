//
//  QuanKongCouponLIstViewCell.m
//  QuanKong
//
//  Created by POWER on 14-9-29.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "couponLIstViewCell.h"

@implementation couponLIstViewCell

@synthesize logoImageView = _logoImageView;
@synthesize typeTagImageView = _typeTagImageView;
@synthesize titleLabel = _titleLabel;
@synthesize introduceLabel = _introduceLabel;
@synthesize valueLabel = _valueLabel;
@synthesize cutValueLabel = _cutValueLabel;
@synthesize distanceLabel = _distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        [self initCellDetail];
    }
    return self;
}

- (void)initCellDetail
{
    //券图片
    _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 75)];
    
    //券标识符
    _typeTagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(95-23, 85-23, 23, 23)];
    
    //券的名称
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 7, WIDTH-115, 25)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0;
    
    //券的介绍
    _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 30, WIDTH-115, 35)];
    _introduceLabel.backgroundColor = [UIColor clearColor];
    _introduceLabel.font = [UIFont systemFontOfSize:12.5f];
    _introduceLabel.textAlignment = NSTextAlignmentLeft;
    _introduceLabel.textColor = [UIColor lightGrayColor];
    _introduceLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _introduceLabel.numberOfLines = 0;
    
    //券的价格
    _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 67, 205, 20)];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.font = [UIFont systemFontOfSize:12.0f];
    _valueLabel.textAlignment = NSTextAlignmentLeft;
    _valueLabel.textColor = [UIColor lightGrayColor];
    
    //券的原价
    _cutValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 67, 70, 20)];
    _cutValueLabel.backgroundColor = [UIColor clearColor];
    _cutValueLabel.font = [UIFont systemFontOfSize:12.0f];
    _cutValueLabel.textAlignment = NSTextAlignmentLeft;
    _cutValueLabel.textColor = [UIColor lightGrayColor];
    
    //券的距离
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 67, 90, 20)];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.font = [UIFont systemFontOfSize:12.0f];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_logoImageView];
    [self.contentView addSubview:_typeTagImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_introduceLabel];
    [self.contentView addSubview:_valueLabel];
    [self.contentView addSubview:_cutValueLabel];
    [self.contentView addSubview:_distanceLabel];
    
    self.but = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-60, 60, 50, 30)];
    [self.but setTintColor:[UIColor whiteColor]];
    self.but.layer.cornerRadius = 5.f;
    self.but.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.but];
    
}

- (void)awakeFromNib
{
    // Initialization code
    
    //    [self initCellDetail];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
