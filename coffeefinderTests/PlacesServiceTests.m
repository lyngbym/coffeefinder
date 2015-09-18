//
//  PlacesServiceTests.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlacesService.h"

@interface PlacesServiceTests : XCTestCase

@end

@implementation PlacesServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchNearbyCoffeeShopsAt10Miles {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"Search Nearby Coffee Completed"];
    
    PlacesService *service = [PlacesService new];
    [service searchCoffeePlaces:CLLocationCoordinate2DMake(44.975949, -93.267495) radius:10.0 completion:^(NSArray *results, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(results);
        
        [callbackExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
