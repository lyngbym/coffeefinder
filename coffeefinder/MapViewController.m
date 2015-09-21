//
//  MapViewController.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewModel.h"
#import "PlaceResult.h"
@import MapKit;
@import CoreLocation;

@interface MapViewController () <MKMapViewDelegate>

/**
 *  Main MKMapView object for displaying coffee annotations
 */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/**
 * Allows the user to recenter and requery the map at their location.
 */
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
/**
 *  Handles interactions between the view controller and the PlacesService.
 */
@property (strong, nonatomic) MapViewModel *viewModel;
/**
 *  Indicates when to call off for coffee results the first time. Prevents changes in the map region from requerying.
 */
@property (assign, nonatomic) BOOL zooming;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [MapViewModel new];
    
    if (![CLLocationManager locationServicesEnabled]) {
        self.mapView.showsUserLocation = NO;
    }

    UIImage *locationImage = [[UIImage imageNamed:@"Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationButton setImage:locationImage forState:UIControlStateNormal];
    [self.locationButton setTintColor:[UIColor whiteColor]];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"LocationFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationButton setImage:selectedImage forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated {
    __weak MapViewModel *weakViewModel = self.viewModel;
    
    [self.viewModel promptForLocation:^(BOOL success, NSString *message) {
        if (success) {
            CLLocationCoordinate2D centerCoordinate = weakViewModel.userLocation.coordinate;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate,
                                                                           [weakViewModel milesToMeters:5], [weakViewModel milesToMeters:5]);
            self.zooming = YES;
            [self.mapView setRegion:region animated:YES];
            
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Something went wrong." message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationId"];
    if ([annotationView respondsToSelector:@selector(pinTintColor)]) {
        annotationView.pinTintColor = [UIColor colorWithRed:48.0/255.0 green:135.0/255.0 blue:62.0/255.0 alpha:1.0];
    }
    else {
        annotationView.pinColor = MKPinAnnotationColorGreen;
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(self.zooming) {
        self.zooming = NO;
        
        [self loadResults];
    }
}

#pragma mark - Actions
/**
 *  Handles the location button tap and forwards to loading methods.
 *
 *  @param sender location UIButton
 */
- (IBAction)locationButtonPressed:(id)sender {
    [self loadResults];
}

#pragma mark - Private Methods

/**
 *  Helper method to hand off with a default radius of 10 miles
 */
- (void)loadResults {
    [self loadResults:10];
}

/**
 *  Calls off to the Places Service to search for coffee locations with the given radius. 
 *  Removes previously added annotations and adjusts the map region based on the results.
 *
 *  @param radius to search
 */
- (void)loadResults:(NSUInteger)radius {
    if (self.viewModel.userLocation != nil) {
        __weak MapViewController *weakSelf = self;
        [self.viewModel searchNearbyCoffeeShops:self.viewModel.userLocation.coordinate radius:radius completion:^(NSArray *results, NSError *error) {
            if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:@"Something went wrong." message:@"Oops, we got an error trying to search for coffee shops. Please check back again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else if(results.count > 0) {
                NSArray *annotationsToRemove = [weakSelf.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return [evaluatedObject isKindOfClass:[PlaceResult class]];
                }]];
                
                [weakSelf.mapView removeAnnotations:annotationsToRemove];
                
                CLLocationDegrees minLat = 90.0;
                CLLocationDegrees maxLat = -90.0;
                CLLocationDegrees minLon = 180.0;
                CLLocationDegrees maxLon = -180.0;
                
                for (PlaceResult *result in results) {
                    if (result.coordinate.latitude ) {
                        minLat = MIN(minLat, result.coordinate.latitude);
                        minLon = MIN(minLon, result.coordinate.longitude);
                        maxLat = MAX(maxLat, result.coordinate.latitude);
                        maxLon = MAX(maxLon, result.coordinate.longitude);
                    }
                }
                
                MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2.1), maxLon - span.longitudeDelta / 2.1);
                
                MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
                [weakSelf.mapView setRegion:region animated:YES];
                
                [weakSelf.mapView addAnnotations:results];
            }
        }];
    }
}

@end
