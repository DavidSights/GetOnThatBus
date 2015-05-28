//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by David Seitz Jr on 5/27/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.location objectForKey:@"cta_stop_name"];
    self.addressLabel = [self.location objectForKey:@""];

}


@end
