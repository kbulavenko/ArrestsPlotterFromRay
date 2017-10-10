//
//  MyLocation.m
//  ArrestsPlotter
//
//  Created by Z on 09.10.17.
//  Copyright © 2017 KonstantinBulavenko. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface MyLocation ()
@property (nonatomic, copy)     NSString   *name;
@property (nonatomic, copy)     NSString   *address;
@property (nonatomic, assign)   CLLocationCoordinate2D  theCoordinate;
@end


@implementation MyLocation

- (instancetype)initWithName: (NSString *) name address:(NSString *)adddress coordinate:(CLLocationCoordinate2D) coordinate
{
    self = [super init];
    if (self) {
        if([name isKindOfClass: [NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.address   = adddress;
        self.theCoordinate  = coordinate;
        
    }
    return self;
}



// implementation MKAnnotation

- (NSString *) titel {
    return _name;
}
- (NSString *)subtitle {
    return _address;
}
// required method coordinate :
- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}
// end  implementation MKAnnotation

-(MKMapItem *)mapItem {
  //  NSDictionary *addressDict   = @{ (NSString *)kABPersonAddressStreetKey : _address};
    //   kABPersonAddressStreetKey   is Deprecated
    
    
    
   NSDictionary *addressDict   = @{ (NSString *)CNPostalAddressStreetKey : _address};
    
    MKPlacemark *placemark      = [[MKPlacemark alloc]
                                   initWithCoordinate: self.coordinate
                                   addressDictionary: addressDict];
    
    MKMapItem *mapItem          = [[MKMapItem alloc] initWithPlacemark: placemark];
    mapItem.name                = self.title;
    
    return mapItem;
}





@end
