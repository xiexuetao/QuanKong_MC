//
//  ResultView.m
//  QuanKong
//
//  Created by POWER on 12/24/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import "ResultView.h"

 #define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation ResultView

@synthesize backgroundMask;
@synthesize background;
@synthesize messageLabel;
@synthesize iconView;
@synthesize titleLabel;
@synthesize backButton;

/**
 *  显示支付结果
 *
 *  @param title     标题
 *  @param message   内容
 *  @param delegate  委托
 *  @param result    结果
 *  @param superView 需要显示的页面
 */
- (void)showResultViewWihtTitle:(NSString *)title AndMessage:(NSString *)message AndButtonTitle:(NSString *)buttonTitle AndDelegate:(id)delegate ByResult:(BOOL)result InView:(UIView *)superView
{
    self.frame = superView.frame;
    
    self.delegate = delegate;
    
    
    if (!backgroundMask) {
        
        backgroundMask = [[UIView alloc]initWithFrame:superView.bounds];
        backgroundMask.backgroundColor = [UIColor blackColor];
        backgroundMask.alpha = 0.6;
        
        [self addSubview:backgroundMask];
    }

    if (!background) {
        
        background = [[UIView alloc]initWithFrame:CGRectMake(superView.frame.size.width*0.15, superView.frame.size.height*0.25, superView.frame.size.width*0.7, superView.frame.size.height*0.5)];
        
        if (iPhone4) {
            
            background.frame = CGRectMake(superView.frame.size.width*0.15, superView.frame.size.height*0.2, superView.frame.size.width*0.7, superView.frame.size.height*0.6);
        }
        
        background.backgroundColor = [UIColor colorWithRed:240.0/255.0
                                                     green:240.0/255.0
                                                      blue:240.0/255.0
                                                     alpha:1.0];
        
        background.layer.cornerRadius = 3;
        background.layer.shadowColor = [UIColor blackColor].CGColor;
        background.layer.shadowOffset = CGSizeMake(1, 1);
        background.layer.opacity = 1;
        
        [self addSubview:background];
        
    }
    
    if (!iconView) {
        
        iconView = [[UIImageView alloc]initWithFrame:CGRectMake(background.frame.size.width/2-40, 40, 80, 80)];
    }
    
    [background addSubview:iconView];
    
    result?(iconView.image = [UIImage imageNamed:@"pay_success_icon"]):(iconView.image = [UIImage imageNamed:@"pay_fail_icon"]);
    
    if (!titleLabel) {
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 135, background.frame.size.width-60, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.textColor = [UIColor blackColor];
        
        [background addSubview:titleLabel];
    }

    titleLabel.text = title;
    
    if (!messageLabel) {
        
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 175, background.frame.size.width-30, 40)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [background addSubview:messageLabel];
    }

    messageLabel.text = message;
    
    if (!backButton) {
        
        backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, background.frame.size.height-50, background.frame.size.width-20, 40)];
        backButton.backgroundColor = [UIColor whiteColor];
        
        [background addSubview:backButton];
    }
    
    if (result) {
        
        [backButton setTitle:buttonTitle forState:UIControlStateNormal];
        backButton.tag = 1;
        
    } else {
        
        [backButton setTitle:buttonTitle forState:UIControlStateNormal];
        backButton.tag = 0;
    }
    
    [backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.layer.cornerRadius = 3.0f;
    
    [superView addSubview:self];
    
}

/**
 *  消除页面
 */
- (void)dismiss
{
    [self removeFromSuperview];
}

/**
 *  返回按钮
 *
 *  @param sender sender
 */
- (void)backButtonClick:(UIButton *)sender
{
    [self.delegate resultButtonClick:sender];

}

@end
