//
//  Buch.h
//  BuchVerleih-Tutorial
//
//  Created by Benjamin Herzog on 04.07.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Buch : NSManagedObject

@property (nonatomic, retain) NSString * titel;
@property (nonatomic, retain) Person *person;

@end
