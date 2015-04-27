//
//  LoadingHUDView.h
//  QuanKong
//
//  Created by POWER on 14/11/12.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingHUDView : UIView

+ (LoadingHUDView *)showLoadinginView:(UIView *)view;

+ (LoadingHUDView *)showLoadinginView:(UIView *)view AndFrame:(CGRect)frame AndString:(NSString *)string;

+ (BOOL)hideLoadingView;

@end
