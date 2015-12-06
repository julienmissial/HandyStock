//
//  ViewController.m
//  HandyStock
//
//  Created by ayatollah7 on 11/27/15.
//  Copyright © 2015 Julien Missial. All rights reserved.
//

#import "MainViewController.h"
#import "StockTableViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_HEIGHT self.view.frame.size.height
#define SCREEN_WIDTH self.view.frame.size.width
#define ARC4RANDOM_MAX      0x100000000

@interface MainViewController (){
    UIButton * view, * buy;
    UILabel * stockPrice, * name;
    NSMutableArray * stockPrices;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //build interface
    [self buildInterface];
    
}

-(void) buildInterface{
    //setting up navigation controller
    self.title = @"HNDY";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = UIColorFromRGB(0x252525);
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0x2CC1ED)];
    
    // timer calls to update price.
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self
                                   selector:@selector(updatePrice) userInfo:nil repeats:YES];
    
    // configure nsurlsession
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    
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
    
    // Handy, Inc.
    name.text = @"Handy, Inc.";
    name.textColor = UIColorFromRGB(0xFFFFFF);
    [name setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:24]];
    [name sizeToFit];
    name.center = CGPointMake(SCREEN_WIDTH/2, 40);
    
    //Stock Price label
    stockPrice.translatesAutoresizingMaskIntoConstraints= NO;
    stockPrice.textColor = UIColorFromRGB(0xFFFFFF);
    [stockPrice setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:84.0]];

    // add everything to view
    [self.view addSubview:view];
    [self.view addSubview:buy];
    [self.view addSubview:stockPrice];
    [self.view addSubview:name];
    
    //constraints for stockprice label
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem:stockPrice attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual toItem:self.view attribute:
                               NSLayoutAttributeCenterX multiplier:1.0 constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stockPrice
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop    
                                                         multiplier:1.0     
                                                           constant:100.0]];
    
    [self updatePrice]; 
}

// fcn for the external api call
-(NSString *)getPriceFromAPI{
    
    //the link to pull the latest price
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://dev.markitondemand.com/MODApis/Api/v2/Quote/jsonp?symbol=GOOG&callback=myFunction"]];

    // parse the response string
    NSString *json = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"myFunction(" withString:@""];
    json = [json stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //convert to array
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    // pulling the last price only, assuming it updates during mkt hours
    NSString *str = [jsonObject valueForKey:@"LastPrice"];
    
    return str;
}
// Fcn to update price.
-(void)updatePrice{

    stockPrice.text = [NSString stringWithFormat:@"$%.2f", [[self getPriceFromAPI] floatValue]];
    [stockPrices addObject:[NSString stringWithFormat:@"%@",stockPrice.text]];
    
    NSLog(@"Price Updated\n");
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
