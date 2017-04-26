//
//  SwipeInteractiveTransition.m
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "SwipeInteractiveTransition.h"
#import "ToViewController.h"


@interface SwipeInteractiveTransition ()

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@property (nonatomic, strong) UIViewController *targetVC;

@end

@implementation SwipeInteractiveTransition

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)wireToViewController:(UIViewController *)viewController
{
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)writeTargetViewController:(UIViewController *)viewController {
    self.targetVC = viewController;
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.interacting = YES;
            self.targetVC = [[ToViewController alloc] init];
            [self.presentingVC presentViewController:self.targetVC animated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            NSInteger y =  translation.y;
            CGFloat fraction = y / 200.0;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.1);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
