//
//  MenuTabView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  菜单顶部项的创建 reyzhang

#import <UIKit/UIKit.h>
@class MenuTabViewBuilder;
typedef void(^MenuTabBuilderBlock) (MenuTabViewBuilder *builder);

@interface MenuTabView : UIView
@property (nonatomic,getter=isSelected) BOOL selected; ////标识是否处于选中状态


////样式property
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selectedTextColor;  ///选中时的文本颜色
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *selectedImageName; ////选中时的图片名称

///create instance
+ (instancetype)createWithBuilder:(MenuTabBuilderBlock)block;
- (id)initWithBuilder:(MenuTabViewBuilder *)builder;
@end


///辅助构造器 reyzhang
@interface MenuTabViewBuilder : NSObject
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selectedTextColor;  ///选中时的文本颜色
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *selectedImageName; ////选中时的图片名称

///工厂，返回实例
- (MenuTabView *) build;

@end