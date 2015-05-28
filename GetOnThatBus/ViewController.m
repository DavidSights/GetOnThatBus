//
//  ViewController.m
//  GetOnThatBus
//
//  Created by David Seitz Jr on 5/27/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "MyPointAnnotation.h"

@interface ViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSDictionary *locationsDictionary;
@property NSMutableArray *locations;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapListControl;
@property MKPointAnnotation *pointAnnotation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locations = [[NSMutableArray alloc] init];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //begin completion block

        NSDictionary *requestedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        self.locations = [requestedData objectForKey:@"row"];
        [self.tableView reloadData];

        for (NSDictionary *location in self.locations){
            MyPointAnnotation *annotation = [MyPointAnnotation new];
            double longitude, latitude;
            latitude = [[location objectForKey:@"latitude"] doubleValue];
            longitude = [[location objectForKey:@"longitude"] doubleValue];
            if (longitude > 0) {
                longitude = longitude * -1;
            }
            if (location != nil) {
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                annotation.title = [location objectForKey:@"cta_stop_name"];
                annotation.subtitle = [location objectForKey:@"routes"];
            }
            annotation.location = location;
            [self.myMapView addAnnotation:annotation];
            [self.myMapView showAnnotations:self.myMapView.annotations animated:YES];
        }
        //end completion block
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if ([annotation isEqual:mapView.userLocation]) { //Do nothing to user location pins
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    [self performSegueWithIdentifier:@"detail" sender:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSDictionary *location = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = [location objectForKey:@"cta_stop_name"];
    cell.detailTextLabel.text = [location objectForKey:@"routes"];
    return cell;
}


- (IBAction)mapListControlToggled:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.tableView.alpha = 0;
    } else {
        self.tableView.alpha = 1;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destinationVC = segue.destinationViewController;

    MyPointAnnotation *myPoint = self.myMapView.selectedAnnotations.firstObject;
    destinationVC.location = myPoint.location;
}




@end
