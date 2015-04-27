//
//  AlertHudBackgroundView.m
//  AlertHUD
//
//  Created by POWER on 14/11/4.
//  Copyright (c) 2014年 power. All rights reserved.
//

#import "AlertHudBackgroundView.h"

static AlertHudBackgroundView *_shareHUDView = nil;

@implementation AlertHudBackgroundView

+ (AlertHudBackgroundView *)shareHudView
{
    if (!_shareHUDView) {
        
        _shareHUDView = [[AlertHudBackgroundView alloc]init];
        _shareHUDView.alpha = 0;
        _shareHUDView.layer.masksToBounds = YES;
        _shareHUDView.layer.cornerRadius = 5;
        _shareHUDView.barStyle = UIBarStyleBlackTranslucent;
        
    }
    
    return _shareHUDView;
}

@end
