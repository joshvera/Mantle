//
//  NSValueTransformer+MTLPredefinedTransformerAdditions.h
//  Mantle
//
//  Created by Justin Spahr-Summers on 2012-09-27.
//  Copyright (c) 2012 GitHub. All rights reserved.
//

#import <Foundation/Foundation.h>

// The name for a value transformer that converts strings into URLs and back.
extern NSString * const MTLURLValueTransformerName;

// Ensure an NSNumber is backed by __NSCFBoolean/CFBooleanRef
//
// NSJSONSerialization, and likely other serialization libraries, ordinarily
// serialize NSNumbers as numbers, and thus booleans would be serialized as
// 0/1. The exception is when the NSNumber is backed by __NSCFBoolean, which,
// though very much an implementation detail, is detected and serialized as a
// proper boolean.
extern NSString * const MTLBooleanValueTransformerName;

@interface NSValueTransformer (MTLPredefinedTransformerAdditions)

// Returns a reversible transformer which will convert a JSON dictionary into an
// instance of the given MTLModel subclass, and vice versa.
+ (NSValueTransformer *)mtl_JSONTransformerWithModelClass:(Class)modelClass;

// Like -mtl_JSONTransformerWithModelClass:, but converts from an array of JSON
// dictionaries to an array of models, and vice versa.
+ (NSValueTransformer *)mtl_JSONArrayTransformerWithModelClass:(Class)modelClass;

+ (NSValueTransformer *)mtl_externalRepresentationTransformerWithModelClass:(Class)modelClass __attribute__((deprecated("Replaced by +mtl_JSONTransformerWithModelClass:")));
+ (NSValueTransformer *)mtl_externalRepresentationArrayTransformerWithModelClass:(Class)modelClass __attribute__((deprecated("Replaced by +mtl_JSONArrayTransformerWithModelClass:")));

@end
