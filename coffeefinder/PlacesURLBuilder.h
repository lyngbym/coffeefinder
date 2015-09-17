//
//  PlacesURLBuilder.h
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <Foundation/Foundation.h>

// required
extern NSString * const kKey;
extern NSString * const kLatitude;
extern NSString * const kLongitude;
extern NSString * const kRadius;

// optional
extern NSString * const kKeyword;
extern NSString * const kTypes;

@interface PlacesURLBuilder : NSObject

+ (NSURL *)nearbyPlaces;

+ (NSURL *)nearbyPlacesURLWithParams:(NSDictionary *)parameters;

@end
