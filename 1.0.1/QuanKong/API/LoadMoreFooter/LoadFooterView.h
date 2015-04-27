//
//  LoadFooterView.h
//  loadMoreFooter
//
//  Created by POWER on 14/12/4.
//  Copyright (c) 2014年 ditaon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadFooterView : UIView

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

- (id)initFooterViewWithFream:(CGRect)frame;

- (void)setLoadingFinishedWith:(BOOL)isLoading AndLoading:(NSString *)loading AndFinished:(NSString *)finish;

- (void)setWithNoMoreData;

@end
