//
//  MapViewAnnotation.h
//  webTableView
//
//  Created by Avdeep Sahi on 3/15/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
