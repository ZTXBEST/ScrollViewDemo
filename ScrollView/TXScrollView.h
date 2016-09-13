//
//  TXScrollView.h
//  ScrollView
//
//  Created by 赵天旭 on 16/9/13.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TXScrollViewDelegate <NSObject>

- (void)scrolIndex:(NSInteger)index;

@end

@interface TXScrollView : UIView


@property (nonatomic, weak) id <TXScrollViewDelegate>delegate;
//数据源
@property (nonatomic, strong) NSMutableArray * itmeArray;
//开启上滑删除
@property (nonatomic, assign) BOOL isOpenDelete;

@end
