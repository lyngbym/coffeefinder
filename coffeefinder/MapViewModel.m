//
//  MapViewModel.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "MapViewModel.h"
#import "PlacesService.h"
@import MapKit;

@interface MapViewModel () <CLLocationManagerDelegate>

@property (strong, nonatomic, readwrite) CLLocation *userLocation;

@property (strong, nonatomic) PlacesService *service;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) void(^locationCompletion)(BOOL, NSString *);

@property (assign, nonatomic) NSInteger locationCallbackCount;
@property (assign, nonatomic) BOOL gettingPermission;
@property (assign, nonatomic) BOOL gettingUpdates;
@property (strong, nonatomic) NSDate *locationWarningExpiration;

@end

@implementation MapViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.service = [PlacesService new];
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 5;
    }
    return self;
}

#pragma mark - Public Methods

- (void)promptForLocation:(void (^)(BOOL, NSString *))completion {
    NSAssert(completion != nil, @"completion block can't be nil");
    NSAssert(self.locationManager.delegate != nil, @"no delegate set for location manager");
    
    self.locationCompletion = completion;
    
    if (![CLLocationManager locationServicesEnabled]) {
        completion(NO, @"Oops, we cannot search for local coffee shops because location services is disabled. Please check in Settings App -> Privacy -> Location Services.");
    }
    else {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusDenied: {
                completion(NO, @"Oops, it looks like you need to authorize Coffee Finder to use location services. This can be found in the Settings App -> Privacy -> Location Services");
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse: {
                [self startLocationUpdatesIfNeeded];
            }
                break;
            case kCLAuthorizationStatusNotDetermined: {
                self.gettingPermission = YES;
                [self.locationManager requestWhenInUseAuthorization];
            }
                break;
                
            default: {
                completion(NO, @"Something went wrong trying to get your location. Please try again soon.");
            }
                break;
                
        }
    }
}

- (void)searchNearbyCoffeeShops:(CLLocationCoordinate2D)center radius:(NSUInteger)radius completion:(void (^)(NSArray *, NSError *))completion {
    NSAssert(completion != nil, @"completion cannot be nil");
    
    [self.service searchCoffeePlaces:center radius:radius completion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }];
}

- (float)milesToMeters:(float)miles {
    // 1 mile is 1609.344 meters
    return 1609.344f * miles;
}

- (BOOL)locationAvailable {
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse && self.userLocation != nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"location: %@", [locations lastObject]);

    self.userLocation = [locations lastObject];
    
    if (self.locationCompletion) {
        self.locationCompletion(YES, nil);
        self.locationCompletion = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get location %@", [error description]);
    
    if (self.gettingPermission) {
        return;
    }
    
    if (!self.userLocation && self.locationCompletion != nil) {
        
        if ([[NSDate date] timeIntervalSinceDate:self.locationWarningExpiration] < 60.0) {
            return;
        }
        
        self.locationWarningExpiration = [NSDate date];
        self.locationCompletion(NO, @"Something went wrong trying to get your location. Perhaps you are in an area with low signal. Please retry by pressing the current location button on the map.");
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startLocationUpdatesIfNeeded];
        self.gettingPermission = NO;
    }
}

#pragma mark - Private Methods

-(void)startLocationUpdatesIfNeeded {
    if (!self.gettingUpdates) {
        [self.locationManager startUpdatingLocation];
        self.gettingUpdates = YES;
    }
}


@end
