//
//  IntnetPrompt.m
//  QuanKong
//
//  Created by Rick on 14/11/10.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "IntnetPrompt.h"

static IntnetPrompt *_intnetPrompt;

@implementation IntnetPrompt

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [super initWithFrame:frame];
        self.label = [[UILabel alloc] init];
        self.label.bounds = CGRectMake(0, 0, WIDTH, 35);
        self.label.center = CGPointMake(WIDTH/2, frame.size.height/2-35);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"亲，你的网络好像不太给力呢！";
        self.label.font = [UIFont systemFontOfSize:16.f];
        self.label.textColor = [UIColor darkGrayColor];
        
        self.self.but = [UIButton buttonWithType:UIButtonTypeCustom];
        self.but.bounds = CGRectMake(0, 0, WIDTH/3.2, 35);
        self.but.center = CGPointMake(WIDTH/2, frame.size.height/2);
        [self.but setTitle:@"点击刷新" forState:UIControlStateNormal];
        [self.but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.but.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.but.layer.cornerRadius = 4.0f;
        
        [self.but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.label];
        [self addSubview:self.but];
        [self setBackgroundColor:LIGHT_GRAY];
    }
    return self;
}

+(id)showIntnetPromptWithMessage:(NSString *)message inView:(UIView *)vc{
    
    if (!_intnetPrompt) {
         _intnetPrompt = [[self alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    _intnetPrompt.label.text = message;
    _intnetPrompt.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [vc addSubview:_intnetPrompt];
        return _intnetPrompt;
}

+(id)showIntnetPromptWithMessage:(NSString *)message inView:(UIView *) vc frame:(CGRect)frame{
    
    if (!_intnetPrompt) {
        _intnetPrompt = [[self alloc] initWithFrame:frame];
    }
    
    _intnetPrompt.label.text = message;
    _intnetPrompt.frame = frame;
    [vc addSubview:_intnetPrompt];
    return _intnetPrompt;
    
}

-(void)click:(UIButton *) but{
    
    [self.delegate clickButtonOperation:_intnetPrompt];
    
}


+ (BOOL)hideIntnetPromptForView:(UIView *)view animated:(BOOL)animated {
    if (_intnetPrompt) {
        [_intnetPrompt removeFromSuperview];
        return YES;
    }
    return NO;
}

@end
