//
//  UIPageViewCell.h
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUBaseModel.h"

@interface EUPageViewCell : UICollectionViewCell
@property (nonatomic, strong) EUBaseModel *dataModel;
@property (nonatomic, assign) CGSize      cellSize;

- (void)loadDataWithModel:(EUBaseModel *)model;
- (void)cellWillDisplayAtIndexPath:(NSIndexPath *)indexpath;
- (void)cellDidEndDisPlayAtIndexPath:(NSIndexPath *)indexpath;
- (void)updateSubViewSize:(CGSize)size;
@end
