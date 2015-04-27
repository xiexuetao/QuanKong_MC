//
//  CouponSelectButton.m
//  QuanKong
//
//  Created by POWER on 14/10/21.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "CouponSelectButton.h"

@implementation CouponSelectButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {gui
    // Drawing code
}
*/

- (void)initSelectButtonWith:(UIImage *)image And:(NSString *)title
{
    self.bounds = CGRectMake(0, 0, (WIDTH-2)/3, 50);
    self.backgroundColor = [UIColor clearColor];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(11, 10, 11, 68)];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 10)];
}


@end
