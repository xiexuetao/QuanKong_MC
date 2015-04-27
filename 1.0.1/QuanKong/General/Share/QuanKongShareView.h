//
//  QuanKongShareView.h
//  QuanKong
//
//  Created by Rick on 14/11/4.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareDelegate <NSObject>
@optional
-(void)clickShareButton:(int) indext;
@end

@interface QuanKongShareView : UIView

@property(nonatomic,strong)UIView *sub;
@property(nonatomic,strong)UIButton *but;

@property(nonatomic,strong)id<ShareDelegate> delegate;


-(void)setButtonTitle:(NSString *)title imageName:(NSString *)imageName andButton:(UIButton *) but;

-(void)addButtonToShareView:(NSArray *)arr;
-(UIView *)initShareWithFrame:(CGRect)frame and:(UIViewController *)vc;
@end
