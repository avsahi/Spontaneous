//
//  InterfaceController.m
//   WatchKit Extension
//
//  Created by Avdeep Sahi on 3/13/15.
//  Copyright (c) 2015 Avdeep Sahi. All rights reserved.
//

#import "InterfaceController.h"
#import "detailInterfaceController.h"
#import "tableRow.h"



@interface InterfaceController()
@property (nonatomic, weak) IBOutlet WKInterfaceTable * table;

@property (nonatomic, strong) tableRow * theRow;




@end


@implementation InterfaceController {
    NSDictionary *adict;
    NSArray *keys;
    NSUInteger nbItems;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // initilze the array once, use it multiple times in configureTable
    // wouldnt want to initialize it there each time
    
   
}

- (void)configureTableWithData:(NSArray*)dataObjects
{
    // row type specified in storyboard, dont forget
    [self.table setNumberOfRows:[dataObjects count] withRowType:@"cell"];
    
    for (NSInteger i = 0; i < self.table.numberOfRows; i++)
    {
        // custom class, imported and used as row controller
        tableRow * theRow = [self.table rowControllerAtIndex:i];
        
        [theRow.rowLabel setText:keys[i]];
        //[theRow.rowIcon setImage:[UIImage imageNamed:dataObjects[i]]];
    }

}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
  
    NSLog(@"afsa");
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.spontaneousWatch"];
    adict = [defaults objectForKey:@"bookmark"];
    
    keys = [adict allKeys];
    
    keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    // pass in the array to populate the table
    NSLog(@"count:%lu",(unsigned long)[keys count]);
    if ([keys count] == 0) {
        [self.noneLabel setText:@"You have no bookmarks. Go to the mobile app and bookmark locations to view them on your watch!"];
        [self.table setNumberOfRows:0 withRowType:@"cell"];
//        tableRow * theRow = [self.table rowControllerAtIndex:0];
//        [theRow.rowLabel setText:@"No Favorites Yet"];
        
        
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
//                                                          message:@"You have no favorites. Go to the app on your phone and add some to check em out on your wrist!"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"Okay"
//                                                otherButtonTitles:nil];
//        
//        [message show];
        

    } else {
        [self.noneLabel setText:@""];
        [self configureTableWithData:keys];
    }

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
}

- (instancetype) contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex
{
    if ([keys count] != 0) {
        return [keys objectAtIndex:rowIndex];
    } else {
        return NULL;
    }
}

@end



