//
//  DDBackTopButton.m
//  HouseApp
//
//  Created by dzy on 16/1/11.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DDBackTopButton.h"

typedef enum{
    ScrollViewScrollDirectionStop = 0,
    ScrollViewScrollDirectionTop = 1,
    ScrollViewScrollDirectionDown = 2
    
} ScrollViewScrollDirection;

#define _backTopScreenH [UIScreen mainScreen].bounds.size.height

@interface DDBackTopButton ()

@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat originalContentOffsetY;
@property (nonatomic, assign) ScrollViewScrollDirection direction;

@end

@implementation DDBackTopButton

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.scrollView = (UIScrollView *)newSuperview;
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        
        CGRect frame = self.frame;
        frame.size = _backTopViewSize;
        self.frame = frame;
        
        [self setImage:[UIImage imageNamed:_backTopViewNormalImageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:_backTopViewHighlightedImageName] forState:UIControlStateHighlighted];
        
        self.originalContentOffsetY = self.scrollView.contentOffset.y + 64;
        
        self.hidden = YES;
        
        [self addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGPoint old = [change[@"old"] CGPointValue];
    CGPoint new = [change[@"new"] CGPointValue];
    
    if (new.y - old.y > 0) {
        
        self.direction = ScrollViewScrollDirectionDown;
    }else if (new.y - old.y < 0){
        self.direction = ScrollViewScrollDirectionTop;
    }
    
    if (!self.scrollView.isDragging && self.scrollView.isDecelerating) {
        self.direction = ScrollViewScrollDirectionStop;
    }
    
    BOOL isOverLimit = (new.y - self.originalContentOffsetY) >_backTopShowWithOffsetY;
    
    if (isOverLimit && self.direction == ScrollViewScrollDirectionTop) {
        
        self.hidden = NO;
    }else if(!isOverLimit || self.direction == ScrollViewScrollDirectionDown){
        self.hidden = YES;
    }/*else{
    
      if (isOverLimit) {
      self.hidden = NO;
      }else{
      self.hidden = YES;
      }
      }*/
    
    self.center = CGPointMake(_backTopViewCenter.x, self.scrollView.frame.size.height - (_backTopScreenH -  _backTopViewCenter.y) + new.y);

}

- (void)dealloc
{
    if (self.superview) {
        
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)backTop
{
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
//    NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
//    NSLog(@"%f", self.scrollView.contentOffset.y);
}

@end
