//
//  MyLocationsFirstViewController.h
//  MyLocations
//
//  Created by Russ D on 2/28/13.
//  Copyright (c) 2013 RussDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface CurrentLocationViewController : UIViewController <
CLLocationManagerDelegate>

@property (nonatomic,strong) IBOutlet UILabel *messageLabel;
@property (nonatomic,strong) IBOutlet UILabel *latitudeLabel;
@property (nonatomic,strong) IBOutlet UILabel *longitudeLabel;
@property (nonatomic,strong) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong) IBOutlet UIButton *tagButton;
@property (nonatomic,strong) IBOutlet UIButton *getButton;

-(IBAction)getLocation:(id)sender;


@end
