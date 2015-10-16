//
//  MenuTabView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  菜单顶部项的创建 reyzhang

#import "MenuTabView.h"
#import "UIView+frame.h"
#import "NSString+UtilString.h"

@interface MenuTabView ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation MenuTabView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (instancetype)createWithBuilder:(MenuTabBuilderBlock)block {
    NSParameterAssert(block);
    MenuTabViewBuilder *builder = [[MenuTabViewBuilder alloc] init];
    block(builder);
    return [builder build];
}

- (id)initWithBuilder:(MenuTabViewBuilder *)builder {
    if (self = [super init]) {
        self.indicatorColor = builder.indicatorColor;
        self.textColor = builder.textColor;
        self.selectedTextColor = builder.selectedTextColor;
        self.imageName = builder.imageName;
        self.selectedImageName = builder.selectedImageName;
        self.title = builder.title;
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ////position
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = self.textColor;
    UIImage *image = [UIImage imageNamed:self.imageName];
    self.imageView.image = image;
    self.imageView.frame = CGRectMake((self.bounds.size.width-image.size.width)/2, self.bounds.size.height/6, image.size.width, image.size.height);
    
    CGFloat width = [self.title stringWidthWith:13];
    CGFloat height = [self.title stringHeightWith:13 width:width];
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-width)/2, CGRectGetMaxY(self.imageView.frame)+3, width, height);
}

-(void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.titleLabel.textColor = self.selectedTextColor;
        self.imageView.image = [UIImage imageNamed:self.selectedImageName];
    }else {
        self.titleLabel.textColor= self.textColor;
        self.imageView.image = [UIImage imageNamed:self.imageName];
    }
    
    _selected = selected;
    [self setNeedsDisplay]; ////当状态改变时重绘view
}

-(void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    /////绘制顶部的线
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    /////绘制底部的线
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    /////根据选中的状态isSelected绘制颜色为indicatorColor的线
    if(self.selected) {
        bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect)-1.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - 1.0)];
        [bezierPath setLineWidth:2.0];
        //        [[UIColor redColor] setStroke];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}



#pragma mark GETTER
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end


@implementation MenuTabViewBuilder

- (MenuTabView *)build {
    return [[MenuTabView alloc] initWithBuilder:self];
}

@end
