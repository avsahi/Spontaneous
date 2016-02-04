//
//  TableViewController.h
//  webTableView
//
//  Created by Avdeep Sahi on 2/19/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include "TargetConditionals.h"
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"


@interface TableViewController : UITableViewController <UITableViewDataSource, CLLocationManagerDelegate> {
    HTPressableButton *next;
    HTPressableButton *prev;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
}

@property (strong, nonatomic) NSArray *googlePlacesArrayFromAFNetworking;
@property (strong, nonatomic) NSArray *tmp;
@property (strong, nonatomic) NSArray *finishedGooglePlacesArray;
@property (strong, nonatomic) IBOutlet UIButton *back;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *radius;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sortBy;
@property (weak, nonatomic) IBOutlet UILabel *countIndicator;
@property (weak, nonatomic) IBOutlet UILabel *emptyTable;


@end
