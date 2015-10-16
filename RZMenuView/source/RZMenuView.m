//
//  RZMenuView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  优惠券列表过滤控件 reyzhang

#import "RZMenuView.h"
#import "UIView+frame.h"
#import "NSString+UtilString.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface RZMenuView ()
@property (nonatomic) UIView *tabsView;   /////组装及显示tabs的视图“容器”
@property (nonatomic) UIView *contentView;  ////显示内容的视图

////接收所有的tabs,contents 的数据源
@property (nonatomic) NSMutableArray *tabs;
@property (nonatomic) NSMutableArray *contents;

//////options
@property (nonatomic) NSNumber *tabHeight;  /////接收指定的tab高度
@property (nonatomic) NSNumber *tabWidth;  /////计算得到指定的tab宽度
@property (nonatomic) NSUInteger tabCount;  ////计算得到所有的tab的总数
@property (nonatomic) NSUInteger activeTabIndex; ////当前活动的tab索引
@property (nonatomic) NSUInteger activeContentIndex;   ////当前活动的内容索引

@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;
@property (getter = isDefaultSetupDone, assign) BOOL defaultSetupDone;

// Colors
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *tabsViewBackgroundColor;
@property (nonatomic) UIColor *contentViewBackgroundColor;


@end

@implementation RZMenuView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultSettings];
    }
    return self;
}

-(void)defaultSettings {
    
    self.animatingToTab = NO;
    self.defaultSetupDone = NO;
}

#pragma mark -- Public Method
-(void)reloadData {
    // Empty all options
    _tabHeight = nil;
    _tabWidth = nil;
    
    _activeContentIndex = -1;
    _activeTabIndex = -1;
    
    // Empty all colors
    _indicatorColor = nil;
    _tabsViewBackgroundColor = nil;
    _contentViewBackgroundColor = nil;
    
    // Call to setup again with the updated data
    [self defaultSetup];
    
}


-(void)defaultSetup {
    /////移除所有的tabView
    for(MenuTabView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    
    /////清空数组中的元素，完成内存释放
    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];
    
    self.tabCount = [self.dataSource numberOfTabsForMenuView:self];   //////从委托方法中得到tab的数量
    
    /////构造tabs数据，缓存tabView
    self.tabs = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (int i=0 ; i<self.tabCount; i++) {
        [self.tabs addObject:[NSNull null]];
    }
    
    //////构造contents的数据,缓存contentView
    self.contents = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (int i=0 ; i<self.tabCount; i++) {
        [self.contents addObject:[NSNull null]];
    }
    
    
    ////创建tabs容器 reyzhang
    self.tabsView  = (UIView *)[self viewWithTag:kTabViewTag];
    if (!self.tabsView) {
        /////创建tabsView
        self.tabsView = [[UIView alloc]
                         initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), [self.tabHeight floatValue])];
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth; /////旋转时自动拉伸宽度
        self.tabsView.tag = kTabViewTag;
        self.tabsView.backgroundColor = self.tabsViewBackgroundColor;
        [self addSubview:self.tabsView];  //////添加到子视图
        
    }
    
    //    CGFloat contentSizeWidth = 0;
    //////将TabView 添加到self.tabsView上，完成tabbar的创建
    for (NSUInteger i = 0 ; i<self.tabCount; i++) {
        MenuTabView *tabView = [self tabViewAtIndex:i];
        [tabView setBackgroundColor:[UIColor clearColor]];
        CGRect frame = tabView.frame;
        frame.origin.x = i*[self.tabWidth floatValue];
        frame.size.width = [self.tabWidth floatValue];
        frame.size.height = [self.tabHeight floatValue];
        
        tabView.frame = frame;
        [self.tabsView addSubview:tabView]; /////添加到子视图
        
        ////添加按下去的手势
        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
    
    ///////构造self.contentView
    self.contentView = [self viewWithTag:kContentViewTag];
    if (!self.contentView) {
        self.contentView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabsView.frame), self.bounds.size.width, ScreenSize.height-[self.tabHeight floatValue])];
        self.contentView.autoresizingMask  = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = self.contentViewBackgroundColor;
        self.contentView.tag = kContentViewTag;
        
        [self insertSubview:self.contentView belowSubview:self.tabsView];
        self.contentView.hidden = YES;
//        self.contentView.userInteractionEnabled = NO;
    }

    /////更新状态，表示设置完成
    self.defaultSetupDone = YES;
    
}


-(MenuTabView *)tabViewAtIndex:(NSUInteger)index {
    
    if (index >= self.tabCount || index ==-1) {
        return nil;
    }
    
    if ([[self.tabs objectAtIndex:index] isEqual:[NSNull null]]) {
        
        // Get view from dataSource
        MenuTabView *tabView = (MenuTabView *)[self.dataSource menuView:self viewForTabAtIndex:index];
        tabView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // Replace the null object with tabView
        [self.tabs replaceObjectAtIndex:index withObject:tabView]; /////替换缓存中的对象
    }
    
    return [self.tabs objectAtIndex:index];
}


-(UIView *)contentViewAtIndex:(NSUInteger)index {
    
    if (index >= self.tabCount) {
        return nil;
    }
    
    if ([[self.contents objectAtIndex:index] isEqual:[NSNull null]]) {
        // Get view from dataSource
        UIView *contentView = [self.dataSource menuView:self contentViewControllerForTabAtIndex:index];
        [contentView sizeToFit];
        
        
        [self.contents replaceObjectAtIndex:index withObject:contentView]; /////替换缓存中的对象
    }
    
    return [self.contents objectAtIndex:index];
}



#pragma mark --IBAction
-(void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIView *tabView = tapGestureRecognizer.view;
    
    __block NSUInteger index = [self.tabs indexOfObject:tabView];
    
//    self.activeTabIndex = index;  ///setter 中有处理逻辑 reyzhang
//    self.activeContentIndex = index;
    
    ///不重复执行的判断
    if (self.activeTabIndex != index) {
        self.activeTabIndex = index;  ///setter 中有处理逻辑 reyzhang
        self.activeContentIndex = index;
    }else {
        if (self.contentView.hidden) {
            self.activeTabIndex = index;  ///setter 中有处理逻辑 reyzhang
            self.activeContentIndex = index;

        }else {
            [self dismiss:YES];
        }
        
    }
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        
        UIView *cView  = [self contentViewAtIndex:self.activeContentIndex];
        [UIView animateWithDuration:0.3f animations:^{
            [cView setTop:-cView.height];
            self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        } completion:^(BOOL finished) {
            self.contentView.hidden = YES;
        }];
    }else {
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.contentView.hidden = true;
    }
    [self setHeight:self.tabHeight.floatValue];
    
}

#pragma mark -- Setter
-(void)setActiveTabIndex:(NSUInteger)activeTabIndex {
    
    ///old 以前的对象
    MenuTabView *activeTabView;
    activeTabView = [self tabViewAtIndex:self.activeTabIndex]; ////根据索引从缓存中取是一个TabView实例
    activeTabView.selected = NO;
    
    ///new 新的对象
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    activeTabView.indicatorColor = self.indicatorColor;
    activeTabView.selected = YES;  //////这时会重绘indicator.
    
    _activeTabIndex = activeTabIndex ; /////给成员变量赋值。
    
    if ([self.delegate respondsToSelector:@selector(menuView:didChangeTabToIndex:)]) {
        [self.delegate menuView:self didChangeTabToIndex:_activeTabIndex];
    }
    
 
}

-(void)setActiveContentIndex:(NSUInteger)activeContentIndex {

    ///先清除原有内容 reyzhang
    for(UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *act_view;
    act_view = [self contentViewAtIndex:activeContentIndex];
    
    
    ////如果是隐藏状态，显示时加动画效果
    if (self.contentView.hidden) {
        [act_view setTop:-act_view.height];
        [UIView animateWithDuration:0.3f animations:^{
            [act_view setTop:0];
            [self.contentView addSubview:act_view];
            self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }];
    }
    else {
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [act_view setTop:0];
        [self.contentView addSubview:act_view];
    }
    self.contentView.hidden = NO;
    [self setHeight:ScreenSize.height];
   
    _activeContentIndex = activeContentIndex;
}


#pragma mark --Getter
-(NSNumber *)tabHeight {
    if (!_tabHeight) {
        CGFloat value = kTabHeight;
        if ([self.delegate respondsToSelector:@selector(heightForTabInMenuView:)])
            value = [self.delegate heightForTabInMenuView:self];  /////从委托方法中获取
        self.tabHeight = [NSNumber numberWithFloat:value];  /////setter
    }
    return _tabHeight;
}

-(NSNumber *)tabWidth {
    if (!_tabWidth) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGFloat width = bounds.size.width/self.tabCount;
        self.tabWidth = [NSNumber numberWithFloat:width];
    }
    
    return _tabWidth;
}

- (UIColor *)indicatorColor {
    
    if (!_indicatorColor) {
        UIColor *color = RGBA(66, 148, 0, 1);
        if ([self.delegate respondsToSelector:@selector(menuView:colorForComponent:withDefault:)]) {
            color = [self.delegate menuView:self colorForComponent:MenuViewIndicator withDefault:color];
        }
        self.indicatorColor = color;
    }
    return _indicatorColor;
}

-(UIColor *)tabsViewBackgroundColor {
    if (!_tabsViewBackgroundColor) {
        UIColor *color = RGBA(245, 245, 245, 1);
        if ([self.delegate respondsToSelector:@selector(menuView:colorForComponent:withDefault:)]) {
            color = [self.delegate menuView:self colorForComponent:MenuViewTab withDefault:color];
        }
        self.tabsViewBackgroundColor = color;
    }
    return  _tabsViewBackgroundColor;
}

- (UIColor *)contentViewBackgroundColor {
    
    if (!_contentViewBackgroundColor) {
        UIColor *color = RGBA(120, 120, 120, 0.7);
        if ([self.delegate respondsToSelector:@selector(menuView:colorForComponent:withDefault:)]) {
            color = [self.delegate menuView:self colorForComponent:MenuViewContent withDefault:color];
        }
        self.contentViewBackgroundColor = color;
    }
    return _contentViewBackgroundColor;
}


@end

