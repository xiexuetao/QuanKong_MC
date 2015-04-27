//
//  QuanKongTakeCommentViewController.h
//  QuanKong
//
//  Created by POWER on 14/11/5.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

#import "RatingView.h"
#import "UIWindow+AlertHud.h"
#import "HTTPTool.h"

@class QuanKongTakeCommentViewController;
@protocol CommentViewDelegate<NSObject>
-(void)popViewControllerGetData:(id)viewController;
@end
@interface QuanKongTakeCommentViewController : UIViewController<RatingViewDelegate,UITextViewDelegate>
{
    RatingView *ratingView;
}

@property (strong, nonatomic) NSString *couponId;

@property (strong, nonatomic) NSString *verificationId;

@property (strong, nonatomic) RatingView *ratingView;

@property (strong, nonatomic) UILabel *ratingLabel;

@property (strong, nonatomic) UITextView *commentTextView;

@property (strong, nonatomic) UILabel *placeholderLabel;

@property(nonatomic,strong)id<CommentViewDelegate> delegate;

@end
