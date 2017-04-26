//
//  ToViewController.m
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "ToViewController.h"
#import "TranslationAnimateManager.h"
#import "SwipeInteractiveTransition.h"

@interface ToViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ToViewController

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 50, self.view.bounds.size.height / 2 - 15, 100, 30)];
    [button setTitle:@"点我回退" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 15;
    [self.view addSubview:button];
}

- (void)buttonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [TranslationAnimateManager transitionWithTransitionType:TransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [[TranslationAnimateManager alloc ]initWithTransitionType:TransitionTypeDismiss];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [SwipeInteractiveTransition sharedInstance].interacting ? [SwipeInteractiveTransition sharedInstance] : nil;
}

@end
