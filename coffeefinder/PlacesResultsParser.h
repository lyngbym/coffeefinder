//
//  PlacesResultsParser.h
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlacesResultStatus) {
    PlacesResultStatusOK,
    PlacesResultStatusRequestDenied,
    PlacesResultStatusError
};

@interface PlacesResultsParser : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Converts a google nearby places search result into a set of data model objects.
 *
 *  @param response Google places result payload
 *
 *  @return new instance
 */
- (instancetype)initWithResponse:(NSDictionary *)response NS_DESIGNATED_INITIALIZER;

/**
 *  Parsers the response that was setup in the initializer.
 *
 *  @param completion Passes back an array of PlaceResult annotation objects or an error
 */
- (void)parse:(void(^)(PlacesResultStatus status, NSArray *results, NSError *error))completion;
		
@end
