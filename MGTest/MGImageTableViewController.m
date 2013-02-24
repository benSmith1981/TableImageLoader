//
//  ViewController.m
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import "MGImageTableViewController.h"
#import "AFNetworking.h"
#import "MGAFNetworkingInterface.h"

@interface MGImageTableViewController ()
{
    int maxImages;
}
/** Local property array to store the image urls to display in the table*/
@property (nonatomic,retain) NSArray* imageURLs;
@end

@implementation MGImageTableViewController
@synthesize imageListTable = _imageListTable;
@synthesize imageURLs = _imageURLs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //sets this class up to receive delegate call back when JSON is parsed
    maxImages = 5;
    [MGAFNetworkingInterface setImageManifestProtocol:self];
    //sets off AF networking to parse JSON
    [MGAFNetworkingInterface jsonRequestInitialiser];
    _imageURLs =  [[NSArray alloc]init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_imageListTable reloadData];
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

- (void)dealloc
{
    [super dealloc];
    [_imageListTable release];
    _imageListTable = nil;
    [_imageURLs release];
    _imageURLs = nil;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_imageURLs count]) {
        return maxImages;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    cell = [_imageListTable dequeueReusableCellWithIdentifier:@"reuseID"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSLog(@"%@",[_imageURLs objectAtIndex:indexPath.row]);
        NSURL *url = [[NSURL alloc] initWithString:[_imageURLs objectAtIndex:indexPath.row]];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    
    return cell;
}
#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [_imageListTable reloadData];
}


- (IBAction)loadMoreImages:(id)sender {
    maxImages +=5;
    if (maxImages >= [_imageURLs count]) {
        maxImages = [_imageURLs count];
    }
    [_imageListTable reloadData];
}
@end
