//
//  TranslationAnimateManager.h
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePresent,
    TransitionTypeDismiss
};

@interface TranslationAnimateManager : NSObject <UIViewControllerAnimatedTransitioning>

//根据定义的枚举初始化的两个方法
+ (instancetype)transitionWithTransitionType:(TransitionType)type;
- (instancetype)initWithTransitionType:(TransitionType)type;

@end
