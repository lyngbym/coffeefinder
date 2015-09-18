//
//  PlacesResultsParser.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "PlacesResultsParser.h"
#import "PlaceResult.h"

static NSString * const kResults = @"results";
static NSString * const kStatus = @"status";
static NSString * const kStatusOK = @"OK";
static NSString * const kStatusRequstDenied = @"REQUEST_DENIED";
static NSString * const kName = @"name";
static NSString * const kPlaceId = @"place_id";
static NSString * const kGeometry = @"geometry";
static NSString * const kLocation = @"location";
static NSString * const kLat = @"lat";
static NSString * const kLng = @"lng";
static NSString * const kVicinity = @"vicinity";

@interface PlacesResultsParser ()

@property (strong, nonatomic) NSDictionary *responseDictionary;
@property (copy, nonatomic) void (^parseCompletion)(PlacesResultStatus, NSArray *, NSError *);

@end

@implementation PlacesResultsParser

- (instancetype)initWithResponse:(NSDictionary *)response {
    self = [super init];
    if (self) {
        self.responseDictionary = response;
    }
    return self;
}

- (void)parse:(void (^)(PlacesResultStatus, NSArray *, NSError *))completion {
    if (!completion) {
        return;
    }
    
    self.parseCompletion = completion;
    
    if ([self.responseDictionary[kStatus] isEqualToString:kStatusOK]) {
        NSArray *results = self.responseDictionary[kResults];
        NSMutableArray *places = [NSMutableArray arrayWithCapacity:results.count];
        
        for (NSDictionary *resultInfo in results) {
            
            PlaceResult *place = [PlaceResult new];
            place.name = resultInfo[kName];
            
            NSDictionary *locationInfo = resultInfo[kGeometry][kLocation];
            NSNumber *latNum = locationInfo[kLat];
            NSNumber *lngNum = locationInfo[kLng];
            
            place.location = CLLocationCoordinate2DMake([latNum doubleValue], [lngNum doubleValue]);
            place.vicinity = resultInfo[kVicinity];
            place.placeId = resultInfo[kPlaceId];
            
            [places addObject:place];
        }
        
        self.parseCompletion(PlacesResultStatusOK, places, nil);
    }
    else if([self.responseDictionary[kStatus] isEqualToString:kStatusRequstDenied]) {
        self.parseCompletion(PlacesResultStatusRequestDenied, nil, nil);
    }
    else {
        NSError *error = [NSError errorWithDomain:@"PlacesError" code:200 userInfo:@{NSLocalizedDescriptionKey : @"Oops, search for any coffee shops at this time. Please try again later"}];
        self.parseCompletion(PlacesResultStatusError, nil, error);
    }
}

@end
