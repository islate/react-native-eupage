//
//  RCTEUPageViewManager.m
//  RCTEUPage
//
//  Created by linyize on 15/6/10.
//  Copyright (c) 2015年 mmslate. All rights reserved.
//

#import "RCTEUPageViewManager.h"

#import "RCTEUPageView.h"
#import "RCTBridge.h"
#import "RCTConvert.h"
#import "RCTUIManager.h"

@implementation RCTEUPageViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[RCTEUPageView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_VIEW_PROPERTY(dataArray, NSArray)

@end
