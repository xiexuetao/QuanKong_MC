//
//  ResultView.h
//  QuanKong
//
//  Created by POWER on 12/24/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultViewDelegate <NSObject>

- (void)resultButtonClick:(UIButton *)sender;

@end

@interface ResultView : UIView

/**
 *  显示支付结果
 *
 *  @param title     标题
 *  @param message   内容
 *  @param delegate  委托
 *  @param result    结果
 *  @param superView 需要显示的页面
 */
- (void)showResultViewWihtTitle:(NSString *)title AndMessage:(NSString *)message AndButtonTitle:(NSString *)buttonTitle AndDelegate:(id)delegate ByResult:(BOOL)result InView:(UIView *)superView;

/**
 *  消除页面
 */
- (void)dismiss;

@property (nonatomic, unsafe_unretained) id<ResultViewDelegate> delegate;

@property (nonatomic, strong) UIView *backgroundMask;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *backButton;

@end
