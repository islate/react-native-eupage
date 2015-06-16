//
//  RCTEUPageView.m
//  RCTEUPage
//
//  Created by linyize on 15/6/10.
//  Copyright (c) 2015年 Facebook. All rights reserved.
//

#import "RCTEUPageView.h"

#import "RCTEventDispatcher.h"
#import "RCTUIManager.h"
#import "RCTUtils.h"
#import "UIView+React.h"
#import "EUBaseModel.h"

@implementation RCTEUPageView
{
  RCTEventDispatcher *_eventDispatcher;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
  CGRect frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  if ((self = [super initWithFrame:frame]))
  {
    _eventDispatcher = eventDispatcher;
    _pageView = [[EUPageView alloc] initWithFrame:frame scrollDirection:UICollectionViewScrollDirectionHorizontal];
    _pageView.delegate = self;
    _pageView.dataSource = self;
    _pageView.needCycleShow = YES;
    [self addSubview:_pageView];
  }
  return self;
}

#pragma mark - EUPageViewDelegate

- (void)pageView:(EUPageView *)pageView willDisplayCell:(EUPageViewCell *)cell forItemAtRow:(NSInteger)row
{
  // todo: 用eventDispatcher发送事件给js端
  //[_eventDispatcher sendInputEventWithName:@"" body:@{}];
}

- (void)pageView:(EUPageView *)pageView didEndDisplayingCell:(EUPageViewCell *)cell forItemAtRow:(NSInteger)row
{
  // todo: 用eventDispatcher发送事件给js端
  //[_eventDispatcher sendInputEventWithName:@"" body:@{}];
}

#pragma mark - EUPageViewDataSource

- (NSInteger)numberOfItems
{
  return _dataArray.count;
}

- (EUBaseModel *)modelForItemAtRow:(NSInteger)row
{
  EUBaseModel *model = nil;
  
  if (row < self.dataArray.count)
  {
    NSDictionary *rowdata = [self.dataArray objectAtIndex:row];
    NSString *url = [rowdata objectForKey:@"url"];
    model = [[EUBaseModel alloc] init];
    model.resourceUrl = url;
    model.cellType = CellTypeWeb;
  }
  
  return model;
}


-(void)setDataArray:(NSArray *)dataArray
{
  _dataArray = dataArray;
  
  [_pageView.collectionView reloadData];
}
@end
