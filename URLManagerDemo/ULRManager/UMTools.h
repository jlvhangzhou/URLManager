//
//  UMTools.h
//  URLManagerDemo
//
//  Created by jiajun on 8/8/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#define PROTOCOL	@"PROTOCOL"
#define HOST		@"HOST"
#define PARAMS		@"PARAMS"
#define URI			@"URI"

@interface NSURL (UMURL)

- (NSDictionary *)params;
- (NSURL *)addParams:(NSDictionary*)params;

@end

@interface NSString (UMString)

- (NSString *)urlencode;
- (NSString *)urldecode;

@end
