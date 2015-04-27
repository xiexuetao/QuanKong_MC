//
//  Prompt.h
//  QuanKong
//
//  Created by Rick on 14/11/17.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Prompt : UIView

@property(nonatomic,strong)UILabel *label;


/**
 *  显示提示view
 *
 *  @param view 显示在哪一个view上面
 *  @param str  显示的信息
 */
+(id)showPromptWihtView:(UIView *)view message:(NSString *)str;

/**
 *  移除提示view
 *
 *  @param view     移除那一个view的提示
 *  @param animated 动画效果
 */
+(BOOL)removerPromptViewWithView:(UIView *)view animated:(BOOL)animated;

/**
 *
 *
 *  @param view
 *  @param str
 *  @param frame
 *
 *  @return 
 */
+(id)showPromptWihtView:(UIView *)view message:(NSString *)str frame:(CGRect)frame;
@end
