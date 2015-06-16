//
//  EUWebPageViewCell.h
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUPageViewCell.h"

@interface EUWebPageViewCell : EUPageViewCell<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@end
