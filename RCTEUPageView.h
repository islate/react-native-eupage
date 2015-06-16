//
//  RCTEUPageView.h
//  RCTEUPage
//
//  Created by linyize on 15/6/10.
//  Copyright (c) 2015年 Facebook. All rights reserved.
//

#import "RCTView.h"
#import "EUPageView.h"

@class RCTEventDispatcher;

@interface RCTEUPageView : RCTView <EUPageViewDelegate, EUPageViewDataSource>

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) EUPageView *pageView;
@property (nonatomic, copy) NSArray *dataArray;

@end
