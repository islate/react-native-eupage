//
//  EUBaseModel.h
//  EUCollectionView
//
//  Created by wangliqun on 15/5/27.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum
{
    CellTypeCustom =0 ,
    CellTypeWeb,
    CellTypeImage,
    CellTypeVideo,
}CellType;

@interface EUBaseModel : NSObject
@property (nonatomic, assign) CellType cellType;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, strong, readonly) NSString *reuseIdentifier;

-(void)setCellClass:(Class)className;

@end
