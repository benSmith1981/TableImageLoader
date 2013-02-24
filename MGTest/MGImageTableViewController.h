//
//  ViewController.h
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParsingCompleteProtocol.h"
@interface MGImageTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ParsingCompleteProtocol>

/** This is the UITableView Outlet */
@property (nonatomic,strong) IBOutlet UITableView *imageListTable;

@end
