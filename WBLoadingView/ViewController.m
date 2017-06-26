//
//  ViewController.m
//  WBLoadingView
//
//  Created by zwb on 2017/6/16.
//  Copyright © 2017年 HengSu Co., LTD. All rights reserved.
//

#import "ViewController.h"

#import "WBLoadingHUD.h"

#import "WBProgressHUD.h"

#import "WBRoundHUD.h"

#import "WBLoadingView-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WBHUD-OC";
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Swift" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = right;
    
    CGRect rect1 = CGRectMake(50, 20, 50, 50);
    WBLoadingHUD *hud1 = [[WBLoadingHUD alloc] initWithFrame:rect1];
    [self.view addSubview:hud1];
    [hud1 start];
    
//    WBLoadingHUD *hud = [WBLoadingHUD showToView:self.view animated:YES];
//    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
//    hud.lineColor = [UIColor blueColor];
    
    CGRect rect2 = CGRectMake(150, 20, 50, 50);
    WBProgressHUD *hud2 = [[WBProgressHUD alloc] initWithFrame:rect2 type:WBProgressHUDTypeSingle lineColor:nil];
    [self.view addSubview:hud2];
    [hud2 start];
    
    CGRect rect3 = CGRectMake(250, 20, 50, 50);
    WBProgressHUD *hud3 = [[WBProgressHUD alloc] initWithFrame:rect3 type:WBProgressHUDTypeGossip lineColor:[UIColor orangeColor]];
    [self.view addSubview:hud3];
    [hud3 start];
    
    CGRect rect4 = CGRectMake(50, 120, 50, 50);
    WBProgressHUD *hud4 = [[WBProgressHUD alloc] initWithFrame:rect4 type:WBProgressHUDTypeFishHook lineColor:nil];
    [self.view addSubview:hud4];
    [hud4 start];
    
    CGRect rect5 = CGRectMake(150, 120, 50, 50);
    WBRoundHUD *hud5 = [[WBRoundHUD alloc] initWithFrame:rect5 type:WBRoundHUDTypeUniform roundColor: nil];
    hud5.duration = 1.5;
    hud5.roundColor = [UIColor greenColor];
    [self.view addSubview:hud5];
    [hud5 start];
    
    CGRect rect6 = CGRectMake(250, 120, 50, 50);
    WBRoundHUD *hud6 = [[WBRoundHUD alloc] initWithFrame:rect6 type:WBRoundHUDTypeGradient roundColor: nil];
    hud6.duration = 2.0;
    hud6.roundColor = [UIColor redColor];
    [self.view addSubview:hud6];
    [hud6 start];
}

-(void)rightBarItemClick:(UIBarButtonItem *)item {
    SwiftDemoViewController *swiftVc = [SwiftDemoViewController new];
    [self.navigationController pushViewController:swiftVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
