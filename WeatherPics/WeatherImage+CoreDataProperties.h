//
//  WeatherImage+CoreDataProperties.h
//  WeatherPics
//
//  Created by Tracy Richard on 7/8/16.
//  Copyright © 2016 Jack Richard. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *caption;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSDate *lastTouchDate;

@end

NS_ASSUME_NONNULL_END
