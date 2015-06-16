//
//  EUImagePageViewCell.m
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUImagePageViewCell.h"
#import "SlateWebImageView.h"
#import "EUBaseModel.h"

@implementation EUImagePageViewCell

-(void)loadDataWithModel:(EUBaseModel *)model
{
    [super loadDataWithModel:model];
    
    if(!self.imageView)
    {
        _imageView = [[SlateWebImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    self.imageView.frame = self.bounds;
    [self.imageView setImageWithURL:[NSURL URLWithString:model.resourceUrl]];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.imageView)
    {
        [self.imageView setImageWithURL:nil];
    }
}

@end
