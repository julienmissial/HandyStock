//
//  StockTableViewController.h
//  HandyStock
//
//  Created by ayatollah7 on 11/27/15.
//  Copyright © 2015 Julien Missial. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol StockTableViewControllerDelegate;

@interface StockTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) NSMutableArray * stockPricesArray;
@property(nonatomic) UITableView * tableView; 
@end
