//
//  Person.h
//  BuchVerleih-Tutorial
//
//  Created by Benjamin Herzog on 04.07.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Buch;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * nachname;
@property (nonatomic, retain) NSString * vorname;
@property (nonatomic, retain) NSSet *buecher;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addBuecherObject:(Buch *)value;
- (void)removeBuecherObject:(Buch *)value;
- (void)addBuecher:(NSSet *)values;
- (void)removeBuecher:(NSSet *)values;

@end
