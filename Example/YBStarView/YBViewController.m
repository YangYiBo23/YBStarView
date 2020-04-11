//
//  YBViewController.m
//  YBStarView
//
//  Created by yyb on 04/11/2020.
//  Copyright (c) 2020 yyb. All rights reserved.
//

#import "YBViewController.h"
#import <YBStarView.h>

@interface YBViewController ()

@end

@implementation YBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YBStarView *starView = [[YBStarView alloc] initWithNormalImage:[UIImage imageNamed:@"icon_yb_star_gray"] highlightedImage:[UIImage imageNamed:@"icon_yb_star_yellow"]];
    starView.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    [starView setCompleteBlock:^(CGFloat score) {
        NSLog(@"%.2f", score);
    }];
    [self.view addSubview:starView];
}

@end
