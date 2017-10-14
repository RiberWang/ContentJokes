//
//  RBMyScrollVIew.h
//  Content Jokes
//
//  Created by riber on 15/12/21.
//  Copyright © 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    left,
    right,
    center
}pageControlAliment;

@interface RBMyScrollVIew : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *imagesArray;

@end
