//
//  TXScrollView.h
//  ScrollView
//
//  Created by 赵天旭 on 16/9/13.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXScrollViewDeleteStyle) {
    TXScrollViewDeleteStyleNone,
    TXScrollViewDeleteStyleSlideUp,//上滑
    TXScrollViewDeleteStylePull//下拉
};

@protocol TXScrollViewDelegate <NSObject>

/**
 *  变换背景蒙版
 */
- (void)scrolIndex:(NSInteger)index;
@end

@interface TXScrollView : UIView

@property (nonatomic, weak) id <TXScrollViewDelegate>delegate;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * itmeArray;

/**
 *  是否开启删除，默认关闭
 */
@property (nonatomic, assign) BOOL isOpenDelete;

/**
 *  删除样式,默认下拉删除
 */
@property (nonatomic, assign) TXScrollViewDeleteStyle deleteStyle;

@end
