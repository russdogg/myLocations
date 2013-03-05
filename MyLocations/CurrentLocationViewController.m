//
//  MyLocationsFirstViewController.m
//  MyLocations
//
//  Created by Russ D on 2/28/13.
//  Copyright (c) 2013 RussDesigns. All rights reserved.
//

#import "CurrentLocationViewController.h"

@implementation CurrentLocationViewController
{
    CLLocationManager *locationManager;
    CLLocation *location;
    BOOL updatingLocation;
    NSError *lastLocationError;
}

@synthesize messageLabel, longitudeLabel, latitudeLabel, addressLabel, tagButton, getButton;

-(IBAction)getLocation:(id)sender
{
    if(updatingLocation)
    {
        [self stopLocationManager];
    }
    else
    {
        location = nil;
        lastLocationError = nil;
        [self startLocationManager];
    }
    
    [self updateLabels];
    [self configureGetButton];
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        locationManager= [[CLLocationManager alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLabels];
    [self configureGetButton];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateLabels
{
    if (location != nil)
    {
        self.messageLabel.text = @"GPS Coordinates";
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
        self.tagButton.hidden = NO;
    }
    else
    {
        self.latitudeLabel.text = @"";
        self.longitudeLabel.text = @"";
        self.addressLabel.text = @"";
        self.tagButton.hidden = YES;
        
        NSString *statusMessage;
        if(lastLocationError != nil)
        {
            if ([lastLocationError.domain isEqualToString:kCLErrorDomain] && lastLocationError.code == kCLErrorDenied)
            {
                statusMessage = @"Location Services Disabled";
            }
            else
            {
                statusMessage = @"Error Getting Location";
            }
        }
        else if(![CLLocationManager locationServicesEnabled])
        {
            statusMessage = @"Location Services Disabled";
        }
        else if(updatingLocation)
        {
            statusMessage = @"Searching...";
        }
        else
        {
            statusMessage = @"Press the Button to Start";
        }
        
        self.messageLabel.text = statusMessage;
        
    }
}

-(void)configureGetButton
{
    if (updatingLocation)
    {
        [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
    }
}

-(void)startLocationManager
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];
        updatingLocation = YES;
    }
}

-(void)stopLocationManager
{
    if(updatingLocation)
    {
        [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
        updatingLocation = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
    if(error.code == kCLErrorLocationUnknown)
    {
        return;
    }
    [self stopLocationManager];
    lastLocationError = error;
    
    [self updateLabels];
    [self configureGetButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation %@", newLocation);
    
    if ([newLocation.timestamp timeIntervalSinceNow] < -5.0)
    {
        return;
    }
    
    if (newLocation.horizontalAccuracy < 0)
    {
        return;
    }
    
    if(location == nil || location.horizontalAccuracy > newLocation.horizontalAccuracy)
    {
        lastLocationError = nil;
        location = newLocation;
        [self updateLabels];
        
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy)
        {
            NSLog(@"*** We're Done");
            [self stopLocationManager];
            [self configureGetButton];
        }
    }
    
    
}

@end





