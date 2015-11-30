//
//  ViewController.m
//  HandyStock
//
//  Created by ayatollah7 on 11/27/15.
//  Copyright © 2015 Julien Missial. All rights reserved.
//

#import "ViewController.h"
#import "StockTableViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_HEIGHT self.view.frame.size.height
#define SCREEN_WIDTH self.view.frame.size.width
#define ARC4RANDOM_MAX      0x100000000

@interface ViewController (){
    float stock_price;
    UIButton * view, * buy;
    UILabel * stockPrice, * name;
    NSMutableArray * stockPrices;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    //setting up navigation controller
    self.title = @"HNDY";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = UIColorFromRGB(0x252525);
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0x2CC1ED)];
    
    // initializing
    stockPrices = [[NSMutableArray alloc]init];
    view = [UIButton buttonWithType:UIButtonTypeSystem];
    buy = [UIButton buttonWithType:UIButtonTypeSystem];
    stockPrice = [[UILabel alloc]init];
    name = [[UILabel alloc]init];
    
    //view button
    [view setTitle:@"VIEW" forState:UIControlStateNormal];
    [view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    [view.titleLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:28.0]];
    view.tintColor = UIColorFromRGB(0x2CC1ED);
    view.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 240, [UIScreen mainScreen].applicationFrame.size.width, 100);
    [view addTarget:self action:@selector(showOldPrices) forControlEvents:UIControlEventTouchUpInside];
    
    // buy button
    [buy setTitle:@"BUY" forState:UIControlStateNormal];
    [buy setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [buy setBackgroundColor:UIColorFromRGB(0x2CC1ED)];
    [buy setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:28.0]];
    buy.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 140, [UIScreen mainScreen].applicationFrame.size.width, 100);
    buy.layer.cornerRadius = 0;
    buy.clipsToBounds = YES;
    [buy addTarget:self action:@selector(buyButton) forControlEvents:UIControlEventTouchUpInside];
    
    // stock price button
    stock_price = ((float)arc4random() / ARC4RANDOM_MAX) * 20 + 680.00;
    stockPrice.textColor = UIColorFromRGB(0xFFFFFF);
    [stockPrice setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:84.0]];
    stockPrice.text = [NSString stringWithFormat:@"$%.2f", stock_price];
    [stockPrice sizeToFit];
    stockPrice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 96);
    [stockPrices addObject:[NSString stringWithFormat:@"%@",stockPrice.text]];
    
    // Handy, Inc.
    name.text = @"Handy, Inc.";
    name.textColor = UIColorFromRGB(0xFFFFFF);
    [name setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:24]];
    [name sizeToFit];
    name.center = CGPointMake(SCREEN_WIDTH/2, 40);
    
    // timer calls to update price.
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self
                                   selector:@selector(updatePrice) userInfo:nil repeats:YES];
    
    // add everything to view
    [self.view addSubview:view];
    [self.view addSubview:buy];
    [self.view addSubview:stockPrice];
    [self.view addSubview:name];
    
    
}

// Fcn to update price.
-(void)updatePrice{

    stock_price = ((float)arc4random() / ARC4RANDOM_MAX) * 20 + 680.00;
    stockPrice.textColor = UIColorFromRGB(0xFFFFFF);
    [stockPrice setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:84.0]];
    stockPrice.text = [NSString stringWithFormat:@"$%.2f", stock_price];
    [stockPrice sizeToFit];
    stockPrice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 96);
    
    // add new price to array
    [stockPrices addObject:[NSString stringWithFormat:@"%@",stockPrice.text]];
}

// buy button
-(void)buyButton{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Available! (Yet)" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// segues to the tableViewController
-(void)showOldPrices{
    StockTableViewController *s = [[StockTableViewController alloc]init];
    s.stockPricesArray = stockPrices;
    
    [[self navigationController] pushViewController:s animated:YES];
}

// change status bar to white. 
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
