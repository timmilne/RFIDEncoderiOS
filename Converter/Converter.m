//
//  Converter.m
//  RFIDEncoder
//
//  Created by Tim.Milne on 4/27/15.
//  Copyright © 2019 Tim Milne. All rights reserved.
//
//  This object converts between Decimal, Hex and Binary
//  All inputs and outputs are NSStrings
//

#import "Converter.h"

// NSString
@import Foundation;

// BigInt
#import "BigInt.h"

@implementation Converter {
}

- (NSString *)Dec2Bin:(NSString *)dec {
    return [self Hex2Bin:([self Dec2Hex:(dec)])];
}

- (NSString *)Bin2Dec:(NSString *)bin {
    return [self Hex2Dec:([self Bin2Hex:(bin)])];
}

- (NSString *)Dec2Hex:(NSString *)dec {
    return [[[BigInt alloc] initWithString:dec andRadix:10] toStringWithRadix:16];
}

- (NSString *)Hex2Dec:(NSString *)hex {
    return [[[BigInt alloc] initWithString:hex andRadix:16] toStringWithRadix:10];
}

- (NSString *)Bin2Hex:(NSString *)bin {
    NSString *paddedHex = [[[BigInt alloc] initWithString:bin andRadix:2] toStringWithRadix:16];
    
    // Pad to 24 chars
    while(paddedHex.length < 24) paddedHex = [NSString stringWithFormat:@"0%@", paddedHex];
    
    return paddedHex;
}

- (NSString *)Hex2Bin:(NSString *)hex {
    NSString *paddedBin = [[[BigInt alloc] initWithString:hex andRadix:16] toStringWithRadix:2];
    
    // Pad to 4 bit bytes
    while((paddedBin.length % 4) != 0) paddedBin = [NSString stringWithFormat:@"0%@", paddedBin];
    
    return paddedBin;
}

@end
