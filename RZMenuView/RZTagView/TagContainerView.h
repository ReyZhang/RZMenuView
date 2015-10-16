//
//  TagContainerView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  标签容器控件 reyzhang

#import <UIKit/UIKit.h>

@interface TagContainerView : UIView
@property (nonatomic,strong) NSArray *items; ///数据源
@property (nonatomic,strong) NSString *titleKey;
@property (nonatomic,strong) id curData;  ///当前被选中的数据

///重新加载数据 reyzhang
- (void)reloadData;

///计算高度 reyzhang
+ (CGFloat)getHeight:(NSArray *)items;
@end
