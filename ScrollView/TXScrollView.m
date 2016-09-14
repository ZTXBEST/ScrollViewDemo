//
//  TXScrollView.m
//  ScrollView
//
//  Created by 赵天旭 on 16/9/13.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "TXScrollView.h"

#define kViewWidth CGRectGetWidth(self.frame)
#define kViewHeight CGRectGetHeight(self.frame)
#define kScrollViewWidth kViewWidth * 0.75
#define kScale 0.8
#define kImageTag 888

@interface TXScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign)NSInteger currIndex;
@property (nonatomic,assign)CGFloat beginOffX;

@end

@implementation TXScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildScrollView];
    }
    return self;
}


- (void)buildScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollViewWidth, kViewHeight)];
    self.scrollView.center = self.center;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
}

- (void)setItmeArray:(NSMutableArray *)itmeArray {
    _itmeArray = itmeArray;
    for (NSInteger i = 0; i < _itmeArray.count; i ++) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScrollViewWidth * i, kViewHeight * .2, kScrollViewWidth * .9, kViewHeight * .6)];
        imageView.tag = kImageTag + i;
        [_scrollView addSubview:imageView];
                
        CALayer * layer = [CALayer layer];
        layer.frame = imageView.bounds;
        layer.contents = (__bridge id _Nullable)([self imageWithRoundedCornersSize:CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height) andCornerRadius:40 image:self.itmeArray[i]].CGImage);
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.shadowColor = [UIColor yellowColor].CGColor;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = .8;
        layer.shadowRadius = 10;
        layer.cornerRadius = 40;
        [imageView.layer addSublayer:layer];
        
        if (0 == i) {
            continue;
        }
        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, kScale);
        
    }
    self.scrollView.contentSize = CGSizeMake(kScrollViewWidth * _itmeArray.count, kViewHeight);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.beginOffX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (_delegate && [_delegate respondsToSelector:@selector(scrolIndex:)]) {
        [self.delegate scrolIndex:index];
    }
    
    UIImageView * currImageView = [scrollView viewWithTag:kImageTag + index];
    
    UIImageView * beforeImageView = [scrollView viewWithTag:kImageTag + index - 1];
    
    UIImageView * afterImageView = [scrollView viewWithTag:kImageTag + index + 1];
    
    if (currImageView) {
        currImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }
    
    if (beforeImageView) {
        beforeImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, kScale);
    }
    
    if (afterImageView) {
        afterImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, kScale);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

//    获取当前imageview
    UIImageView * currImageView = [scrollView viewWithTag:kImageTag + self.currIndex];
//    获取前一个imageview
    UIImageView * beforeImageView = [scrollView viewWithTag:kImageTag + self.currIndex - 1];
//    获取后一个imageview
    UIImageView * afterImageView = [scrollView viewWithTag:kImageTag + self.currIndex + 1];
    
//    off_X>0时左滑
    CGFloat off_X = scrollView.contentOffset.x - _beginOffX;
    CGFloat scale = 1 - fabs(off_X / scrollView.frame.size.width);
    CGFloat endScale = 1.0;
    if (scale > 1.0) {
        endScale = 1.0;
    }else if (scale > kScale)
    {
        endScale = scale;
    }else{
        endScale = kScale;
    }
    
    if (currImageView) {
        currImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, endScale);
    }
    
    if (beforeImageView) {
        if (off_X < 0) {
            CGFloat beforeScale = 1 - scale + kScale;
            if (beforeScale > 1) {
                beforeScale = 1;
            }
//            NSLog(@"------beforescale:%f",beforeScale);
            beforeImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, beforeScale);
        }else{
            beforeImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, kScale);
        }
        
    }
    
    if (afterImageView) {
            if (off_X > 0) {
            CGFloat afterScale = 1 - scale + kScale;
            if (afterScale > 1) {
                afterScale = 1;
            }
//            NSLog(@"------afterscale:%f",afterScale);
            afterImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, afterScale);
        }
    }
}

//删除
- (void)setIsOpenDelete:(BOOL)isOpenDelete {
    _isOpenDelete = isOpenDelete;
    if (isOpenDelete) {
        UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
        panGes.delegate = self;
        [_scrollView addGestureRecognizer:panGes];
    }
}

- (void)panGes:(UIPanGestureRecognizer *)panGes {
    CGPoint velocity = [panGes velocityInView:_scrollView];
    CGPoint translation = [panGes translationInView:_scrollView];
    CGPoint location = [panGes locationInView:_scrollView];
    
    NSLog(@"velocity:%@-----translation:%@-----location:%@",NSStringFromCGPoint(velocity),NSStringFromCGPoint(translation),NSStringFromCGPoint(location));
    
    NSInteger index = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    UIImageView * currImageView = [_scrollView viewWithTag:kImageTag + index];
    
    static CGFloat currImageViewCenterY = 0;
    
    if (currImageView) {
        
        if (panGes.state == UIGestureRecognizerStateBegan) {
            currImageViewCenterY = currImageView.center.y;
        }
        
        currImageView.center = CGPointMake(currImageView.center.x, currImageViewCenterY + translation.y);
        
        if (panGes.state == UIGestureRecognizerStateEnded) {
            if (fabs(translation.y) > 200) {
                [UIView animateWithDuration:.25 animations:^{
                    currImageView.center =  CGPointMake(currImageView.center.x, -currImageViewCenterY);
                } completion:^(BOOL finished) {
                    [currImageView removeFromSuperview];
                    
                    [self removeItemIndex:index];
                }];
            }else
            {
                [UIView animateWithDuration:.25 animations:^{
                    currImageView.center = CGPointMake(currImageView.center.x, currImageViewCenterY);
                }];
            }
        }
    }
}

- (void)removeItemIndex:(NSInteger)index
{
    [self.itmeArray removeObjectAtIndex:index];
    if (_delegate && [_delegate respondsToSelector:@selector(scrolIndex:)]) {
        [_delegate scrolIndex:index >= self.itmeArray.count ? index - 1 : index];
    }
    
    if (self.itmeArray.count >= index) {
        self.scrollView.contentSize = CGSizeMake(kScrollViewWidth * _itmeArray.count, kViewHeight);
        
        for (NSInteger i = index + 1; i <= self.itmeArray.count; i ++) {
            UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:kImageTag + i];
            if (imageView) {
                
                [UIView animateWithDuration:.25 animations:^{
                    if (index + 1 == i) {
                        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                    }
                    imageView.center = CGPointMake(imageView.center.x - kScrollViewWidth, imageView.center.y);
                } completion:^(BOOL finished) {
                    imageView.tag -= 1;
                }];
            }
        }
        
        if (1 == self.itmeArray.count) {
            UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:kImageTag];
            if (imageView) {
                [UIView animateWithDuration:.25 animations:^{
                    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                }];
            }
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer * panGes = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint translation = [panGes translationInView:_scrollView];
        if (self.deleteStyle == TXScrollViewDeleteStyleSlideUp) {
            if (translation.y < 0) {
                return YES;
            }
        }else {
            if (translation.y > 0) {
                return YES;
            }
        }
    }
    return NO;
}


- (UIImage *)imageWithRoundedCornersSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius image:(UIImage *)image
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    //    CGRect rect = CGRectMake(0.f, 0.f, sizeToFit.width, sizeToFit.height);
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [image drawInRect:rect];
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
