//
//  FromViewController.m
//  TranslationAnimate
//
//  Created by Renhuachi on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "FromViewController.h"
#import "ToViewController.h"
#import "SwipeInteractiveTransition.h"

@interface FromViewController ()
@property (nonatomic, strong) ToViewController *toVC;
@end

@implementation FromViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 50, self.view.bounds.size.height / 2 - 15, 100, 30)];
    [button setTitle:@"点我跳转" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 15;
    [self.view addSubview:button];
    
    self.toVC = [[ToViewController alloc] init];
    SwipeInteractiveTransition *swipeInteractiveTransition = [SwipeInteractiveTransition sharedInstance];
    [swipeInteractiveTransition wireToViewController:self];
    [swipeInteractiveTransition writeTargetViewController:self.toVC];
}

- (void)buttonClick {
    self.toVC = [[ToViewController alloc] init];
    [self presentViewController:self.toVC animated:YES completion:nil];
}

@end
