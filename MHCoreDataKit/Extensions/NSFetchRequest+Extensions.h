//
//  NSFetchRequest+Extensions.h
//  MHCoreDataKit
//
//  Created by Milen Halachev on 7/19/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest<ResultType> (Extensions)

-(nullable NSArray<ResultType> *)executeWithContext:(nonnull NSManagedObjectContext *)context error:(NSError * _Nullable __autoreleasing * _Nullable)error;

@end
