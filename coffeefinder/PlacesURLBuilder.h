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

/**
 *  The root URL of the Google places nearby search api endpoint
 *
 *  @return URL of the base api
 */
+ (NSURL *)nearbyPlaces;

/**
 *  The full URL representing the coffee search for Google Places.
 *
 *  @param parameters A dictionary of required parameters, such as location and api key to pass to google
 *
 *  @return an NSURL fully formatted with the parameters passed.
 */
+ (NSURL *)nearbyPlacesURLWithParams:(NSDictionary *)parameters;

@end
