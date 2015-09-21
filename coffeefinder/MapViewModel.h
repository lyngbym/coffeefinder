//
//  MapViewModel.h
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;



@interface MapViewModel : NSObject

@property (strong, nonatomic, readonly) CLLocation *userLocation;

- (void)promptForLocation:(void(^)(BOOL, NSString *))completion;

- (void)searchNearbyCoffeeShops:(CLLocationCoordinate2D)center radius:(NSUInteger)radius completion:(void(^)(NSArray *results, NSError *error))completion;

- (float)milesToMeters:(float)miles;

- (BOOL)locationAvailable;

@end
