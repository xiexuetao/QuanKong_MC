//
//  IntnetPrompt.h
//  QuanKong
//
//  Created by Rick on 14/11/10.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntnetPrompt;
@protocol IntnetPromptDelegate <NSObject>
@optional
-(void)clickButtonOperation:(IntnetPrompt *) intnetView;
@end

@interface IntnetPrompt : UIView
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *but;
@property(nonatomic,assign)NSString *operat;
@property(nonatomic,retain)id<IntnetPromptDelegate> delegate;

+(id)showIntnetPromptWithMessage:(NSString *)message inView:(UIView *)vc;

+ (BOOL)hideIntnetPromptForView:(UIView *)view animated:(BOOL)animated;

+(id)showIntnetPromptWithMessage:(NSString *)message inView:(UIView *)vc frame:(CGRect)frame;
@end
