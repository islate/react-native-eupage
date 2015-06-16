//
//  SlateWebImageView.m
//  WebImage
//
//  Created by yizelin on 13-7-10.
//  Copyright (c) 2013年 yizelin. All rights reserved.
//

#import "SlateWebImageView.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import <AVFoundation/AVFoundation.h>
#import "PBJVideoPlayerController.h"
#import "PBJVideoView.h"
#import <objc/runtime.h>

@interface SlateWebImageView ()

@property (nonatomic, strong) UIImageView   *placeholderView;
//@property (nonatomic, strong) SlateActivityIndicatorView   *activityIndicatorView;

// video
@property (nonatomic, assign) BOOL autoplay;

@end

static BOOL defaultUseActivityIndicator = NO;
static UIImage *defaultPlaceHolderImage = nil;// [UIImage imageNamed:@"misc/placeholder"];
static UIImage *defaultPlaceHolderImageSmall = nil;// [UIImage imageNamed:@"misc/general_placeholder"];
static UIImage *defaultPlaceHolderImageiPad = nil; // [UIImage imageNamed:@"misc/placeholder_ipad"];

static char SlateWebImageViewPBJVideoPlayerController;
static char SlateWebImageViewVideoURL;
static char SlateWebImageViewVoiceButton;

@interface SlateWebImageView (VideoEmbedDelegate)  <PBJVideoPlayerControllerDelegate>

- (void)setVideoURL:(NSURL *)videoURL;

- (void)setPlayer:(PBJVideoPlayerController *)player;
- (PBJVideoPlayerController *)player;

- (UIView *)voiceButton;

- (void)showVideoPlayer;
- (void)removeVideoPlayer;

@end

@implementation SlateWebImageView

+ (void)initialize
{
    [super initialize];
    
    defaultPlaceHolderImage = [UIImage imageNamed:@"misc/placeholder"];
    defaultPlaceHolderImageSmall = [UIImage imageNamed:@"misc/general_placeholder"];
    defaultPlaceHolderImageiPad = [UIImage imageNamed:@"misc/placeholder_ipad"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.placeHolderImage = defaultPlaceHolderImage;
        self.placeHolderImageSmall = defaultPlaceHolderImageSmall;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            if (defaultPlaceHolderImageiPad)
            {
                self.placeHolderImage = defaultPlaceHolderImageiPad;
            }
        }
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.placeHolderImageBoundary = 98.0f;
        self.progressiveDownload = NO;
        self.fadeIn = NO;
        self.useActivityIndicator = defaultUseActivityIndicator;
    }
    
    return self;
}

- (void)dealloc
{
    self.player.delegate = nil;
    self.player = nil;
}

- (void)updatePlaceholder
{
    if (self.placeholderView.image == nil) {
        return;
    }
    
    // 根据frame以及placeholder，判断填充模式
    if (self.frame.size.width < self.placeholderView.image.size.width
        || self.frame.size.height < self.placeholderView.image.size.height)
    {
        self.placeholderView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        self.placeholderView.contentMode = UIViewContentModeCenter;
    }
}

+ (void)setDefaultUseActivityIndicator:(BOOL)useActivityIndicator
{
    defaultUseActivityIndicator = useActivityIndicator;
}

- (void)setUseActivityIndicator:(BOOL)useActivityIndicator
{
    _useActivityIndicator = useActivityIndicator;
    
    if (useActivityIndicator)
    {
        /*
        if (self.activityIndicatorView == nil)
        {
            self.activityIndicatorView = [[SlateActivityIndicatorView alloc] initWithFrame:self.bounds];
            self.activityIndicatorView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
            self.activityIndicatorView.hidesWhenStopped = YES;
            [self.activityIndicatorView startAnimating];
            [self insertSubview:self.activityIndicatorView belowSubview:self.imageView];
        }
        */
        
        if (self.placeholderView)
        {
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        }
    }
    else
    {
        if (self.placeholderView == nil)
        {
            self.placeholderView = [[UIImageView alloc] initWithFrame:self.bounds];
            self.placeholderView.backgroundColor = [UIColor clearColor];
            self.placeholderView.contentMode = UIViewContentModeCenter;
            self.placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.placeholderView.image = [self placeHolderWithFrame:self.bounds];
            [self insertSubview:self.placeholderView belowSubview:self.imageView];
            
            [self updatePlaceholder];
        }
        
        /*
        if (self.activityIndicatorView)
        {
            [self.activityIndicatorView removeFromSuperview];
            self.activityIndicatorView = nil;
        }*/
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //self.activityIndicatorView.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
    
    [self updatePlaceholder];
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [self.imageView setContentMode:contentMode];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    
    if (image) {
        //[self.activityIndicatorView stopAnimating];
        self.placeholderView.hidden = YES;
    }
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImageWithURL:(NSURL *)url
{
    self.videoURL = nil;
    
    [self setImageWithURL:url complete:nil];
}

- (void)setImageWithURL:(NSURL *)url complete:(void(^)(void))complete
{
    if (![self.imageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:options:progress:completed:)]) {
        NSAssert(NO, @"Fatal error. Must have SDWebImage. \n");
        return;
    }
    
    if (url == nil || url.absoluteString.length == 0)
    {
        //DLog(@"SDWebImage url empty");
        [self.imageView sd_cancelCurrentImageLoad];
        self.placeholderView.image = [self placeHolderWithFrame:self.bounds];
        self.placeholderView.hidden = NO;
        //[self.activityIndicatorView startAnimating];
        self.imageView.image = nil;
        self.url = nil;
        [self updatePlaceholder];
        if (complete) {
            complete();
        }
        return;
    }
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;
    __weak id<SlateWebImageViewDelegate> weakDelegate = self.delegate;
    __weak __typeof(self) weakSelf = self;
    
    // 如果已经加载过相同图片，则不再重新加载
    if (self.imageView.image && [url.absoluteString isEqualToString:self.url]) {
        
        // 如果是gif，需要重新setImage
        if ([[self.url lowercaseString] hasSuffix:@".gif"]) {
            id oldImage = self.imageView.image;
            self.imageView.image = nil;
            self.imageView.image = oldImage;
        }
        
        [self setNeedsLayout];
        
        if (complete) {
            complete();
        }
        return;
    }
    
    if (self.progressiveDownload)
    {
        options |= SDWebImageProgressiveDownload;
    }

    self.imageView.image = nil;
    self.placeholderView.image = [self placeHolderWithFrame:self.bounds];
    self.placeholderView.hidden = NO;
    //[self.activityIndicatorView startAnimating];
    [self updatePlaceholder];

    [self.imageView sd_setImageWithURL:url
                   placeholderImage:nil
                            options:options
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                              if (error)
                              {
                                  weakSelf.imageView.image = nil;
                                  weakSelf.url = nil;
                                  
                                  if (complete) {
                                      complete();
                                  }
                                  return;
                              }
                              
                              if (weakDelegate
                                  && [weakDelegate respondsToSelector:@selector(slateWebImageLoaded:)]) {
                                  [weakDelegate slateWebImageLoaded:weakSelf];
                              }
                              
                              if (weakSelf)
                              {
                                  weakSelf.url = url.absoluteString;
                                  weakSelf.placeholderView.hidden = YES;
                                  //[weakSelf.activityIndicatorView stopAnimating];
                                  
                                  if (!weakSelf.progressiveDownload && weakSelf.fadeIn)
                                  {
                                      // 渐入效果
                                      CATransition *animation = [CATransition animation];
                                      [animation setDuration:0.3];
                                      [animation setType:kCATransitionFade];
                                      [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                                      [animation setRemovedOnCompletion:YES];
                                      [weakSelf.layer addAnimation:animation forKey:nil];
                                  }
                                  
                                  [weakSelf setNeedsLayout];
                                  
                                  if (complete) {
                                      complete();
                                  }
                              }
                          }
     ];
    
    if (self.imageView.image)
    {
        self.placeholderView.hidden = YES;
        //[self.activityIndicatorView stopAnimating];
        if (!self.progressiveDownload && self.fadeIn)
        {
            [self.layer removeAllAnimations];
        }
    }
    
    [self setNeedsLayout];
}

- (UIImage *)placeHolderWithFrame:(CGRect)frame
{
    if ((frame.size.width >= self.placeHolderImageBoundary) || (frame.size.height >= self.placeHolderImageBoundary))
    {
        return self.placeHolderImage;
    }
    else
    {
        return self.placeHolderImageSmall;
    }
}

- (void)prepareForReuse
{
    self.placeHolderImageBoundary = 98.0f;
    self.progressiveDownload = NO;
    self.fadeIn = NO;
    
    [self removeVideoPlayer];
    
    [self setImageWithURL:nil];
}

@end

@implementation SlateWebImageView (cacheAndDownload)

#pragma mark - cache

+ (void)setImageForURL:(NSURL *)url withData:(NSData *)data
{
    if (!url) {
        return;
    }
    UIImage *image = [UIImage imageWithData:data];
    NSString *cacheKey = url.absoluteString;
//    [[SDImageCache sharedImageCache] storeImage:image imageData:data forKey:cacheKey toDisk:YES];
    [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:data forKey:cacheKey toDisk:YES];
}

+ (void)setImageForURL:(NSURL *)url withImage:(UIImage *)image
{
    if (!url) {
        return;
    }
    NSString *cacheKey = url.absoluteString;
    [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKey toDisk:YES];
}

+ (UIImage *)imageForURL:(NSURL *)url
{
    if (!url) {
        return nil;
    }
    NSString *cacheKey = url.absoluteString;
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
}

#pragma mark - download

+ (void)downloadImageWithURL:(NSURL *)url completed:(SlateWebImageViewCompletedBlock)completedBlock
{
    [self downloadImageWithURL:url highPriority:NO completed:completedBlock];
}

+ (void)downloadImageWithURL:(NSURL *)url highPriority:(BOOL)highPriority completed:(SlateWebImageViewCompletedBlock)completedBlock
{
    if (!url)
    {
        return;
    }
    
    SDWebImageOptions options = (highPriority ? SDWebImageHighPriority : SDWebImageLowPriority) | SDWebImageRetryFailed;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                               options:options
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                 if (completedBlock) {
                                                     completedBlock(image, error);
                                                 }
                                              }];
}

@end

@implementation UIImageView (SlateWebImage)

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder
{
    UIImage *cachedImage = [SlateWebImageView imageForURL:imageURL];
    
    if (cachedImage)
    {
        self.image = cachedImage;
    }
    else
    {
        self.image = placeholder;
        
        __weak typeof(self) weakSelf = self;
        [SlateWebImageView downloadImageWithURL:imageURL
                                   highPriority:YES
                                      completed:^(UIImage *image, NSError *error) {
                                          if (image && !error)
                                          {
                                              weakSelf.image = image;
                                          }
                                      }];
    }
}

@end

@implementation UIButton (SlateWebImage)

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder forState:(UIControlState)state
{
    UIImage *cachedImage = [SlateWebImageView imageForURL:imageURL];
    
    if (cachedImage)
    {
        [self setImage:cachedImage forState:state];
    }
    else
    {
        [self setImage:placeholder forState:state];
        
        __weak typeof(self) weakSelf = self;
        [SlateWebImageView downloadImageWithURL:imageURL
                                   highPriority:YES
                                      completed:^(UIImage *image, NSError *error) {
                                          if (image && !error)
                                          {
                                              [weakSelf setImage:image forState:state];
                                          }
                                      }];
        
    }
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder forState:(UIControlState)state
{
    UIImage *cachedImage = [SlateWebImageView imageForURL:imageURL];
    
    if (cachedImage)
    {
        [self setBackgroundImage:cachedImage forState:state];
    }
    else
    {
        [self setBackgroundImage:placeholder forState:state];
        
        __weak typeof(self) weakSelf = self;
        [SlateWebImageView downloadImageWithURL:imageURL
                                   highPriority:YES
                                      completed:^(UIImage *image, NSError *error) {
                                          if (image && !error)
                                          {
                                              [weakSelf setBackgroundImage:image forState:state];
                                          }
                                      }];
        
    }
}

@end

@implementation SlateWebImageView (VideoEmbed)

- (void)preparePlayer
{
    PBJVideoPlayerController *player = self.player;
    if (!player) {
        player = [[PBJVideoPlayerController alloc] init];
        player.delegate = self;
        player.muted = YES; // 默认静音
        [self setPlayer:player];
    }
    
    player.view.hidden = NO;
    player.view.frame = self.imageView.bounds;
    player.videoPath = self.videoURL.absoluteString;
    player.videoFillMode = AVLayerVideoGravityResizeAspectFill;
    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    player.view.contentMode = UIViewContentModeCenter;
}

- (void)setVideoWithURL:(NSURL *)videoURL coverImageURL:(NSURL *)coverImageURL
{
    self.videoURL = videoURL;
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:coverImageURL complete:^{
        
        if (!weakSelf) {
            return;
        }
        
        __strong SlateWebImageView *strongSelf = weakSelf;
        if (strongSelf.autoplay) {
            [strongSelf preparePlayer];
        }
    }];
}

- (BOOL)hasVideo
{
    return (self.videoURL != nil);
}

- (NSURL *)videoURL
{
    NSURL *videoURL = objc_getAssociatedObject(self, &SlateWebImageViewVideoURL);
    return videoURL;
}

- (void)play
{
    self.autoplay = YES;
    
    if (self.videoURL) {
        //if (!self.player) {
            [self preparePlayer];
        //}
        
        if (self.player) {

            [self.player playFromBeginning];
            
            if (self.player.bufferingState != PBJVideoPlayerBufferingStateUnknown) {
                [self showVideoPlayer];
            }
        }
    }
}

- (void)stop
{
    self.autoplay = NO;
    
    if (self.videoURL && self.player) {
        //ALog(@"SlateWebImageView(%@) stop", self.videoURL.lastPathComponent);
        [self.player stop];
        [self.player.view removeFromSuperview];
        self.voiceButton.hidden = YES;
    }
}

- (void)resume
{
    self.autoplay = YES;
    
    if (self.videoURL) {
        if (!self.player) {
            [self preparePlayer];
        }
        
        if (self.player) {
            //ALog(@"SlateWebImageView(%@) resume", self.videoURL.lastPathComponent);
            
            [self.player playFromCurrentTime];
            
            if (self.player.bufferingState != PBJVideoPlayerBufferingStateUnknown) {
                [self showVideoPlayer];
            }
        }
    }
}

- (void)pause
{
    self.autoplay = NO;
    
    if (self.videoURL && self.player) {
        //ALog(@"SlateWebImageView(%@) pause", self.videoURL.lastPathComponent);
        [self.player pause];
    }
}

- (void)setVoiceButton:(UIView *)voiceButton
{
    objc_setAssociatedObject(self, &SlateWebImageViewVoiceButton, voiceButton, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setMuted:(BOOL)muted
{
    [self.player setMuted:muted];
}

- (BOOL)muted
{
    return [self.player muted];
}

@end

@implementation SlateWebImageView (VideoEmbedDelegate)

- (void)setVideoURL:(NSURL *)videoURL
{
    objc_setAssociatedObject(self, &SlateWebImageViewVideoURL, videoURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)voiceButton
{
    UIView *voiceButton = objc_getAssociatedObject(self, &SlateWebImageViewVoiceButton);
    return voiceButton;
}

- (void)setPlayer:(PBJVideoPlayerController *)player
{
    objc_setAssociatedObject(self, &SlateWebImageViewPBJVideoPlayerController, player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PBJVideoPlayerController *)player
{
    PBJVideoPlayerController *player = objc_getAssociatedObject(self, &SlateWebImageViewPBJVideoPlayerController);
    return player;
}

- (void)showVideoPlayer
{
    if (self.player.view.superview != self) {
        if (self.player.view.superview) {
            [self.player.view removeFromSuperview];
        }
        [self addSubview:self.player.view];
        self.voiceButton.hidden = NO;
        
        //ALog(@"SlateWebImageView(%@) showVideoPlayer", self.videoURL.lastPathComponent);
    }
}

- (void)removeVideoPlayer
{
    if (self.player) {
        //ALog(@"SlateWebImageView(%@) removeVideoPlayer", self.videoURL.lastPathComponent);
        
        self.player.delegate = nil;
        [self.player stop];
        [self.player.view removeFromSuperview];
        self.player = nil;
        self.autoplay = NO;
        self.videoURL = nil;
        self.voiceButton = nil;
    }
}

#pragma mark - PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //ALog(@"SlateWebImageView(%@) videoPlayerReady. Max duration of the video: %f", self.videoURL.lastPathComponent, videoPlayer.maxDuration);
    
    if (self.autoplay) {
        //ALog(@"SlateWebImageView(%@) autoplay ready", self.videoURL.lastPathComponent);
        [self.player playFromBeginning];
        [self showVideoPlayer];
    }
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    switch (videoPlayer.bufferingState) {
        case PBJVideoPlayerBufferingStateUnknown:
            //ALog(@"Buffering state unknown!");
            break;
            
        case PBJVideoPlayerBufferingStateReady:
            //ALog(@"Buffering state Ready! Video will start/ready playing now.");
            
            if (self.autoplay) {
                //ALog(@"SlateWebImageView(%@) autoplay buffer ready", self.videoURL.lastPathComponent);
                [self.player playFromCurrentTime];
                [self showVideoPlayer];
            }
            break;
            
        case PBJVideoPlayerBufferingStateDelayed:
            //ALog(@"Buffering state Delayed! Video will pause/stop playing now.");
            
            if (self.autoplay) {
               // ALog(@"SlateWebImageView(%@) autoplay buffer delayed", self.videoURL.lastPathComponent);
                [self.player playFromCurrentTime];
                [self showVideoPlayer];
            }
            break;
        default:
            break;
    }
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
}

@end
