//
//  TagView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/23.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  标签页控件 reyzhang

#import <UIKit/UIKit.h>


@class TagBuilder;
typedef void(^TagBuilderBlock)(TagBuilder *builder);

typedef void(^TagTouchedBlock)(id data,BOOL isSelected);
@interface TagView : UIView
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selectedTextColor; ///选中时的文本颜色
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,strong) UIColor *selectedBgColor;  ////选中时的背影色
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,strong) UIColor *selectedBrdColor; ///选中时的边框颜色
@property (nonatomic) BOOL allowCancel;  ///在选中后允许取消选中

@property (nonatomic) CGFloat fontSize; ////字体大小

////重要属性
@property (nonatomic,getter=isSelected) BOOL selected;
@property (nonatomic,strong) id data;

///block
@property (nonatomic,strong) TagTouchedBlock block;

+ (instancetype)createWithBuilder:(TagBuilderBlock)block;
- (instancetype)initWithBuilder:(TagBuilder *)builder;

- (void)setTagTouchedBlock:(TagTouchedBlock)block;

@end


@interface TagBuilder : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selectedTextColor; ///选中时的文本颜色
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,strong) UIColor *selectedBgColor;  ////选中时的背影色
@property (nonatomic) CGFloat fontSize; ////字体大小
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,strong) UIColor *selectedBrdColor; ///选中时的边框颜色

- (TagView *)build;

@end