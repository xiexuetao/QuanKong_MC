//
//  couponDetailView.m
//  QuanKong
//
//  Created by POWER on 14/11/24.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "couponDetailView.h"

#define BLUE [UIColor colorWithRed:95.0/255.0 green:163.0/255.0 blue:239.0/255.0 alpha:1.0]
#define GRAY [UIColor grayColor]

@implementation couponDetailView

- (void)initViewWithTag:(NSInteger)tag AndSaleCount:(NSInteger)SaleCount AndRemainCount:(NSInteger)RemainCount AndUseEndTime:(NSNumber *)userEndTime AndRect:(CGRect)Bounds AndCouponTag:(NSInteger)couponTag;
{
    self.frame = Bounds;
    
    NSString *timeStr = [self getTimeStrWithString:[userEndTime stringValue]];
    
    NSArray *iconStrArray = [NSArray array];
    NSArray *iconNameArray = [NSArray array];
    NSArray *colorArray = [[NSArray alloc]initWithObjects:BLUE,BLUE,GRAY,GRAY,GRAY,nil];
    
    if (tag == 0 || couponTag == 1) {
        
        iconNameArray = [[NSArray alloc]initWithObjects:@"cart_icon",@"coupon_icon",@"clock_icon", nil];
        
        iconStrArray = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"已售：%ld张",(long)SaleCount],[NSString stringWithFormat:@"剩余：%ld张",(long)RemainCount],[NSString stringWithFormat:@"有效期至：%@",timeStr], nil];
        
        for (int n = 0; n < 3; n++) {
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+25*n, 13, 13)];
            iconView.image = [UIImage imageNamed:[iconNameArray objectAtIndex:n]];
            
            UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 6+25*n, 140, 20)];
            iconLabel.backgroundColor = [UIColor clearColor];
            iconLabel.textAlignment = NSTextAlignmentLeft;
            iconLabel.font = [UIFont systemFontOfSize:12.0f];
            iconLabel.textColor = GRAY;
            iconLabel.text = [iconStrArray objectAtIndex:n];
            
            if (n == 2) {
                
                iconView.frame = CGRectMake(10, 68, 13, 13);
                iconLabel.frame = CGRectMake(28, 65, 140, 20);
            }
            
            [self addSubview:iconView];
            [self addSubview:iconLabel];
        }
        
    } else {
        
        //4个数据按钮icon
        iconNameArray = [[NSArray alloc]initWithObjects:@"right_icon",@"right_icon",@"cart_icon",@"coupon_icon",@"clock_icon", nil];
        
        iconStrArray = [[NSArray alloc]initWithObjects:@"支持过期自动退款",@"支持随时退款",[NSString stringWithFormat:@"已售：%d张",SaleCount],[NSString stringWithFormat:@"剩余：%d张",RemainCount],[NSString stringWithFormat:@"有效期至：%@",timeStr], nil];
        
        for (int n = 0; n < 5; n++) {
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10+150*(n%2), 11+25*(n/2), 13, 13)];
            iconView.image = [UIImage imageNamed:[iconNameArray objectAtIndex:n]];
            
            UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(28+150*(n%2), 7+25*(n/2), 140, 20)];
            iconLabel.backgroundColor = [UIColor clearColor];
            iconLabel.textAlignment = NSTextAlignmentLeft;
            iconLabel.font = [UIFont systemFontOfSize:12.0f];
            iconLabel.textColor = [colorArray objectAtIndex:n];
            iconLabel.text = [iconStrArray objectAtIndex:n];
            
            if (n == 4) {
                
                iconView.frame = CGRectMake(10, 68, 13, 13);
                
                iconLabel.frame = CGRectMake(28, 65, 140, 20);
            }
            
            if (n != 1) {
                
                [self addSubview:iconView];
                [self addSubview:iconLabel];
            }
            
        }
        
    }
    
}

//转换时间戳
- (NSString *)getTimeStrWithString:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000];
    
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    
    NSDate *now = [NSDate date];
    
    NSString *dateNow = [dateFormatter stringFromDate:now];
    
    if ([dateSMS isEqualToString:dateNow]) {
        
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else {
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    dateSMS = [dateFormatter stringFromDate:date];
    
    return dateSMS;
}

@end
