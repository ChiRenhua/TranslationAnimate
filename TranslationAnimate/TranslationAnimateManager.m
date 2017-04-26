//
//  TranslationAnimateManager.m
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TranslationAnimateManager.h"
#import "UIView+Snapshot.h"

@interface TranslationAnimateManager ()

@property (nonatomic, assign) TransitionType type;

@end

@implementation TranslationAnimateManager

+ (instancetype)transitionWithTransitionType:(TransitionType)type {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithTransitionType:type];
    });
    return sharedInstance;
}

- (instancetype)initWithTransitionType:(TransitionType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case TransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case TransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    UIView *containerView = [transitionContext containerView];
    
    UIView *toViewSnapshot = [UIView new];
    toViewSnapshot.contentImage =  toView.snapshotImage;
    toViewSnapshot.frame = containerView.bounds;
    
    CATransform3D scale = CATransform3DIdentity;
    toViewSnapshot.layer.transform = CATransform3DScale(scale, 0.9, 0.9, 1);//
    [containerView addSubview:toViewSnapshot];
    [containerView sendSubviewToBack:toViewSnapshot];
    CGRect upSnapshotRegion = CGRectMake(0, 0, fromView.frame.size.width, fromView.frame.size.height  * 0.5);
    UIView *upHandView = [UIView new];
    upHandView.contentImage = fromView.snapshotImage;
    upHandView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    upHandView.frame = upSnapshotRegion;
    [containerView addSubview:upHandView];
    
    CGRect downSnapshotRegion = CGRectMake(0, fromView.frame.size.height * 0.5, fromView.frame.size.width, fromView.frame.size.height * 0.5);
    UIView *downHandView = [UIView new];
    downHandView.contentImage = upHandView.contentImage;
    downHandView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    downHandView.frame = downSnapshotRegion;
    [containerView addSubview:downHandView];
    
    fromView.hidden = YES;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         upHandView.frame = CGRectOffset(upHandView.frame, 0, - upHandView.frame.size.height);
                         downHandView.frame = CGRectOffset(downHandView.frame, 0, downHandView.frame.size.height);
                         toViewSnapshot.center = toView.center;
                         toViewSnapshot.frame = toView.frame;
                     } completion:^(BOOL finished) {
                         fromView.hidden = NO;
                         if ([transitionContext transitionWasCancelled]) {
                             [containerView addSubview:fromView];
                             [self removeOtherViewsExceptView:fromView];
                         } else {
                             [containerView addSubview:toView];
                             [self removeOtherViewsExceptView:toView];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}
//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
    [containerView addSubview:toView];
    CGRect upSnapshotRegion = CGRectMake(0, 0, fromView.frame.size.width, fromView.frame.size.height * 0.5);
    UIView *upHandView = [UIView new];
    upHandView.contentImage = toView.snapshotImage;
    upHandView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    upHandView.frame = upSnapshotRegion;
    upHandView.frame = CGRectOffset(upHandView.frame, 0, - upHandView.frame.size.height);
    [containerView addSubview:upHandView];
    CGRect downSnapshotRegion = CGRectMake(0, fromView.frame.size.height * 0.5, fromView.frame.size.width, fromView.frame.size.height * 0.5);
    UIView *downHandView = [UIView new];
    downHandView.contentImage = upHandView.contentImage;
    downHandView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    downHandView.frame = downSnapshotRegion;
    downHandView.frame = CGRectOffset(downHandView.frame, 0, downHandView.frame.size.height);
    [containerView addSubview:downHandView];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         upHandView.frame = CGRectOffset(upHandView.frame, 0, upHandView.frame.size.height);
                         downHandView.frame = CGRectOffset(downHandView.frame, 0, - downHandView.frame.size.height);
                         CATransform3D scale = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DScale(scale, 0.9, 0.9, 1);//
                     } completion:^(BOOL finished) {
                         if ([transitionContext transitionWasCancelled]) {
                             [self removeOtherViewsExceptView:fromView];
                         } else {
                             [self removeOtherViewsExceptView:toView];
                             toView.frame = containerView.bounds;
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (void)removeOtherViewsExceptView:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

@end
