//
//  PlacesService.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "PlacesService.h"
#import "PlacesURLBuilder.h"
#import "AFNetworking.h"

static NSString const * kAPI_KEY = @"AIzaSyAL8bp2FYHtIkcfQJ-aWJU8G4X_6PzSRAo";
static const double kMetersPerMile = 1609.34;

@implementation PlacesService

- (void)searchCoffeePlaces:(CLLocationCoordinate2D)center radius:(double)radius completion:(void (^)(NSArray *, NSError *))completion {
    NSURL *apiPath = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : kAPI_KEY,
                                                                   kLatitude : @(center.latitude),
                                                                   kLongitude : @(center.longitude),
                                                                   kRadius : @(radius * kMetersPerMile)}];
                      NSLog(@"%@", apiPath);
}


@end
