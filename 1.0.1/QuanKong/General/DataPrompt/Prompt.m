//
//  Prompt.m
//  QuanKong
//
//  Created by Rick on 14/11/17.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "Prompt.h"
static Prompt *_promptView;
@implementation Prompt



-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [super initWithFrame:frame];
//        _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,WIDTH, HEIGHT)];
        self.label = [[UILabel alloc] init];
        self.label.bounds = CGRectMake(0, 0, WIDTH, 35);
        self.label.center = CGPointMake(WIDTH/2, frame.size.height/2);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"亲！还没有券快去逛逛吧！";
        self.label.font = [UIFont systemFontOfSize:15.f];
        self.label.textColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [self addSubview:self.label];
    }
    return self;
}

+(id)showPromptWihtView:(UIView *)view message:(NSString *)str{
    
    if (!_promptView) {
        _promptView = [[self alloc] initWithFrame:CGRectMake(0, 0 ,view.frame.size.width, view.frame.size.height)];
    }
    _promptView.label.text = str;
    [view addSubview:_promptView];
    return _promptView;
}

+(id)showPromptWihtView:(UIView *)view message:(NSString *)str frame:(CGRect)frame{
    
    if (!_promptView) {
        _promptView = [[self alloc] initWithFrame:frame];
    }else{
        _promptView.frame = frame;
    }
    _promptView.label.text = str;
    [view addSubview:_promptView];
    return _promptView;
}


+(BOOL)removerPromptViewWithView:(UIView *)view animated:(BOOL)animated{
    if (_promptView) {
        [_promptView removeFromSuperview];
        return YES;
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
