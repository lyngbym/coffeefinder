//
//  PlacesURLBuilderTests.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/17/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "PlacesURLBuilder.h"

@interface PlacesURLBuilderTests : XCTestCase

@end

@implementation PlacesURLBuilderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMissingAllRequiredFieldsReturnsNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{}];
    XCTAssertNil(nearbyPlacesURL);
}

- (void)testMissingKeyFieldReturnsNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kLatitude : @(50), kLongitude : @(-50), kRadius : @(10)}];
    XCTAssertNil(nearbyPlacesURL);
}

- (void)testMissingLatitudeFieldReturnsNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : @"asdfasdf", kLongitude : @(-50), kRadius : @(10)}];
    XCTAssertNil(nearbyPlacesURL);
}

- (void)testMissingLongitudeFieldReturnsNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : @"asdfasdf", kLatitude : @(50), kRadius : @(10)}];
    XCTAssertNil(nearbyPlacesURL);
}

- (void)testMissingRadiusFieldReturnsNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : @"asdfasdf", kLatitude : @(50), kLongitude : @(-50)}];
    XCTAssertNil(nearbyPlacesURL);
}

- (void)testAllRequiredFieldsNotNil {
    NSURL *nearbyPlacesURL = [PlacesURLBuilder nearbyPlacesURLWithParams:@{kKey : @"asdfasdf",
                                                                           kLatitude : @(50),
                                                                           kLongitude : @(-50),
                                                                           kRadius : @(10)}];
    XCTAssertNotNil(nearbyPlacesURL);
}

@end
