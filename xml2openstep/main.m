//
//  main.m
//  xml2openstep
//
//  Created by xml2openstep on 2018/8/2.
//  Copyright © 2018 xml2openstep. All rights reserved.
//

#import <Foundation/Foundation.h>

static int xml2openstep (NSString *path);
static int openstep2xml (NSString *path);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        if (argc != 3) {
            printf("xml2netstep -xml2ns XMLfile\r\n");
            printf("xml2netstep -ns2xml OpenStepPlistfile");
            return 1;
        }
        NSString * type = [NSString stringWithUTF8String:argv[1]];
        NSString * file = [NSString stringWithUTF8String:argv[2]];
        if ([type isEqualToString:@"-xml2ns"]) {
            xml2openstep(file);
        }else if ([type isEqualToString:@"-ns2xml"]) {
            openstep2xml(file);
        }
    }
    return 0;
}


static int xml2openstep (NSString *path) {
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile: path
                                          options: 0
                                            error: &error];
    if (data == nil) {
        printf ("error reading %s: %s", [path UTF8String], [[error localizedDescription] UTF8String]);
        return 1;
    }
    
    NSPropertyListFormat format;
    id plist = [NSPropertyListSerialization propertyListWithData: data
                                                         options: NSPropertyListImmutable
                                                          format: &format
                                                           error: &error];
    
    
    if (plist == nil) {
        printf ("could not deserialize %s: %s", [path UTF8String], [[error localizedDescription] UTF8String]);
        return 1;
    } else {
        NSString *formatDescription;
        switch (format) {
            case NSPropertyListOpenStepFormat:
                formatDescription = @"openstep";
                break;
            case NSPropertyListXMLFormat_v1_0:
                formatDescription = @"xml";
                break;
            case NSPropertyListBinaryFormat_v1_0:
                formatDescription = @"binary";
                break;
            default:
                formatDescription = @"unknown";
                break;
        }
        
        if (![formatDescription isEqualToString:@"xml"]) {
            printf("%s was in %s format", [path UTF8String], [formatDescription UTF8String]);
            return 1;
        }
        
    }
    
    if (![NSPropertyListSerialization
          propertyList: plist
          isValidForFormat: NSPropertyListOpenStepFormat]) {
        printf ("can't save as OpenStepFormat");
        return 1;
    }
    NSString * openstep = [plist debugDescription];
    
    data =
    [openstep dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        printf ("error serializing to OpenStepFormat: %s", [[error localizedDescription] UTF8String]);
        return 1;
    }
    
    
    NSString * s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    printf("%s",[s UTF8String]);
    
//    BOOL writeStatus = [data writeToFile: @"plist.txt"
//                                 options: NSDataWritingAtomic
//                                   error: &error];
//    if (!writeStatus) {
//        NSLog (@"error writing to file: %@", error);
//        return 1;
//    }
    
    
    return 0;
    
}


static int openstep2xml (NSString *path) {
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile: path
                                          options: 0
                                            error: &error];
    if (data == nil) {
        printf ("error reading %s: %s", [path UTF8String], [[error localizedDescription] UTF8String]);
        return 1;
        }
    
    NSPropertyListFormat format;
    id plist = [NSPropertyListSerialization propertyListWithData: data
                                                         options: NSPropertyListImmutable
                                                          format: &format
                                                           error: &error];
    
    
    if (plist == nil) {
        printf ("could not deserialize %s: %s", [path UTF8String], [[error localizedDescription] UTF8String]);
        return 1;
    } else {
        NSString *formatDescription;
        switch (format) {
            case NSPropertyListOpenStepFormat:
                formatDescription = @"openstep";
                break;
            case NSPropertyListXMLFormat_v1_0:
                formatDescription = @"xml";
                break;
            case NSPropertyListBinaryFormat_v1_0:
                formatDescription = @"binary";
                break;
            default:
                formatDescription = @"unknown";
                break;
        }
        
        if (![formatDescription isEqualToString:@"openstep"]) {
            printf("%s was in %s format", [path UTF8String], [formatDescription UTF8String]);
            return 1;
        }
 
    }
    
    if (![NSPropertyListSerialization
          propertyList: plist
          isValidForFormat: NSPropertyListXMLFormat_v1_0]) {
        printf ("can't save as XMLFormat");
        return 1;
    }
    
    data =
    [NSPropertyListSerialization dataWithPropertyList: plist
                                               format: NSPropertyListXMLFormat_v1_0
                                              options: 0
                                                error: &error];
    if (data == nil) {
        printf ("error serializing to XMLFormat: %s", [[error localizedDescription] UTF8String]);
        return 1;
    }
    
    NSString * s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    printf("%s",[s UTF8String]);
    
//    BOOL writeStatus = [data writeToFile: @"plist.txt"
//                                 options: NSDataWritingAtomic
//                                   error: &error];
//    if (!writeStatus) {
//        NSLog (@"error writing to file: %@", error);
//        return 1;
//    }
    
    
    return 0;
    
}
