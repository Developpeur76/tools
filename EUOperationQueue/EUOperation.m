//
//  EUOperation.m
//  EUOperationQueue
//
//  Created by Artem Shimanski on 28.08.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "EUOperation.h"

@interface EUOperation()
@property (nonatomic, readwrite, strong) NSString* identifier;
@end

@implementation EUOperation

+ (id) operationWithIdentifier:(NSString*) aIdentifier name:(NSString*) name {
#if ! __has_feature(objc_arc)
	return [[[EUOperation alloc] initWithIdentifier:aIdentifier name:name] autorelease];
#else
	return [[EUOperation alloc] initWithIdentifier:aIdentifier name:name];
#endif
}

+ (id) operationWithIdentifier:(NSString*) aIdentifier {
#if ! __has_feature(objc_arc)
	return [[[EUOperation alloc] initWithIdentifier:aIdentifier] autorelease];
#else
	return [[EUOperation alloc] initWithIdentifier:aIdentifier];
#endif
}

+ (id) operation {
#if ! __has_feature(objc_arc)
	return [[[EUOperation alloc] initWithIdentifier:nil] autorelease];
#else
	return [[EUOperation alloc] initWithIdentifier:nil];
#endif
}

- (id) initWithIdentifier:(NSString*) aIdentifier name:(NSString*) name {
	if (self = [super init]) {
		self.identifier = aIdentifier;
		self.operationName = name;
	}
	return self;
}

- (id) initWithIdentifier:(NSString*) aIdentifier {
	if (self = [super init]) {
		self.identifier = aIdentifier;
	}
	return self;
}

#if ! __has_feature(objc_arc)
- (void) dealloc {
	[identifier release];
	[operationName release];
	[super dealloc];
}
#endif

- (void) setCompletionBlockInMainThread:(void (^)(void))block {
	[self setCompletionBlock:^(void) {
		if ([NSThread isMainThread])
			block();
		else
			dispatch_sync(dispatch_get_main_queue(), block);
	}];
}

- (void) setProgress:(float)value {
	_progress = value;
	[self.delegate operation:self didUpdateProgress:_progress];
}

- (void) start {
	@autoreleasepool {
		[self.delegate operationDidStart:self];
		[super start];
		[self.delegate operationDidFinish:self];
	}
}

@end
