//
//  EUWebPageViewCell.m
//  EUPage
//
//  Created by wangliqun on 15/6/1.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUWebPageViewCell.h"
#import "EUBaseModel.h"

@implementation EUWebPageViewCell

-(void)loadDataWithModel:(EUBaseModel *)model
{
    [super loadDataWithModel:model];
    
    if (!self.webView)
    {
        UIWebView *awebView = [[UIWebView alloc] init];
        awebView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:awebView];
        self.webView = awebView;
    }
    
    self.webView.frame = self.bounds;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.resourceUrl]]];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.webView.loading)
    {
        [self.webView stopLoading];
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
}

@end
