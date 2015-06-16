//
//  EUBaseModel.m
//  EUCollectionView
//
//  Created by wangliqun on 15/5/27.
//  Copyright (c) 2015年 wangliqun. All rights reserved.
//

#import "EUBaseModel.h"

@implementation EUBaseModel

- (void)setCellType:(CellType)aCellType
{
    _cellType = aCellType;
    
    switch (_cellType)
    {
        case CellTypeWeb:
        {
           _reuseIdentifier = @"EUWebPageViewCell";
        }
            break;
        case CellTypeImage:
        {
             _reuseIdentifier = @"EUImagePageViewCell";
        }
            break;
        case CellTypeVideo:
        {
             _reuseIdentifier = @"EUVideoPageViewCell";
        }
            break;
            
        default:
        {
             _reuseIdentifier = @"EUPageViewCell";
        }
            break;
    }
}

- (void)setCellClass:(Class)className
{
    _reuseIdentifier = NSStringFromClass(className);
}

@end
