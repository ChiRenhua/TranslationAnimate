//
//  ToViewController.h
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Snapshot)

@property (nonatomic, readonly) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *contentImage;


@end
