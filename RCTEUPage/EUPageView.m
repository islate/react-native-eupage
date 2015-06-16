//
//  EUPageView.m
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUPageView.h"
#import "EUBaseModel.h"
#import "EUPageViewCell.h"
#import "EUWebPageViewCell.h"
#import "EUImagePageViewCell.h"
#import "EUVideoPageViewCell.h"

@implementation EUPageView
@synthesize timer;

-(instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)showDirection
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = showDirection;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [self addSubview:_collectionView];
        self.scrollDirection = showDirection;

        reuseSet = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.needCycleShow)
    {
        dataSourceCount = [self getRealCellCount]*3;
    }
    else
    {
        dataSourceCount = [self getRealCellCount];
    }
    return dataSourceCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EUPageViewCell *cell = nil;
    
    if ([self getRealCellCount] > 0)
    {
        if ([self.dataSource respondsToSelector:@selector(modelForItemAtRow:)])
        {
            EUBaseModel *cellDataModel = [self.dataSource modelForItemAtRow:[self getRealIndexPath:indexPath].row];
            
            // 动态注册cell
            NSString *cellClass = cellDataModel.reuseIdentifier;
            if (![reuseSet containsObject:cellClass])
            {
                if (NSClassFromString(cellClass))
                {
                    [collectionView registerClass:NSClassFromString(cellClass) forCellWithReuseIdentifier:cellClass];
                }
                [reuseSet addObject:cellClass];
            }
            
            cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellDataModel.reuseIdentifier forIndexPath:indexPath];
            
            [cell loadDataWithModel:cellDataModel];
        }
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.needCycleShow)
    {
        NSIndexPath *changeIndexPath = nil;
        if (indexPath.row == dataSourceCount-1)
        {
            changeIndexPath = [NSIndexPath indexPathForRow:[self getRealCellCount]-1 inSection:0];
        }
        else if (indexPath.row == 0)
        {
            changeIndexPath = [NSIndexPath indexPathForRow:[self getRealCellCount] inSection:0];
        }
        
        if (changeIndexPath)
        {
            [self.collectionView scrollToItemAtIndexPath:changeIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
 
    if ([cell isKindOfClass:[EUPageViewCell class]])
    {
        EUPageViewCell *currentCell = (EUPageViewCell *)cell;
        [currentCell cellWillDisplayAtIndexPath:[self getRealIndexPath:indexPath]];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:willDisplayCell:forItemAtRow:)])
    {
        [self.delegate pageView:self willDisplayCell:(EUPageViewCell *)cell forItemAtRow:indexPath.row];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[EUPageViewCell class]])
    {
        EUPageViewCell *currentCell = (EUPageViewCell *)cell;
        [currentCell cellDidEndDisPlayAtIndexPath:[self getRealIndexPath:indexPath]];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:didEndDisplayingCell:forItemAtRow:)])
    {
        [self.delegate pageView:self didEndDisplayingCell:(EUPageViewCell *)cell forItemAtRow:indexPath.row];
    }
}

#pragma mark - collectionViewLayoutDirection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - private

- (NSInteger)getRealCellCount
{
    NSInteger cellCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItems)])
    {
        cellCount = [self.dataSource numberOfItems];
    }
    return cellCount;
}


- (NSIndexPath *)getRealIndexPath:(NSIndexPath *)cellIndexPath
{
    NSIndexPath *realIndexPath = cellIndexPath;
    if ([self getRealCellCount] > 0)
    {
        NSInteger index = cellIndexPath.row % [self getRealCellCount];
        realIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    return realIndexPath;
}


-(void)willTransitionToSize:(CGSize)size
{
    BOOL ishorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);
    NSInteger pageIndex = 0;
    
    if (self.collectionView.frame.size.width != 0 && self.collectionView.frame.size.height != 0)
    {
        if (ishorizontal)
        {
            pageIndex = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
        }
        else
        {
            pageIndex = self.collectionView.contentOffset.y/self.collectionView.frame.size.height;
        }
    }
    self.collectionView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.collectionView reloadData];
    
    if (ishorizontal)
    {
       [self.collectionView setContentOffset:CGPointMake(pageIndex*self.collectionView.frame.size.width, 0)];
    }
    else
    {
       [self.collectionView setContentOffset:CGPointMake(0, pageIndex*self.collectionView.frame.size.height)];
    }
}

#pragma mark - AutoScrollMethod

- (void)setPageTime:(NSTimeInterval)pageTime
{
    _pageTime = pageTime;
    [self startAutoScroll];
}

- (void)startAutoScroll
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pageTime target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopAutoScroll
{
    [self.timer invalidate];
}

- (void)handleTimer:(NSTimer *)aTimer
{
    if (![NSThread isMainThread])
    {
        [self.timer invalidate];
        return;
    }
    
    if (self.collectionView.tracking || self.collectionView.dragging || self.collectionView.decelerating)
    {
        return;
    }
    
    if ([self getRealCellCount]< 3)
    {
        return;
    }
    
    BOOL ishorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);
    NSInteger pageIndex = 0;
    
    if (self.collectionView.frame.size.width != 0 && self.collectionView.frame.size.height != 0)
    {
        if (ishorizontal)
        {
            pageIndex = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
        }
        else
        {
            pageIndex = self.collectionView.contentOffset.y/self.collectionView.frame.size.height;
        }
    }
    
    if (pageIndex == ([self getRealCellCount]*3-1))
    {
        pageIndex = -1;
    }
    
    NSInteger nextPage = pageIndex + 1;
    NSIndexPath *nextPageIndex = [NSIndexPath indexPathForRow:nextPage inSection:0];
    
    BOOL useAnimation = NO;
    if (nextPage == 1)
    {
        useAnimation = NO;
    }
    else
    {
        useAnimation = YES;
    }
    
    [self.collectionView scrollToItemAtIndexPath:nextPageIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:useAnimation];
}

@end
