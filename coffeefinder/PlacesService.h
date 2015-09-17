//
//  PlacesService.h
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PlacesService : NSObject

- (void)searchCoffeePlaces:(CLLocationCoordinate2D)center radius:(double)radius completion:(void(^)(NSArray *results, NSError *error))completion;


@end
