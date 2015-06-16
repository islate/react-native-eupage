//
//  SlateWebImageView.h
//  WebImage
//
//  Created by yizelin on 13-7-10.
//  Copyright (c) 2013年 yizelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlateWebImageViewDelegate;

/**
 *  网络图片视图类
 */
@interface SlateWebImageView : UIView

@property (nonatomic, weak) id<SlateWebImageViewDelegate> delegate;

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) id            userInfo;
@property (nonatomic, strong) UIImage       *placeHolderImage;
@property (nonatomic, strong) UIImage       *placeHolderImageSmall;
@property (nonatomic, assign) CGFloat       placeHolderImageBoundary;
@property (nonatomic, strong) NSString      *url;

@property (nonatomic, assign) BOOL          progressiveDownload;
@property (nonatomic, assign) BOOL          fadeIn;
@property (nonatomic, assign) BOOL          useActivityIndicator;

+ (void)setDefaultUseActivityIndicator:(BOOL)useActivityIndicator;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImage:(UIImage *)image;

- (void)prepareForReuse;

@end

@protocol SlateWebImageViewDelegate <NSObject>
@optional

- (void)slateWebImageLoaded:(SlateWebImageView *)webImageView;

@end

typedef void(^SlateWebImageViewCompletedBlock)(UIImage *image, NSError *error);

@interface SlateWebImageView (cacheAndDownload)

// cache
+ (void)setImageForURL:(NSURL *)url withData:(NSData *)data;
+ (void)setImageForURL:(NSURL *)url withImage:(UIImage *)image;
+ (UIImage *)imageForURL:(NSURL *)url;

// download
+ (void)downloadImageWithURL:(NSURL *)url completed:(SlateWebImageViewCompletedBlock)completedBlock;
+ (void)downloadImageWithURL:(NSURL *)url highPriority:(BOOL)highPriority completed:(SlateWebImageViewCompletedBlock)completedBlock;

@end

@interface UIImageView (SlateWebImage)

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;

@end

@interface SlateWebImageView (VideoEmbed)

- (void)setVideoWithURL:(NSURL *)videoURL coverImageURL:(NSURL *)coverImageURL;

- (void)play;
- (void)stop;

- (void)pause;
- (void)resume;

- (BOOL)hasVideo;
- (NSURL *)videoURL;

- (void)setVoiceButton:(UIView *)voiceButton;
- (void)setMuted:(BOOL)muted;
- (BOOL)muted;

@end

@interface UIButton (SlateWebImage)

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder forState:(UIControlState)state;
- (void)setBackgroundImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder forState:(UIControlState)state;

@end

