//
//  ViewController.m
//  RZMenuView
//
//  Created by hhkx002 on 15/10/16.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//

#import "ViewController.h"
#import "RZMenuView.h"
#import "MenuTabView.h"
#import "TagContainerView.h"
#import "UIView+frame.h"



#define ScreenSize [UIScreen mainScreen].bounds.size
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()<RZMenuViewDataSource,RZMenuViewDelegate>
@property (nonatomic,strong) NSArray *menuData;
@property (nonatomic,strong) NSArray *menuContentData;
@property (nonatomic,strong) RZMenuView *menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"RZMenuView Demo";
    
    self.menuData = @[@{@"title":@"一线城市",@"img":@"landmark",@"sel_img":@"landmark_select"},
                      @{@"title":@"菏泽县级",@"img":@"type",@"sel_img":@"type_select"},
                      @{@"title":@"青岛市区",@"img":@"printIcon",@"sel_img":@"printIcon_select"}];
    self.menuContentData = @[@[@"北京",@"上海",@"深圳",@"广州",@"天津"],@[@"菏泽市",@"巨野县",@"郓城县",@"单县",@"曹县",@"东明县",@"定陶县",@"成武县",@"鄄城县"],@[@"市南区",@"市北区",@"李沧区",@"崂山区",@"城阳区",@"黄岛区"]];
    
    [self.view addSubview:self.menuView];
    [self.menuView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RZMenuViewDatasource
/////返回tabs的数量
-(NSUInteger)numberOfTabsForMenuView:(RZMenuView *)menuView {
    return 3;
}

/////返回每个tab上显示的内容
-(UIView *)menuView:(RZMenuView *)menuView viewForTabAtIndex:(NSUInteger)index {
    id data = self.menuData[index];
    MenuTabView *tabView =  [MenuTabView createWithBuilder:^(MenuTabViewBuilder *builder) {
        builder.textColor = RGBA(124, 132, 112, 1);
        builder.selectedTextColor = RGBA(103, 155, 43, 1);
        builder.imageName = data[@"img"];
        builder.selectedImageName = data[@"sel_img"];
        builder.title = data[@"title"];
    }];
    return tabView;
}


/////提供内容相关的控制器
-(UIView *)menuView:(RZMenuView *)menuView contentViewControllerForTabAtIndex:(NSUInteger)index {
    NSArray *items = self.menuContentData[index];
    
    TagContainerView *view = [[TagContainerView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    view.backgroundColor = [UIColor whiteColor];
    view.items = items;
    [view reloadData];
    [view setHeight:[TagContainerView getHeight:items]];
    return view;
}

#pragma mark RZMenuViewDelegate
- (CGFloat)heightForTabInMenuView:(RZMenuView *)menuView {
    return 55;
}

//////事件，tab切换后触发
-(void)menuView:(RZMenuView *)menuView didChangeTabToIndex:(NSUInteger)index {
}


//////返回三个组件的颜色，选中时的指示颜色，tabView的背景颜色，contentView的背景颜色
- (UIColor *)menuView:(RZMenuView *)menuView colorForComponent:(RZMenuViewComponent)component withDefault:(UIColor *)color{
    switch (component) {
        case MenuViewIndicator:
            return RGBA(107, 161, 39, 1);
        case MenuViewTab:
            return RGBA(245, 245, 245, 1);
        case MenuViewContent:
            return RGBA(0, 0, 0, 0.5);
        default:
            return color;
    }
    
}

///当index下的数据发生改变时触发 reyzhang
- (void)menuView:(RZMenuView *)menuView didChangeValueToIndex:(NSUInteger)index data:(id)data {

}


#pragma mark GETTER
- (RZMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[RZMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 55)];
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}


@end
