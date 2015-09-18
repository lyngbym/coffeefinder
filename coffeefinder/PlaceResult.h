//
//  PlaceResult.h
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PlaceResult : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *placeId;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSString *vicinity;

@end
