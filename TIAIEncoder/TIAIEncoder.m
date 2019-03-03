//
//  TIAIEncoder.m
//  RFIDEncoder
//
//  Created by Tim.Milne on 2/28/19.
//  Copyright © 2019 Tim Milne. All rights reserved.
//

#import "TIAIEncoder.h"

// NSString
@import Foundation;

// Convert
#import "Converter.h"

@implementation TIAIEncoder{
    Converter    *_convert;
    NSDictionary *_dictChar2Bin; // 6 - bit character encoding
    NSDictionary *_dictBin2Char;
}

// Use this if the Asset ID is an integer (max 21 digits)
- (void)withAssetRef:(NSString *)assetRefDec
          assetIDDec:(NSString *)assetIDDec {
    
    // Have we done this?
    if (_convert == nil) _convert = [Converter alloc];
    
    // Set the inputs
    [self setAsset_id_dec:assetIDDec];
    [self setAsset_id_char:@""];
    
    // Make sure the inputs are not too long
    if ([_asset_id_dec length] > 21) {
        _asset_id_dec = [_asset_id_dec substringToIndex:21];
    }
    
    // Convert the asset ID to binary
    NSString *assetIDBin = [_convert Dec2Bin:_asset_id_dec];
    
    // Call the binary initializer
    [self withAssetRef:assetRefDec assetIDBin:assetIDBin];
}

// Use this if the Asset ID is a char (max 12 chars)
- (void)withAssetRef:(NSString *)assetRefDec
         assetIDChar:(NSString *)assetIDChar {
    
    // Set the inputs
    [self setAsset_id_dec:@""];
    [self setAsset_id_char:assetIDChar];
    
    // Make sure the inputs are not too long
    if ([_asset_id_char length] > 12) {
        _asset_id_char = [_asset_id_char substringToIndex:12];
    }
    
    // Convert the asset ID to binary
    NSString *assetIDBin = [self Char2Bin:_asset_id_char];
    
    // Call the binary initializer
    [self withAssetRef:assetRefDec assetIDBin:assetIDBin];
}

// Use this if the Asset ID is a hex (max 18 hex digits for 72 bits)
- (void)withAssetRef:(NSString *)assetRefDec
          assetIDHex:(NSString *)assetIDHex{
    
    // Have we done this?
    if (_convert == nil) _convert = [Converter alloc];
    
    // Set the inputs
    [self setAsset_id_dec:@""];
    [self setAsset_id_char:@""];
    [self setAsset_id_hex:assetIDHex];
    
    // Make sure the inputs are not too long
    if ([_asset_id_hex length] > 18) {
        _asset_id_hex = [_asset_id_hex substringToIndex:18];
    }
    
    // Convert the asset ID to binary
    NSString *assetIDBin = [_convert Hex2Bin:_asset_id_hex];
    
    // Call the binary initializer
    [self withAssetRef:assetRefDec assetIDBin:assetIDBin];
}

// Use this if the Asset ID is already a binary (max 72 bits)
- (void)withAssetRef:(NSString *)assetRefDec
          assetIDBin:(NSString *)assetIDBin {
    
    // Have we done this?
    if (_convert == nil) _convert = [Converter alloc];
    
    // Set the inputs
    [self setAsset_ref_dec:assetRefDec];
    [self setAsset_id_bin:assetIDBin];
    
    // We will encode TCINs in a Target proprietary TCIN-96
    int assetRefBinLen = 13;
    int assetRefDecLen = 3;
    int assetIDBinLen  = 72;
    
    // Make sure the inputs are not too long
    if ([_asset_ref_dec length] > assetRefDecLen) {
        _asset_ref_dec = [_asset_ref_dec substringToIndex:assetRefDecLen];
    }
    if ([_asset_id_bin length] > assetIDBinLen) {
        _asset_id_bin = [_asset_id_bin substringToIndex:assetIDBinLen];
    }
    
    // TIAI-96-A - e.g. urn:epc:tag:tiai-a-96:0.0013951442.123456789012345
    //              0800035387487048860DDF79
    //
    // The asset ref is a 3 digit decimal number, and the asset id is a unique 21
    // digit decimal or 12 character code, encoded in 6-bit.
    //
    // Here is how to pack the TIAI-A-96 into the EPC
    // 8 bits are the header: 00001010 or 0x0A (TIAI-A-96)
    // 3 bits are the Filter: 000 (0 All Others)
    // 13 bits are the asset reference: 3 digits
    // 72 bits are the asset ID (21 digits or 12 characters, already encoded into binary)
    // = 96 bits
    _asset_ref_bin = [_convert Dec2Bin:(assetRefDec)];
    for (int i=(int)[_asset_ref_bin length]; i<assetRefBinLen; i++) {
        _asset_ref_bin = [NSString stringWithFormat:@"0%@", _asset_ref_bin];
    }
    
    for (int i=(int)[_asset_id_bin length]; i<(int)assetIDBinLen; i++) {
        _asset_id_bin = [NSString stringWithFormat:@"0%@", _asset_id_bin];
    }
    
    // The return from Dec2Bin is multiples of 4, so chop off any leading bits for fields that aren't
    if ([_asset_ref_bin length] > assetRefBinLen) {
        _asset_ref_bin = [_asset_ref_bin substringFromIndex:([_asset_ref_bin length] - assetRefBinLen)];
    }
    if ([_asset_id_bin length] > assetIDBinLen) {
        _asset_id_bin = [_asset_id_bin substringFromIndex:([_asset_id_bin length] - assetIDBinLen)];
    }
    _asset_id_hex = [_convert Bin2Hex:_asset_id_bin];
    
    [self setTiai_bin:[NSString stringWithFormat:@"%@000%@%@",TIAI_A_Bin_Prefix,_asset_ref_bin,_asset_id_bin]];
    [self setTiai_hex:[_convert Bin2Hex:(_tiai_bin)]];
    
    // Strip leading zeroes before building URI form (note: except for asset_id_char)
    _asset_ref_dec = [self stripLeadingZeroes:_asset_ref_dec];
    _asset_id_dec  = [self stripLeadingZeroes:_asset_id_dec];
    _asset_id_hex  = [self stripLeadingZeroes:_asset_id_hex];
    
    // Use intID or charID if they are set (from above), otherwise use a hex representation of the 72 bit binary
    // number.
    if ([_asset_id_dec length] > 0){
        [self setTiai_uri:[NSString stringWithFormat:@"%@%@.%@",TIAI_A_URI_Prefix,_asset_ref_dec,_asset_id_dec]];
    }
    else if ([_asset_id_char length] > 0) {
        [self setTiai_uri:[NSString stringWithFormat:@"%@%@.%@",TIAI_A_URI_Prefix,_asset_ref_dec,_asset_id_char]];
    }
    else {
        [self setTiai_uri:[NSString stringWithFormat:@"%@%@.%@",TIAI_A_URI_Prefix,_asset_ref_dec,_asset_id_hex]];
    }
}

- (NSString *)stripLeadingZeroes:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@"^0+"
                                          withString:@""
                                             options:NSRegularExpressionSearch
                                               range:NSMakeRange(0, str.length)];
}

- (NSString *)Char2Bin:(NSString *)charStr{
    NSString *binStr = @"";

    if (_dictChar2Bin == nil) [self initDictionaries];
    
    for (int i=0; i < [charStr length]; i++) {
        NSString *charKey = [charStr substringWithRange: NSMakeRange(i, 1)];
        binStr = [NSString stringWithFormat:@"%@%@",binStr,[_dictChar2Bin valueForKey:charKey]];
    }

    return binStr;
}

- (NSString *)Bin2Char:(NSString *)binStr{
    NSString *charStr = @"";
    
    if (_dictBin2Char == nil) [self initDictionaries];
    
    for (int i=0; i < [binStr length]; i+=6) {
        NSString *binKey = [binStr substringWithRange: NSMakeRange(i, 6)];
        charStr = [NSString stringWithFormat:@"%@%@",charStr,[_dictBin2Char valueForKey:binKey]];
    }
    
    return charStr;
}

- (void)initDictionaries {
    if (_dictBin2Char == nil) {
        _dictBin2Char = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"#",@"100011",
                        @"-",@"101101",
                        @"/",@"101111",
                        @"0",@"110000",
                        @"1",@"110001",
                        @"2",@"110010",
                        @"3",@"110011",
                        @"4",@"110100",
                        @"5",@"110101",
                        @"6",@"110110",
                        @"7",@"110111",
                        @"8",@"111000",
                        @"9",@"111001",
                        @"A",@"000001",
                        @"B",@"000010",
                        @"C",@"000011",
                        @"D",@"000100",
                        @"E",@"000101",
                        @"F",@"000110",
                        @"G",@"000111",
                        @"H",@"001000",
                        @"I",@"001001",
                        @"J",@"001010",
                        @"K",@"001011",
                        @"L",@"001100",
                        @"M",@"001101",
                        @"N",@"001110",
                        @"O",@"001111",
                        @"P",@"010000",
                        @"Q",@"010001",
                        @"R",@"010010",
                        @"S",@"010011",
                        @"T",@"010100",
                        @"U",@"010101",
                        @"V",@"010110",
                        @"W",@"010111",
                        @"X",@"011000",
                        @"Y",@"011001",
                        @"Z",@"011010",
                        @" ",@"000000", nil];
    }
    if (_dictChar2Bin == nil) {
        _dictChar2Bin = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"100011",@"#",
                        @"101101",@"-",
                        @"101111",@"/",
                        @"110000",@"0",
                        @"110001",@"1",
                        @"110010",@"2",
                        @"110011",@"3",
                        @"110100",@"4",
                        @"110101",@"5",
                        @"110110",@"6",
                        @"110111",@"7",
                        @"111000",@"8",
                        @"111001",@"9",
                        @"000001",@"A",
                        @"000010",@"B",
                        @"000011",@"C",
                        @"000100",@"D",
                        @"000101",@"E",
                        @"000110",@"F",
                        @"000111",@"G",
                        @"001000",@"H",
                        @"001001",@"I",
                        @"001010",@"J",
                        @"001011",@"K",
                        @"001100",@"L",
                        @"001101",@"M",
                        @"001110",@"N",
                        @"001111",@"O",
                        @"010000",@"P",
                        @"010001",@"Q",
                        @"010010",@"R",
                        @"010011",@"S",
                        @"010100",@"T",
                        @"010101",@"U",
                        @"010110",@"V",
                        @"010111",@"W",
                        @"011000",@"X",
                        @"011001",@"Y",
                        @"011010",@"Z",
                        @"000000",@"", nil];
    }
}

@end
