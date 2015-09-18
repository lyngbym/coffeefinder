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

/**
 *  The main interface to the Nearby Places Google Backend Service.
 *
 *  @param center     The lat/lng that represents the center of the search, presumably the user's location.
 *  @param radius     The radius in miles to search.
 *  @param completion Completion callback that either contains a list of PlaceResult object or an error.
 */
- (void)searchCoffeePlaces:(CLLocationCoordinate2D)center radius:(double)radius completion:(void(^)(NSArray *results, NSError *error))completion;


@end
