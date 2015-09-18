//
//  MapViewController.m
//  coffeefinder
//
//  Created by Mason Lyngby on 9/18/15.
//  Copyright © 2015 Mason Lyngby. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewModel.h"
@import MapKit;
@import CoreLocation;

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapViewModel *viewModel;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [MapViewModel new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    __weak MapViewModel *weakViewModel = self.viewModel;
    
    [self.viewModel promptForLocation:^(BOOL success, NSString *message) {
        if (success) {
            CLLocationCoordinate2D centerCoordinate = weakViewModel.userLocation.coordinate;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate,
                                                                           [weakViewModel milesToMeters:5], [weakViewModel milesToMeters:5]);
            [self.mapView setRegion:region animated:YES];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Something went wrong." message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
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
