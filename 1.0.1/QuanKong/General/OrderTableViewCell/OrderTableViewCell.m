//
//  OrderTableViewCell.m
//  QuanKong
//
//  Created by Rick on 14/11/14.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        [self initCellDetail];
    }
    return self;
}

-(void)initCellDetail{
    self.orderState = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH, 40)];
    self.orderId = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, WIDTH, 40)];
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, WIDTH, 40)];
    self.count = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, WIDTH, 40)];
    self.total = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, WIDTH, 40)];
    self.orderState.font = [UIFont systemFontOfSize:15.f];
    self.orderState.textColor = [UIColor darkGrayColor];
    self.orderId.font = [UIFont systemFontOfSize:15.f];
   self. orderId.textColor = [UIColor darkGrayColor];
    self.time.font = [UIFont systemFontOfSize:15.f];
    self.time.textColor = [UIColor darkGrayColor];
    self.count.font = [UIFont systemFontOfSize:15.f];
    self.count.textColor = [UIColor darkGrayColor];
    self.total.font = [UIFont systemFontOfSize:15.f];
    self.total.textColor = [UIColor darkGrayColor];
    
    UIImageView *l = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, WIDTH-10, 0.5)];
    UIImageView *l2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, WIDTH-10, 0.5)];
    UIImageView *l3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, WIDTH-10, 0.5)];
    UIImageView *l4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 160, WIDTH-10, 0.5)];
    l.backgroundColor = [UIColor lightGrayColor] ;
    l2.backgroundColor = [UIColor lightGrayColor];
    l3.backgroundColor = [UIColor lightGrayColor];
    l4.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:l];
    [self addSubview:l2];
    [self addSubview:l3];
    [self addSubview:l4];
    
    [self addSubview:self.orderState];
    [self addSubview:self.orderId];
    [self addSubview:self.time];
    [self addSubview:self.count];
    [self addSubview:self.total];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
