/*
    Copyright (C) 2013 Quentin Mathe

    Date:  December 2013
    
    This file may be used under the terms of either GNU Lesser General Public 
    License Version 2.1 (or later), GNU General Public License Version 2 (or
    later), BSD modified license or Apache License Version 2.
 */

#import <Foundation/NSArray.h>
#import <Foundation/NSOperation.h>
#import "EtoileCompatibility.h"

#ifdef GNUSTEP_MISSING_API_COMPATIBILITY

@implementation NSSortDescriptor (ETGNUstepCompatibility)

+ (id) sortDescriptorWithKey: (NSString *)aKey ascending: (BOOL)ascending
{
    return AUTORELEASE([[self alloc] initWithKey: aKey ascending: ascending]);
}

+ (id) sortDescriptorWithKey: (NSString *)aKey ascending: (BOOL)ascending selector: (SEL)aSelector
{
    return AUTORELEASE([[self alloc] initWithKey: aKey ascending: ascending selector: aSelector]);
}

@end


@implementation NSSet (ETGNUstepCompatibility) 

- (NSArray *) sortedArrayUsingDescriptors: (NSArray *)sortDescriptors
{
    return [[self allObjects] sortedArrayUsingDescriptors: sortDescriptors];
}

@end


@interface CONotificationBlockOperation : NSOperation
{
    NSNotification *_notification;
    void (^_block)(NSNotification *);
}

- (id) initWithNotification: (NSNotification *)notif block: (void (^)(NSNotification *))block;

@end

@implementation CONotificationBlockOperation

- (id) initWithNotification: (NSNotification *)notif block: (void (^)(NSNotification *))block
{
    self = [super init];
    if (self == nil)
        return nil;

    ASSIGN(_notification, notif);
    ASSIGNCOPY(_block, block);
    return self;

}

- (void) main
{
    _block(_notification);
}

@end

@interface CONotificationObserver : NSObject
{
    NSOperationQueue *_queue;
    void (^_block)(NSNotification *);
}

@end

@implementation CONotificationObserver

- (id) initWithQueue: (NSOperationQueue *)queue block: (void (^)(NSNotification *))block
{
    self = [super init];
    if (self == nil)
        return nil;

    ASSIGN(_queue, queue);
    ASSIGNCOPY(_block, block);
    return self;
}

- (void) didReceiveNotification: (NSNotification *)notif
{
    if (_queue != nil)
    {
        [_queue addOperation: [[CONotificationBlockOperation alloc] initWithNotification: notif block: _block]];
    }
    else
    {
        _block(notif);
    }
}

@end

@implementation NSNotificationCenter (ETGNUstepCompatibility)

- (id)addObserverForName: (NSString *)name object: (id)object queue: (NSOperationQueue *)queue usingBlock: (void (^)(NSNotification *))block
{
    CONotificationObserver *observer = [[CONotificationObserver alloc] initWithQueue: queue block: block];

    [self addObserver: observer selector: @selector(didReceiveNotification:) name: name object: object];

    return observer;
}

@end

#endif
