#import <UIKit/UIKit.h>

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;

@class SDCycleScrollView;
@protocol SDCycleScrollViewDelegate <NSObject>
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
@end

@interface SDCycleScrollView : UIView

@property (nonatomic, strong) NSArray *imageURLsGroup;
@property (nonatomic, strong) NSArray *titlesGroup;
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;
@property (nonatomic, weak) id<SDCycleScrollViewDelegate> delegate;
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLsGroup:(NSArray *)imageURLsGroup;
@end
