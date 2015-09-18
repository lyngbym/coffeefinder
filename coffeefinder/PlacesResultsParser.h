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

- (instancetype)initWithResponse:(NSDictionary *)response NS_DESIGNATED_INITIALIZER;

- (void)parse:(void(^)(PlacesResultStatus status, NSArray *results, NSError *error))completion;
		
@end
