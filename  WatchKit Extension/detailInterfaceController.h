//
//  detailInterfaceController.h
//  Spontaneous
//
//  Created by Avdeep Sahi on 3/13/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface detailInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *typeOfPlace;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *ratingNum;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *openLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *priceLabel;

@property (strong, nonatomic) IBOutlet WKInterfaceMap *mapView;
@property CLLocationCoordinate2D center;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *addressText;

//@property (weak, nonatomic) IBOutlet WKInterfaceImage *detailImage;

@end
