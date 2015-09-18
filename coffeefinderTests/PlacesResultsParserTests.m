//
//  PlacesResultsParserTests.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlacesResultsParser.h"
#import "PlaceResult.h"

@interface PlacesResultsParserTests : XCTestCase

@end

@implementation PlacesResultsParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSuccessfulResults {
    NSString *resultsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"results" ofType:@"json"];
    NSData *resultsData = [[NSFileManager defaultManager] contentsAtPath:resultsPath];
    
    NSError *error;
    NSDictionary *resultsInfo = [NSJSONSerialization JSONObjectWithData:resultsData options:NSJSONReadingAllowFragments error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(resultsInfo);
    
    PlacesResultsParser *resultsParser = [[PlacesResultsParser alloc] initWithResponse:resultsInfo];
    
    XCTestExpectation *completionExpection = [self expectationWithDescription:@"Expected callback parsing results"];
    
    [resultsParser parse:^(PlacesResultStatus status, NSArray *results, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(PlacesResultStatusOK, status);
        XCTAssertNotNil(results);
        XCTAssertEqual(20, results.count);
        
        PlaceResult *firstResult = [results firstObject];
        XCTAssertNotNil(firstResult.title);
        XCTAssertTrue(firstResult.coordinate.latitude != 0);
        XCTAssertTrue(firstResult.coordinate.longitude != 0);
        XCTAssertNotNil(firstResult.placeId);
        XCTAssertNotNil(firstResult.subtitle);
        
        [completionExpection fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
