//
//  CountSelector.m
//  QuanKong
//
//  Created by POWER on 14-10-9.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "CountSelector.h"

@implementation CountSelector
{
    int count;
    int limitCount;
    UIButton *reduceButton;
    UIButton *addButton;
}

@synthesize countLabel = _countLabel;
@synthesize limitCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)initViewWithCount:(int)Count And:(int)limit AndTag:(int)tag
{
    
    count = Count;
    limitCount = limit;
    
    self.bounds = CGRectMake(0, 0, 120, 40);
    self.backgroundColor = [UIColor clearColor];
    self.tag = tag;
    
    reduceButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [reduceButton setBackgroundImage:[UIImage imageNamed:@"reduce_coupon_btn_og"] forState:UIControlStateNormal];
    [reduceButton setBackgroundImage:[UIImage imageNamed:@"reduce_coupon_btn"] forState:UIControlStateSelected];
    [reduceButton addTarget:self action:@selector(reduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (Count > 1) {
        
        reduceButton.selected = NO;
        
    } else {
        
        reduceButton.selected = YES;
    }
    
    UIImageView *labelBgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 5, 40, 30)];
    labelBgView.image = [UIImage imageNamed:@"count_label"];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:15.0f];
    _countLabel.text = [NSString stringWithFormat:@"%d",Count];
    
    [labelBgView addSubview:_countLabel];
    
    addButton = [[UIButton alloc]initWithFrame:CGRectMake(85, 5, 30, 30)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_coupon_btn"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_coupon_btn_og"] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(addbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (Count >= limitCount)
    {
        addButton.selected = YES;
        
    } else {
        
        addButton.selected = NO;
    }
    
    [self addSubview:reduceButton];
    [self addSubview:labelBgView];
    [self addSubview:addButton];
}

- (void)reduceButtonClick:(UIButton *)sender
{
    
    if (count > 1) {
        
        count--;
        
        [self.delegate changeCount:[NSString stringWithFormat:@"%d",count] AndState:NO AndTag:self.tag];
        
        _countLabel.text = [NSString stringWithFormat:@"%d",count];
        
        if (count == 1) {
            
            reduceButton.selected = YES;
        }
        
        addButton.selected = NO;
        
    }
    
}

- (void)addbuttonClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        
        if (count < limitCount) {
            
            count++;
            
            [self.delegate changeCount:[NSString stringWithFormat:@"%d",count] AndState:YES AndTag:self.tag];
            
            _countLabel.text = [NSString stringWithFormat:@"%d",count];
            
            if (count == limitCount) {
                
                addButton.selected = YES;
                
                
            }
            
            reduceButton.selected = NO;
        }
        
    } else {
        
        NSLog(@"beyone limit");
    }
}

@end
