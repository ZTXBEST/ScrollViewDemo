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

@interface TXScrollView()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

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
