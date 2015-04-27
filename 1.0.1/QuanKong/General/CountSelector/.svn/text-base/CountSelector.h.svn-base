//
//  CountSelector.h
//  QuanKong
//
//  Created by POWER on 14-10-9.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountSelectorDelegate <NSObject>

- (void)changeCount:(NSString *)count AndState:(BOOL)state AndTag:(int)tag;

@end

@interface CountSelector : UIView

- (void)initViewWithCount:(int)Count And:(int)limit AndTag:(int)tag;

@property (strong, nonatomic) UILabel *countLabel;

@property (assign, nonatomic) int limitCount;

@property (nonatomic, unsafe_unretained) id<CountSelectorDelegate> delegate;

@end
