//
//  PlacesURLBuilder.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "PlacesURLBuilder.h"

NSString * const kKey  = @"key";
NSString * const kLatitude = @"latitude";
NSString * const kLongitude = @"longitude";
NSString * const kRadius = @"radius";

NSString * const kKeyword = @"keyword";
NSString * const kTypes = @"types";

// internal
NSString * const kLocation = @"location";

@implementation PlacesURLBuilder

+ (NSString *)nearbyPlaces {
    return @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
}

+ (NSURL *)nearbyPlacesURLWithParams:(NSDictionary *)parameters {
    if (parameters[kKey] == nil || parameters[kLatitude] == nil || parameters[kLongitude] == nil || parameters[kRadius] == nil) {
        return nil; // can't query without including all required parameters
    }
    
    NSNumber *latitudeNumber = parameters[kLatitude];
    NSNumber *longitudeNumber = parameters[kLongitude];
    
    NSString *nearbyString = [NSString stringWithFormat:@"%@%@=%@&%@=%lf,%lf&%@=%@&name=coffee", [self nearbyPlaces],
                              kKey, parameters[kKey],
                              kLocation, [latitudeNumber doubleValue], [longitudeNumber doubleValue],
                              kRadius, parameters[kRadius]];
    
    NSLog(@"%@", nearbyString);
    return [NSURL URLWithString:nearbyString];
}

@end
