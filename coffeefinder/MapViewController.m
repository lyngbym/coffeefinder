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

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapViewModel *viewModel;
@property (assign, nonatomic) BOOL zooming;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [MapViewModel new];
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
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationId"];
    annotationView.pinTintColor = [UIColor colorWithRed:48.0/255.0 green:135.0/255.0 blue:62.0/255.0 alpha:1.0];
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(self.zooming) {
        self.zooming = NO;
        
        [self.viewModel searchNearbyCoffeeShops:self.viewModel.userLocation.coordinate completion:^(NSArray *results, NSError *error) {
            if (error != nil) {
                // TODO: deal with error
            }
            else if(results.count > 0) {
                for (PlaceResult *result in results) {
                    [self.mapView addAnnotation:result];
                }
            }
            else {
                // TODO: deal with no results
            }
        }];
    }
}

#pragma mark - Private Methods

- (void)loadResultsIfNeeded {
    if (self.viewModel.userLocation != nil) {
        [self.viewModel searchNearbyCoffeeShops:self.viewModel.userLocation.coordinate completion:^(NSArray *results, NSError *error) {
            if (error != nil) {
                // TODO: deal with error
            }
            else if(results.count > 0) {
                for (PlaceResult *result in results) {
                    [self.mapView addAnnotation:result];
                }
            }
            else {
                // TODO: deal with no results
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
