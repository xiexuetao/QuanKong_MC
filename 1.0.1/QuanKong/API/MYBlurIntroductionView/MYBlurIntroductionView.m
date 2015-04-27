//
//  MYBlurIntroductionView.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYBlurIntroductionView.h"

@implementation MYBlurIntroductionView
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame{
        if (self = [super initWithFrame:frame]) {
        self.MasterScrollView.delegate = self;
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

-(void)initializeViewComponents{

    //Master Scroll View
    self.MasterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.MasterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    self.MasterScrollView.pagingEnabled = YES;
    self.MasterScrollView.delegate = self;
    self.MasterScrollView.showsHorizontalScrollIndicator = NO;
    self.MasterScrollView.showsVerticalScrollIndicator = NO;
    
    self.MasterScrollView.bounces=NO;
    [self addSubview:self.MasterScrollView];
    
    //Page Control
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37)];
    self.PageControl.currentPage = 0;
    [self addSubview:self.PageControl];
    
    //Get skipString dimensions
    NSString *skipString = NSLocalizedString(@"Skip", nil);
    CGFloat skipStringWidth = 0;
    kSkipButtonFont = [UIFont systemFontOfSize:16];
    

//        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kSkipButtonFont forKey: NSFontAttributeName];
        skipStringWidth = [skipString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.width;
        skipStringWidth = ceilf(skipStringWidth);
//ios7
//        skipStringWidth = [skipString sizeWithFont:kSkipButtonFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;


    //Left Skip Button
    self.LeftSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftSkipButton.frame = CGRectMake(10, self.frame.size.height - 48, 46, 37);
    [self.LeftSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.LeftSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.LeftSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.LeftSkipButton];
    
    //Right Skip Button
    self.RightSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightSkipButton.frame = CGRectMake(self.frame.size.width - skipStringWidth - kLeftRightSkipPadding, self.frame.size.height - 48, skipStringWidth, 37);
    [self.RightSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.RightSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.RightSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.RightSkipButton];
}

//Public method used to build panels

-(void)buildIntroductionWithPanels:(NSArray *)panels{
    Panels = panels;

    
    //Construct panels
    [self addPanelsToScrollView];
}




-(void)addPanelsToScrollView
{
    if (Panels) {
        if (Panels.count > 0) {
            //Set page control number of pages
            self.PageControl.numberOfPages = Panels.count;
            
            //Set items specific to text direction
            if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
                self.LeftSkipButton.hidden = YES;
                [self buildScrollViewLeftToRight];
            }
            else {
                self.RightSkipButton.hidden = YES;
                [self buildScrollViewRightToLeft];
            }
        }
        else {
            NSLog(@"You must pass in panels for the introduction view to have content. 0 panels were found");
        }
    }
    else {
        NSLog(@"You must pass in panels for the introduction view to have content. The panels object was nil.");
    }
}

-(void)buildScrollViewLeftToRight{
    CGFloat panelXOffset = 0;
     for (UIImageView *panelView in Panels) {
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        
         [self.MasterScrollView addSubview:panelView];
        
        //Update panelXOffset to next view origin location
        panelXOffset += panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.height)];
    

}

-(void)buildScrollViewRightToLeft{
    CGFloat panelXOffset = self.frame.size.width*Panels.count;
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset + self.frame.size.width, self.frame.size.height)];
    
    for (UIImageView *panelView in Panels) {
        //Update panelXOffset to next view origin location
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.MasterScrollView addSubview:panelView];
        
        panelXOffset -= panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    
    [self.MasterScrollView setContentOffset:CGPointMake(self.frame.size.width*Panels.count, 0)];
    
    self.PageControl.currentPage = Panels.count;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
        self.CurrentPanelIndex = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        
        //Trigger the finish if you are at the end
        if (self.CurrentPanelIndex == (Panels.count)) {
            
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Assign the last page to be the previous current page
            LastPanelIndex = self.PageControl.currentPage;
            
        
            //Update Page Control
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
                
                
            }
        }
    }
    else if(self.LanguageDirection == MYLanguageDirectionRightToLeft){
        self.CurrentPanelIndex = (scrollView.contentOffset.x-self.frame.size.width)/self.MasterScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == -1) {
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[Panels.count-1 - self.CurrentPanelIndex] withIndex:Panels.count-1 - self.CurrentPanelIndex];
                }
                
            }
        }
    }
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
        if (self.CurrentPanelIndex == (Panels.count - 1)) {
            self.alpha = ((self.MasterScrollView.frame.size.width*(float)Panels.count)-self.MasterScrollView.contentOffset.x)/self.MasterScrollView.frame.size.width;
        }
    }
    else if (self.LanguageDirection == MYLanguageDirectionRightToLeft){
        if (self.CurrentPanelIndex == 0) {
            self.alpha = self.MasterScrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        }
    }
}


-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.MasterScrollView addSubview:closeView];
    
    *xIndex += self.MasterScrollView.frame.size.width;
}

#pragma mark - Interaction Methods

- (void)didPressSkipButton {
    [self skipIntroduction];
}

-(void)skipIntroduction{
    if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
        [delegate introduction:self didFinishWithType:MYFinishTypeSkipButton];
    }
    
    [self hideWithFadeOutDuration:0.3];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}

-(void)changeToPanelAtIndex:(NSInteger)index{
    
}

-(void)setEnabled:(BOOL)enabled{
    [UIView animateWithDuration:0.3 animations:^{
        if (enabled) {
            if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
                self.LeftSkipButton.alpha = !enabled;
                self.RightSkipButton.alpha = enabled;
            }
            else if (self.LanguageDirection == MYLanguageDirectionRightToLeft){
                self.LeftSkipButton.alpha = enabled;
                self.RightSkipButton.alpha = !enabled;
            }
            
            self.MasterScrollView.scrollEnabled = YES;
        }
        else {
            self.LeftSkipButton.alpha = enabled;
            self.RightSkipButton.alpha = enabled;
            self.MasterScrollView.scrollEnabled = NO;
        }
    }];
}



@end
