//
//  ViewController.m
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import "MGImageTableViewController.h"
#import "AFXMLRequestOperation.h"
#import "MGTBXMLTraverser.h"

@interface MGImageTableViewController () <UITableViewDataSource> 

@property (nonatomic,retain) MGTBXMLTraverser *MGtbxmlTraverser;
@property (nonatomic, assign) UITableView *tableView;

@end

@implementation MGImageTableViewController
@synthesize tableView = _tableView;
@synthesize MGtbxmlTraverser = _MGtbxmlTraverser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.wigtastic.com/MobGenImages/ImageManifest.xml"]];
//    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
//    } failure:nil];
//    [operation start];
    
    _MGtbxmlTraverser = [[MGTBXMLTraverser alloc]init];

    
    [self.view addSubview:self.tableView];
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.frame;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    cell = [_tableView dequeueReusableCellWithIdentifier:@"reuseID"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"Image %d", indexPath.row];
    }
    
    return cell;
}

- (void)dealloc
{
    [super dealloc];
    [_tableView release];
    _tableView = nil;
    [_MGtbxmlTraverser release];
    _MGtbxmlTraverser = nil;
}

@end
