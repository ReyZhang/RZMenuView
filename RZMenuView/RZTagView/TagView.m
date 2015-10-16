//
//  TagView.m
//  HYWCoupon
//
//  Created by reyzhang on 15/9/23.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  标签页控件 reyzhang

#import "TagView.h"
#import "NSString+UtilString.h"



@interface TagView ()
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation TagView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

////使用block可以弱化TagBuilder的作用域， 由调用者来指初始化builder的属性 reyzhang
+ (instancetype)createWithBuilder:(TagBuilderBlock)block {
    NSParameterAssert(block);
    TagBuilder *builder = [[TagBuilder alloc] init];
    block(builder);
    return [builder build];
}

/////一般不被直接调用
- (instancetype)initWithBuilder:(TagBuilder *)builder {
    if (self = [super init]) {
        _textColor = builder.textColor;
        _selectedTextColor = builder.selectedBgColor;
        _bgColor = builder.bgColor;
        _selectedBgColor = builder.selectedBgColor;
        _fontSize = builder.fontSize;
        _borderColor = builder.borderColor;
        _selectedBrdColor = builder.selectedBrdColor;
        self.selected = NO;  ///调用 setter方法
    }
    
    return self;
}

- (void)setTagTouchedBlock:(TagTouchedBlock)block {
    _block = block;
}

- (void)commonInit {
    
    self.layer.cornerRadius = 3;
    
    [self addSubview:self.titleLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    
    CGFloat width = [self.title stringWidthWith:self.fontSize];
    CGFloat height = [self.title stringHeightWith:self.fontSize width:width];
    
    self.titleLabel.frame = CGRectMake((bounds.size.width - width)/2, (bounds.size.height-height)/2, width, height);
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    CGFloat width = [self.title stringWidthWith:self.fontSize];
    CGFloat height = [self.title stringHeightWith:self.fontSize width:width];
    
    fitSize.width= width + 40;
    fitSize.height = height + 20;
    
    return fitSize;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = (UITouch *)[touches anyObject];
//    CGPoint point = [touch locationInView:self];
    
    if (_allowCancel) {
        ////设置控件的选中与不选中的状态 reyzhang
        self.selected ^= 1;  ////会触发selected属性的setter方法
    }else {
        if (self.selected)
            return;
        self.selected = YES;
    }
    ////传递tagview的touch事件给它的响应者 reyzhang
//    [self routerEventWithName:kTagViewTouchEvent userInfo:@{@"title":self.title}];
    if (self.block) {
        self.block(self.data,self.isSelected);
    }
    
}

#pragma mark GETTER
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];  ////默认大小
    }
    return _titleLabel;
}

- (CGFloat)fontSize {
    if (_fontSize == 0) {
        _fontSize = 14;   ////默认大小
    }
    return  _fontSize;
}

#pragma mark SETTER
- (void)setSelected:(BOOL)selected {
    
    ///设置选中
    if (selected) {
        self.backgroundColor = self.selectedBgColor;
        self.titleLabel.textColor = [UIColor whiteColor];
        if (self.selectedBrdColor) {
            self.layer.borderColor = self.selectedBrdColor.CGColor;
            self.layer.borderWidth =1;
        }
    }else {
        self.backgroundColor = self.bgColor;
        self.titleLabel.textColor = self.textColor;
        if (self.borderColor) {
            self.layer.borderColor = self.borderColor.CGColor;
            self.layer.borderWidth = 1;
        }
    }
    _selected = selected; ////更新值
}

@end

@implementation TagBuilder


- (TagView *)build {
    return [[TagView alloc] initWithBuilder:self];
}

@end
