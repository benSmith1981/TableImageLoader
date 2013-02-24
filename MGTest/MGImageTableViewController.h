//
//  ViewController.h
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParsingComplete.h"
@interface MGImageTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ParsingComplete>

/** This is the UITableView to show all images */
@property (nonatomic,strong) IBOutlet UITableView *imageListTable;
- (IBAction)loadMoreImages:(id)sender;

@end
