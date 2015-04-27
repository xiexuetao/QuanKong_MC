//
//  LoadFooterView.m
//  loadMoreFooter
//
//  Created by POWER on 14/12/4.
//  Copyright (c) 2014年 ditaon. All rights reserved.
//

#import "LoadFooterView.h"

#define  WIDTH    [[UIScreen mainScreen]bounds].size.width
#define  HEIGHT   [[UIScreen mainScreen]bounds].size.height
#define IPHONE5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation LoadFooterView

@synthesize titleLabel = _titleLabel;
@synthesize loadingView = _loadingView;

- (id)initFooterViewWithFream:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, self.bounds.size.height/2)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"上拉加载更多...";
    
    [self addSubview:_titleLabel];
    
    _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingView.frame = CGRectMake(WIDTH/2 - [self widthOfString:_titleLabel.text withFont:[UIFont boldSystemFontOfSize:16.0f]]/2 - 30, 20, 20, 20);
    [_loadingView stopAnimating];
    
    [self addSubview:_loadingView];
        
    }
    
    return self;
    
}

- (void)setLoadingFinishedWith:(BOOL)isLoading AndLoading:(NSString *)loading AndFinished:(NSString *)finish
{
    if (isLoading) {
        
        _titleLabel.text = loading;
        
        _loadingView.frame = CGRectMake(WIDTH/2 - [self widthOfString:_titleLabel.text withFont:[UIFont boldSystemFontOfSize:16.0f]]/2 - 30, 20, 20, 20);
        [_loadingView startAnimating];
        
    } else {
        
        _titleLabel.text = finish;
        [_loadingView stopAnimating];
    }
}

- (void)setWithNoMoreData
{
    _titleLabel.text = @"已经是最后一页";
    [_loadingView stopAnimating];
}

/**
 *  根据字符串获取实际显示长度
 *
 *  @param string 传入字符串
 *  @param font   字符号
 *
 *  @return 实际显示长度
 */
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

@end
