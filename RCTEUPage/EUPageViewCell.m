//
//  UIPageViewCell.m
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUPageViewCell.h"
#import "EUBaseModel.h"

@implementation EUPageViewCell
@synthesize dataModel;
@synthesize cellSize;

- (void)loadDataWithModel:(EUBaseModel *)model
{
    self.dataModel = model;
    self.contentView.autoresizesSubviews = NO;
}

- (void)cellWillDisplayAtIndexPath:(NSIndexPath *)indexpath
{
    //  需要在子类实现
}

- (void)cellDidEndDisPlayAtIndexPath:(NSIndexPath *)indexpath
{
    // 需要在子类实现
}

- (void)updateSubViewSize:(CGSize)size
{
 // do nothing
}

@end
