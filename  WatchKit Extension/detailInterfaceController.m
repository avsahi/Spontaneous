//
//  detailInterfaceController.m
//  Spontaneous
//
//  Created by Avdeep Sahi on 3/13/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "detailInterfaceController.h"
#import "AFNetworking.h"
#import "ASStarRatingView.h"


@interface detailInterfaceController()

@end


@implementation detailInterfaceController {
    NSString *checkString;
    NSDictionary *inventory;
    NSString *priceLevel;
    NSNumber *lat;
    NSNumber *lng;
    NSString *addressString;
}


//- (void)setTitle:(NSString *)title {
//    
//}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    NSDictionary *adict = [defaults objectForKey:@"bookmark"];
    NSString* name = (NSString *)context;
    NSString * url = [adict objectForKey:name];
    NSLog(@"%@", url);
    
    
    // give it to label and have the string find the image again
    [self.titleLabel setText:[NSString stringWithFormat:@"↑\n%@", name]];

    //[self.detailImage setImage:[UIImage imageNamed:namePassed]];
   inventory = [NSDictionary dictionaryWithObjects:@[@"Accounting", @"Airport", @"Amusement Park", @"Aquarium", @"Art Gallery", @"ATM", @"Bakery", @"Bank", @"Bar", @"Beauty Salon", @"Bicycle Store", @"Book Store", @"Bowling Alley", @"Bus Station", @"Cafe", @"Campground",  @"Car Dealer", @"Car Rental", @"Car Repair", @"Car Wash", @"Casino", @"Cemetery", @"Church", @"City Hall", @"Clothing Store" ,@"Convenience Store", @"Courthouse", @"Dentist", @"Department Store", @"Doctor", @"Electrician", @"Electronics Store", @"Embassy", @"Establishment", @"Finance", @"Fire Station", @"Florist", @"Food", @"Funeral Home", @"Furniture Store", @"Gas Station", @"General Contractor", @"Grocery or Supermarket", @"Gym", @"Hair Care", @"Hardware Store", @"Health", @"Hindu Temple", @"Home Goods Store", @"Hospital", @"Insurance Agency", @"Jewelry Store", @"Laundry", @"Lawyer", @"Library", @"Liquor Store", @"Local Government Office", @"Locksmith", @"Lodging", @"Meal Delivery", @"Meal Takeaway", @"Mosque", @"Movie Rental", @"Movie Theater", @"Moving Company", @"Museum", @"Night Club", @"Painter", @"Park", @"Parking", @"Pet Store", @"Pharmacy", @"Physiotherapist", @"Place of Worship", @"Plumber" ,@"Police", @"Post Office", @"Real Estate Agency", @"Restaurant", @"Roofing Contractor", @"RV Park", @"School", @"Shoe Store", @"Shopping Mall", @"Spa", @"Stadium", @"Storage", @"Store", @"Subway Station", @"Synagogue", @"Taxi Stand", @"Train Station", @"Travel Agency", @"University", @"Veterinary Care", @"Zoo"] forKeys:@[@"accounting", @"airport", @"amusement_park", @"aquarium", @"art_gallery", @"atm", @"bakery", @"bank", @"bar", @"beauty_salon", @"bicycle_store", @"book_store", @"bowling_alley", @"bus_station", @"cafe", @"campground",  @"car_dealer", @"car_rental", @"car_repair", @"car_wash", @"casino", @"cemetery", @"church", @"city_hall", @"clothing_store" ,@"convenience_store", @"courthouse", @"dentist", @"department_store", @"doctor", @"electrician", @"electronics_store", @"embassy", @"establishment", @"finance", @"fire_station", @"florist", @"food", @"funeral_home", @"furniture_store", @"gas_station", @"general_contractor", @"grocery_or_supermarket", @"gym", @"hair_care", @"hardware_store", @"health", @"hindu_temple", @"home_goods_store", @"hospital", @"insurance_agency", @"jewelry_store", @"laundry", @"lawyer", @"library", @"liquor_store", @"local_government_office", @"locksmith", @"lodging", @"meal_delivery", @"meal_takeaway", @"mosque", @"movie_rental", @"movie_theater", @"moving_company", @"museum", @"night_club", @"painter", @"park", @"parking", @"pet_store", @"pharmacy", @"physiotherapist", @"place_of_worship", @"plumber" ,@"police", @"post_office", @"real_estate_agency", @"restaurant", @"roofing_contractor", @"rv_park", @"school", @"shoe_store", @"shopping_mall", @"spa", @"stadium", @"storage", @"store", @"subway_station", @"synagogue", @"taxi_stand", @"train_station", @"travel_agency", @"university", @"veterinary_care", @"zoo"]];
    NSURL *aurl = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[aurl absoluteString]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             checkString = [[[responseObject objectForKey:@"result"]objectForKey:@"opening_hours"] objectForKey:@"open_now"];
             NSInteger checkInt = [checkString integerValue];
             if (checkString == nil) {
                 [self.openLabel setText:@"No Hours"];
                 [self.openLabel setTextColor:[UIColor redColor]];
                 
             } else if (checkInt == 1) {
                 // NSLog(@"yes");
                 [self.openLabel setText:@"Open Now"];
                 [self.openLabel setTextColor:[UIColor greenColor]];
             } else if (checkInt == 0){
                 //  NSLog(@"yes");
                 [self.openLabel setText:@"Closed Now"];
                 [self.openLabel setTextColor:[UIColor redColor]];
             } else {
                 [self.openLabel setText:@"Hours not available"];
                 [self.openLabel setTextColor:[UIColor redColor]];
             }
             NSArray *types =[[responseObject objectForKey:@"result"]objectForKey:@"types"];
             if ([types count] == 0) {
                 [self.typeOfPlace setText:@"Unknown"];
             } else if ([types count] == 1) {
                 [self.typeOfPlace setText:[NSString stringWithFormat:@"%@.", [inventory objectForKey:types[0]]]];
             } else if ([types count] >= 2) {
                 [self.typeOfPlace setText:[NSString stringWithFormat:@"%@, %@", [inventory objectForKey:types[0]],
                                            [inventory objectForKey:types[1]]]];
                 
             }
             
             if([[responseObject objectForKey:@"result"] objectForKey:@"rating"] != NULL) {
                 if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] < 1) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐  %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                     
                     
                 } else if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] < 2) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐  %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                     
                     
                 } else if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] < 3) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐⭐  %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                     
                     
                 } else if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] < 4) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐⭐⭐  %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                     
                     
                 }
                 else if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] < 5) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐⭐⭐⭐ %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                     
                     
                 }
                 else if ([[[responseObject objectForKey:@"result"] objectForKey:@"rating"] doubleValue] >= 5) {
                     [self.ratingNum setText: [NSString stringWithFormat:@"⭐⭐⭐⭐⭐ %@", [[[responseObject objectForKey:@"result"] objectForKey:@"rating"] stringValue]]];
                 }
                 
                 
                 
             } else {
                 [self.ratingNum setText: @"Not Rated"];
                 
                 
                 
             }
             
             [self.ratingNum setTextColor:[UIColor colorWithRed:0.996 green:0.702 blue:0.02 alpha:1]];
             priceLevel = [[responseObject objectForKey:@"result"]objectForKey:@"price_level"];
             NSString *text;
             if (priceLevel <= 0) {
                 text = @"Price Level: N/A";
             } else if ([priceLevel intValue] == 1) {
                 text = @"Price Level: $";
             } else if ([priceLevel intValue] == 2) {
                 text = @"Price Level: $$";
             } else if ([priceLevel intValue] == 3) {
                 text = @"Price Level: $$$";
             } else if ([priceLevel intValue] == 4) {
                 text = @"Price Level: $$$$";
             } else if ([priceLevel intValue] >= 5) {
                 text = @"Price Level: $$$$$";
             }
             [self.priceLabel setText:text];
             
             lat = [[[[responseObject objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
             lng = [[[[responseObject objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
             CLLocationCoordinate2D zoomLocation;
             zoomLocation.latitude = lat.doubleValue;
             zoomLocation.longitude= lng.doubleValue;
             MKCoordinateSpan coordinateSpan =  MKCoordinateSpanMake(0.008, 0.008);
             
             [self.mapView addAnnotation:zoomLocation withPinColor:WKInterfaceMapPinColorPurple];
             [self.mapView setRegion:MKCoordinateRegionMake(zoomLocation, coordinateSpan)];
             addressString = [[responseObject objectForKey:@"result"] objectForKey:@"formatted_address"];
             [self.addressText setText:addressString];
             
             

         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // Handle failure
         }];
  
    


    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}



@end



