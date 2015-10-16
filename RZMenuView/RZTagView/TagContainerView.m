//
//  TagContainerView.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/28.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  标签容器控件 reyzhang

#import "TagContainerView.h"
#import "TagView.h"
#import "UIView+frame.h"
#import "NSString+UtilString.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation TagContainerView


- (void)reloadData {

    ////remove all subviews reyzhang
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }

    CGFloat posX = 0,posY = 0;
    
    CGFloat cWidth = ScreenSize.width-15*2-20*2;  ///两边间距为15，tag之间的水平间距为20
    CGFloat perWidth = cWidth/3;
    for (int i=0; i<self.items.count;i++) {
        
        id data = self.items[i];
        posX = 15+(i%3)*(perWidth+20);  //15 is left , 20 is space
        
        TagView *tag = [TagView createWithBuilder:^(TagBuilder *builder) {
            builder.bgColor = RGBA(234, 239, 242, 1);
            builder.selectedBgColor = RGBA(106, 161, 40, 1);
            builder.textColor = RGBA(35, 39, 42, 1);
            builder.selectedTextColor = [UIColor whiteColor];
            builder.fontSize = 14;
            
        }];
        tag.allowCancel = NO;
        tag.title = data;  ///显示tag标签
        tag.data = data; ///传递多值数据
        [tag setTagTouchedBlock:^(id data, BOOL isSelected) {
            self.curData = data;
            [self cancelOthers];
        }];
        [tag sizeToFit];
        
        posY = 15+(i/3)*(tag.height+15); /// 20 is top , 15 is space
        [tag setLeft: posX];
        [tag setTop:posY];
        [tag setWidth:perWidth];
        
        [self addSubview:tag];
    }
}


///取消掉其他tag标签的选中状态 reyzhang
- (void)cancelOthers {
    for(int i =0 ;i<self.subviews.count;i++) {
        TagView *tv = (TagView *)self.subviews[i];
        if (tv.selected && [tv.data isEqual:self.curData]) {
            continue;
        }
        if (tv.selected) {
            tv.selected = NO;
            break;
        }
        
    }
}


+ (CGFloat)getHeight:(NSArray *)items {
    if (items==nil || items.count==0)
        return 0;
    
    CGFloat height = 15;
    NSInteger rowNumber = (items.count-1)/3+1;
    id data = items[0];
    NSString *title = data;
    CGFloat _width = [title stringWidthWith:14];
    CGFloat _height = [title stringHeightWith:14 width:_width]+20;
    height += rowNumber*_height;
    height +=rowNumber*15;
    return height;
}



@end
