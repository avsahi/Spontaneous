//
//  MainViewController.h
//  webTableView
//  Created by Avdeep Sahi on 2/18/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBShimmeringView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIAlertViewDelegate> {
    
    IBOutlet UIImageView *AnitmationimageView;
    IBOutlet UIImageView *Loadimageview;
    
    IBOutlet UIBarButtonItem *bookmarks;
    IBOutlet UISegmentedControl *control;

    IBOutlet UIButton *location;
    IBOutlet UITextField *city; // city
    IBOutlet UITextField *name;
    IBOutlet UIPickerView *picker;
    
    IBOutlet UIImageView *top1;
    IBOutlet UIImageView *bottom1;
    IBOutlet UIImageView *top2;
    IBOutlet UIImageView *bottom2;
    
    IBOutlet UILabel *label;
    
    IBOutlet UIImageView *vistaLogo;//logo
    
    
}
-(IBAction)openFavorites:(id)sender;
@property (strong, nonatomic) NSDictionary *inventory;
@property (strong, nonatomic) UIAlertView *noConnection;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;



- (IBAction)getCurrentLocation:(id)sender;


@end
