//
//  TCINEncoder.m
//  RFIDEncoder
//
//  Created by Tim.Milne on 2/28/19.
//  Copyright © 2019 Tim Milne. All rights reserved.
//

#import "TCINEncoder.h"

// NSString
@import Foundation;

// Convert
#import "Converter.h"

// Serial Number Generator
#import "SerialNumberGenerator.h"

@implementation TCINEncoder {
    Converter *_convert;
}

- (void)withTCIN:(NSString *)tcin {
    
    unsigned long long seed;
    seed = 7725272730706;
    
    return [self withTCIN:tcin ser:[SerialNumberGenerator newSerialWithSeed:seed]];
}

// The seed could be a device ID, or something else unique to the running instance.
- (void)withTCIN:(NSString *)tcin
            seed:(long long)seed {
    
    return [self withTCIN:tcin ser:[SerialNumberGenerator newSerialWithSeed:seed]];
}


- (void)withTCIN:(NSString *)tcin
             ser:(NSString *)ser {
    
    // Have we done this?
    if (_convert == nil) _convert = [Converter alloc];
    
    // Set the inputs
    [self setTcin:tcin];
    [self setSer:ser];
    [self setTcin_bin:@""];
    [self setTcin_hex:@""];
    [self setTcin_uri:@""];
    
    // We will encode TCINs in a Target proprietary TCIN-96
    int tcinBinLen = 35;
    int tcinDecLen = 10;
    int serBinLen  = 50;
    int serDecLen  = 15;
    
    // Make sure the inputs are not too long (especially the Serial Number)
    if ([_tcin length] > tcinDecLen) {
        _tcin = [_tcin substringToIndex:tcinDecLen];
    }
    while ([_tcin length] < tcinDecLen) {
        _tcin = [NSString stringWithFormat:@"0%@", _tcin];
    }
    if ([_ser length] > serDecLen) {
        // TCIN serial number max = 15
        _ser = [_ser substringToIndex:serDecLen];
    }
    
    // TCIN-96 - e.g. urn:epc:tag:tcin-96:0.0013951442.123456789012345
    //              0800035387487048860DDF79
    //
    // A TCIN is a 10 digit decimal number with a unique serial number.
    //
    // Here is how to pack the TCIN-96 into the EPC
    // 8 bits are the header: 00001000 or 0x08 (TCIN-96)
    // 3 bits are the Filter: 000 (0 All Others)
    // 35 bits are the manager number: 10 digit TCIN
    // 50 bits are the serial number (guaranteed 15 digits)
    // = 96 bits
    NSString *tcinDec = _tcin;
    NSString *tcinBin = [_convert Dec2Bin:(tcinDec)];
    for (int i=(int)[tcinBin length]; i<(int)tcinBinLen; i++) {
        tcinBin = [NSString stringWithFormat:@"0%@", tcinBin];
    }
    
    NSString *serBin = [_convert Dec2Bin:(_ser)];
    for (int i=(int)[serBin length]; i<(int)serBinLen; i++) {
        serBin = [NSString stringWithFormat:@"0%@", serBin];
    }
    
    // The return from Dec2Bin is multiples of 4, so chop off any leading bits for fields that aren't needed
    if ([tcinBin length] > tcinBinLen) {
        tcinBin = [tcinBin substringFromIndex:([tcinBin length] - tcinBinLen)];
    }
    if ([serBin length] > serBinLen) {
        serBin = [serBin substringFromIndex:([serBin length] - serBinLen)];
    }
    
    [self setTcin_bin:[NSString stringWithFormat:@"%@000%@%@",TCIN_Bin_Prefix,tcinBin,serBin]];
    [self setTcin_hex:[_convert Bin2Hex:(_tcin_bin)]];
    
    // Strip leading zeroes before building URI form
    _tcin = [self stripLeadingZeroes:tcinDec];
    _ser  = [self stripLeadingZeroes:_ser];
    
    [self setTcin_uri:[NSString stringWithFormat:@"%@%@.%@",TCIN_URI_Prefix,_tcin,_ser]];
}

- (NSString *)stripLeadingZeroes:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@"^0+"
                                          withString:@""
                                             options:NSRegularExpressionSearch
                                               range:NSMakeRange(0, str.length)];
}

@end
