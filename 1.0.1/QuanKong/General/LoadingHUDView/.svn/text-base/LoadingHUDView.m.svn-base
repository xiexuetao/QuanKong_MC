//
//  LoadingHUDView.m
//  QuanKong
//
//  Created by POWER on 14/11/12.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "LoadingHUDView.h"

static LoadingHUDView *_loadingHUDView = nil;

@implementation LoadingHUDView


+ (LoadingHUDView *)showLoadinginView:(UIView *)view
{
    return [LoadingHUDView showLoadinginView:view AndFrame:view.bounds AndString:@"加载中..."];
}

+ (LoadingHUDView *)showLoadinginView:(UIView *)view AndFrame:(CGRect)frame AndString:(NSString *)string
{
    if (!_loadingHUDView) {
        
        _loadingHUDView = [[LoadingHUDView alloc]initWithFrame:frame];
        _loadingHUDView.backgroundColor = LIGHT_GRAY;
        _loadingHUDView.userInteractionEnabled = NO;
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(frame.size.width/2-40, frame.size.height/2-50, 20, 20)];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [loadingView startAnimating];
        
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-15, frame.size.height/2-50, 60, 20)];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        loadingLabel.font = [UIFont systemFontOfSize:14.0f];
        loadingLabel.textColor = [UIColor lightGrayColor];
        loadingLabel.text = string;
        
        [_loadingHUDView addSubview:loadingView];
        [_loadingHUDView addSubview:loadingLabel];
        
    }else{
        _loadingHUDView.frame = frame;
    }
    
        [view addSubview:_loadingHUDView];
    
    return _loadingHUDView;
}

+ (BOOL)hideLoadingView
{
    if (_loadingHUDView) {
        
        [_loadingHUDView removeFromSuperview];
        
        return YES;
        
    } else {
        
        return NO;
    }
}


@end
