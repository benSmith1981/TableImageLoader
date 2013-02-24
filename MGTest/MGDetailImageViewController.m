//
//  MGDetailImageVCViewController.m
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "MGDetailImageViewController.h"

@interface MGDetailImageViewController ()

@end

@implementation MGDetailImageViewController
@synthesize fullsizeImage = _fullsizeImage;
@synthesize imageScrollView = _imageScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _fullsizeImage = [[UIImageView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imageScrollView setContentSize:_fullsizeImage.frame.size];
    [_imageScrollView addSubview:_fullsizeImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [super dealloc];
    [_imageScrollView release];
    _imageScrollView = nil;
    [_fullsizeImage release];
    _fullsizeImage = nil;
}

- (void)viewDidUnload {
    [self setImageScrollView:nil];
    [super viewDidUnload];
}
@end
