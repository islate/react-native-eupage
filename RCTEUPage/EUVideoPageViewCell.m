//
//  EUVideoPageViewCell.m
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUVideoPageViewCell.h"
#import  "SlateWebImageView.h"
#import "EUBaseModel.h"

@implementation EUVideoPageViewCell

-(void)loadDataWithModel:(EUBaseModel *)model
{
    [super loadDataWithModel:model];
    
    if(!self.videoImageView)
    {
        _videoImageView = [[SlateWebImageView alloc] init];
        _videoImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_videoImageView];
    }
    
    self.videoImageView.frame = self.bounds;
    self.videoImageView.imageView.frame = self.bounds;
    [self.videoImageView setVideoWithURL:[NSURL URLWithString:model.resourceUrl] coverImageURL:nil];
    [self.videoImageView play];
    [self.videoImageView setMuted:NO];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.videoImageView)
    {
        [self.videoImageView stop];
        [self.videoImageView setMuted:YES];
        [self.videoImageView setVideoWithURL:nil coverImageURL:nil];
    }
}

-(void)cellWillDisplayAtIndexPath:(NSIndexPath *)indexpath
{
   
}

-(void)cellDidEndDisPlayAtIndexPath:(NSIndexPath *)indexpath
{
    [self.videoImageView setMuted:YES];
    [self.videoImageView stop];
}

@end
