//
//  AlertHudLabel.m
//  AlertHUD
//
//  Created by POWER on 14/11/4.
//  Copyright (c) 2014年 power. All rights reserved.
//

#import "AlertHudLabel.h"

static AlertHudLabel *_shareHUDView = nil;

@implementation AlertHudLabel

+ (AlertHudLabel *)shareHudView
{
    if (!_shareHUDView) {
        _shareHUDView = [[AlertHudLabel alloc] init];
        _shareHUDView.numberOfLines = 0;
        _shareHUDView.lineBreakMode = NSLineBreakByWordWrapping;
        _shareHUDView.alpha = 0;
        _shareHUDView.textAlignment = NSTextAlignmentCenter;
        _shareHUDView.backgroundColor = [UIColor clearColor];
        _shareHUDView.textColor = [UIColor whiteColor];
        _shareHUDView.font = [UIFont boldSystemFontOfSize:17.0f];
        
    }
    return _shareHUDView;
}

@end
