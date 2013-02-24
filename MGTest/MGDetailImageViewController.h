//
//  MGDetailImageVCViewController.h
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGDetailImageViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property(nonatomic,retain)UIImageView *fullsizeImage;
@end
