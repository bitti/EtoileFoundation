/**
    <abstract>Mirror-based reflection API for Etoile</abstract>
 
    Copyright (C) 2009 Eric Wasylishen
 
    Date:  June 2009
    License: Modified BSD (see COPYING)
 */

#import <Foundation/Foundation.h>
#import <EtoileFoundation/ETReflection.h>
#import <EtoileFoundation/runtime.h>

/** @group Reflection
@abstract Mirror class that represents an Objective-C protocol. */
@interface ETProtocolMirror : NSObject <ETProtocolMirror>
{
    @private
    Protocol *_protocol;
}
- (id) initWithProtocol: (Protocol *)protocol;
+ (id) mirrorWithProtocol: (Protocol *)protocol;
@end

