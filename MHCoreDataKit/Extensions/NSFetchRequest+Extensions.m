//
//  NSFetchRequest+Extensions.m
//  MHCoreDataKit
//
//  Created by Milen Halachev on 7/19/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

#import "NSFetchRequest+Extensions.h"

@implementation NSFetchRequest (Extensions)

-(nullable NSArray *)executeWithContext:(nonnull NSManagedObjectContext *)context error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    
    return [context executeFetchRequest:self error:error];
}

@end
