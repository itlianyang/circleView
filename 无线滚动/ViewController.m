//
//  ViewController.m
//  无线滚动
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "LYCircleView.h"
@interface ViewController ()<LYcircleViewDelegate>
@property (nonatomic, copy)NSMutableArray *ImageViewArray;
@end

@implementation ViewController
- (NSMutableArray *)ImageViewArray{
    if (!_ImageViewArray) {
        _ImageViewArray = [NSMutableArray array];
    }
    return _ImageViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     CGFloat circleViewWeith = [UIScreen mainScreen].bounds.size.width;
    for (NSUInteger i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, circleViewWeith, 200)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"m%lu",i+1]];
        [self.ImageViewArray addObject:imageView];
    }
    LYCircleView * circleview = [[LYCircleView alloc]initWithFrame:CGRectMake(0, 0, circleViewWeith, 200) animationDuration:2];
    
    circleview.delegate = self;
    //    circleview.backgroundColor = [UIColor redColor];
    [self.view addSubview:circleview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfContentViewsInCircleView:(LYCircleView *)circleView{
    return self.ImageViewArray.count;
}

- (UIView *)circleView:(LYCircleView *)circleView contentViewAtIndex:(NSInteger)index{
    
    return self.ImageViewArray[index];
}

- (void)circleView:(LYCircleView *)circleView currentContentViewAtIndex:(NSInteger)index{
}

- (void)circleView:(LYCircleView *)circleView didSelectContentViewAtIndex:(NSInteger)index{

}

@end
