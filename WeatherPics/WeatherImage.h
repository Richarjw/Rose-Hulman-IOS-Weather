//
//  WeatherImage.h
//  WeatherPics
//
//  Created by Tracy Richard on 7/8/16.
//  Copyright © 2016 Jack Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherImage : NSManagedObject

@property (nullable, nonatomic, retain) NSString *caption;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSDate *lastTouchDate;
@end

NS_ASSUME_NONNULL_END

#import "WeatherImage+CoreDataProperties.h"
