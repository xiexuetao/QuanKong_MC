//
//  noticeListCell.m
//  QuanKong
//
//  Created by POWER on 14/11/13.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "noticeListCell.h"

@implementation noticeListCell

@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;
@synthesize timeLabel = _timeLabel;
@synthesize badgeIcon = _badgeIcon;

@synthesize textWebView = _textWebView;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        [self initCellDetail];
    }
    return self;
}

- (void)initCellDetail
{
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 12.5, 50, 50)];
    
    _badgeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(42, -6, 14, 14)];
    _badgeIcon.backgroundColor = [UIColor redColor];
    _badgeIcon.layer.cornerRadius = 7;
    
    [_iconView addSubview:_badgeIcon];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, WIDTH-160, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 32.5, WIDTH-140, 35)];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13.0f];
    
    _textWebView = [[UIWebView alloc]initWithFrame:CGRectMake(67.5, 27.5, WIDTH-120, 35)];
    _textWebView.backgroundColor = [UIColor clearColor];
    _textWebView.scrollView.scrollEnabled = NO;
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-110, 10, 100, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_timeLabel];
    
    [self.contentView addSubview:_textWebView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
