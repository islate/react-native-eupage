//
//  EUPageView.h
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EUBaseModel;
@class EUPageViewCell;
@class EUPageView;

@protocol EUPageViewDataSource <NSObject>
@required
- (NSInteger)numberOfItems;
- (EUBaseModel *)modelForItemAtRow:(NSInteger)row;
@end

@protocol EUPageViewDelegate <NSObject>
- (void)pageView:(EUPageView *)pageView willDisplayCell:(EUPageViewCell *)cell forItemAtRow:(NSInteger)row;
- (void)pageView:(EUPageView *)pageView didEndDisplayingCell:(EUPageViewCell *)cell forItemAtRow:(NSInteger)row;
@end


@interface EUPageView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger dataSourceCount;
    NSMutableSet *reuseSet;
}
@property (nonatomic, assign) BOOL                             needCycleShow;
@property (nonatomic, assign) NSInteger                        currentPageIndex;
@property (nonatomic ,assign) NSTimeInterval                   pageTime;
@property (nonatomic ,strong) NSTimer                          *timer;
@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) UICollectionViewScrollDirection  scrollDirection;
@property (nonatomic, weak) id<EUPageViewDataSource>           dataSource;
@property (nonatomic, weak) id<EUPageViewDelegate>             delegate;

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)showDirection;

- (void)startAutoScroll;
- (void)stopAutoScroll;

- (NSInteger)getRealCellCount;
- (void)willTransitionToSize:(CGSize)size;

@end
