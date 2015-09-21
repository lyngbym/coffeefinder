//
//  PlacesService.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "PlacesService.h"
#import "PlaceResult.h"
#import "PlacesURLBuilder.h"
#import "AFNetworking.h"
#import "PlacesResultsParser.h"

static NSString const * kAPI_KEY = @"AIzaSyAL8bp2FYHtIkcfQJ-aWJU8G4X_6PzSRAo";
static const double kMetersPerMile = 1609.34;

@interface PlacesService ()

@property (strong, nonatomic) AFURLSessionManager *sessionManager;

@end

@implementation PlacesService

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    }
    return self;
}

- (void)searchCoffeePlaces:(CLLocationCoordinate2D)center radius:(double)radius completion:(void (^)(NSArray *, NSError *))completion {
    
    NSAssert(completion != nil, @"completion block can't be nil");
    
    NSURL *placesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : kAPI_KEY,
                                                                   kLatitude : @(center.latitude),
                                                                   kLongitude : @(center.longitude),
                                                                   kRadius : @(radius * kMetersPerMile)}];
    
    NSURLRequest *placesRequest = [NSURLRequest requestWithURL:placesURL];
    
    NSURLSessionDataTask *placesTask = [self.sessionManager dataTaskWithRequest:placesRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            completion(nil, error);
        }
        else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                PlacesResultsParser *parser = [[PlacesResultsParser alloc] initWithResponse:responseObject];
                [parser parse:^(PlacesResultStatus status, NSArray *results, NSError *error) {
                    switch (status) {
                        case PlacesResultStatusError: {
                            completion(nil, error);
                        }
                            break;
                        case PlacesResultStatusRequestDenied: {
                            completion(nil, [NSError errorWithDomain:@"PlacesService" code:200 userInfo:@{NSLocalizedDescriptionKey : @"Oops, too many users are searching for coffee. Please try back later."}]);
                        }
                            break;
                        case PlacesResultStatusOK: {
                            
                            // filter out results outside of radius
                            MKMapPoint centerPt = MKMapPointForCoordinate(center);
                            CLLocationDistance maxDistance = radius * 1609.34; // meters per mile
                            NSLog(@"maxDistance %f", maxDistance);
                            NSArray *filteredResults = [results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PlaceResult *  _Nonnull result, NSDictionary<NSString *,id> * _Nullable bindings) {
                                MKMapPoint resultPt = MKMapPointForCoordinate(result.coordinate);
                                return MKMetersBetweenMapPoints(centerPt, resultPt) <= maxDistance;
                            }]];
                            
                            completion(filteredResults, nil);
                        }
                            break;
                    }
                }];
            }
            else {
                completion(nil, [NSError errorWithDomain:@"PlacesService" code:200 userInfo:@{NSLocalizedDescriptionKey : @"Oops, something went wrong searching for coffee shops. Please try again later."}]);
            }
        }
    }];
    
    [placesTask resume];
}


@end
