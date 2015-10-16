//
//  RZMenuView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  优惠券列表过滤控件 reyzhang

#import <UIKit/UIKit.h>
#import "MenuTabView.h"

typedef NS_ENUM(NSUInteger, RZMenuViewComponent) {
    MenuViewIndicator, ///选中后的指示颜色
    MenuViewTab,  ///tab的颜色
    MenuViewContent  ///内容的背景
};

@protocol RZMenuViewDataSource;
@protocol RZMenuViewDelegate;

///static const
static NSInteger const kTabViewTag = 308;
static CGFloat const kTabHeight = 44;
static NSInteger const kContentViewTag = 309;

@interface RZMenuView : UIView
@property (weak) id<RZMenuViewDataSource> dataSource;
@property (weak) id<RZMenuViewDelegate> delegate;

//////加载数据
-(void)reloadData;
- (void)dismiss:(BOOL)animated;
@end



#pragma mark RZMenuViewDataSource
@protocol RZMenuViewDataSource <NSObject>

/////返回tabs的数量
-(NSUInteger)numberOfTabsForMenuView:(RZMenuView *)menuView;

/////返回每个tab上显示的内容
-(UIView *)menuView:(RZMenuView *)menuView viewForTabAtIndex:(NSUInteger)index;


/////提供内容相关的控制器
-(UIView *)menuView:(RZMenuView *)menuView contentViewControllerForTabAtIndex:(NSUInteger)index;

@end



#pragma mark RZMenuViewDelegate
@protocol RZMenuViewDelegate <NSObject>

@optional
-(CGFloat)heightForTabInMenuView:(RZMenuView *)menuView;

//////事件，tab切换后触发
-(void)menuView:(RZMenuView *)menuView didChangeTabToIndex:(NSUInteger)index;

/////监听这个回调可以得到从哪个tab到哪个tab
- (void)menuView:(RZMenuView *)menuView didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex;

//////返回三个组件的颜色，选中时的指示颜色，tabView的背景颜色，contentView的背景颜色
- (UIColor *)menuView:(RZMenuView *)menuView colorForComponent:(RZMenuViewComponent)component withDefault:(UIColor *)color;


//////数据有返回时的处理
- (void)menuView:(RZMenuView *)menuView didChangeValueToIndex:(NSUInteger)index data:(id)data;

@end