//
//  SwipeInteractiveTransition.h
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

+ (instancetype)sharedInstance;

- (void)wireToViewController:(UIViewController*)viewController;

- (void)writeTargetViewController:(UIViewController *)viewController;
@end
