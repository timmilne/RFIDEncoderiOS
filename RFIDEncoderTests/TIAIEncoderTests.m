//
//  TIAIEncoderTests.m
//  RFIDEncoderTests
//
//  Created by Tim.Milne on 3/1/19.
//  Copyright © 2019 Tim.Milne. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TIAIEncoder.h"

@interface TIAIEncoderTests : XCTestCase
{
    TIAIEncoder *_encode;
    NSString    *_asset_ref;
    NSString    *_asset_id;
    NSString    *_test_tiai_bin;
    NSString    *_test_tiai_hex;
    NSString    *_test_tiai_uri;
    NSString    *_test_empty;
}

@end

@implementation TIAIEncoderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (_encode == nil) _encode = [TIAIEncoder alloc];
    _test_empty = @"";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWithTiaiInt{
    _asset_ref = @"5";
    _asset_id  = @"1";
    [_encode withAssetRef:_asset_ref assetIDDec:_asset_id];
    _test_tiai_bin = @"000010100000000000000101000000000000000000000000000000000000000000000000000000000000000000000001";
    _test_tiai_hex = @"0A0005000000000000000001";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.5.1";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDDec: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDDec: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDDec: Test 1 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDDec: Test 1 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDDec: Test 1 Part 5 Failed");
    
    _asset_ref = @"05";
    _asset_id  = @"01";
    [_encode withAssetRef:_asset_ref assetIDDec:_asset_id];
    _test_tiai_bin = @"000010100000000000000101000000000000000000000000000000000000000000000000000000000000000000000001";
    _test_tiai_hex = @"0A0005000000000000000001";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.5.1";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDDec: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDDec: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDDec: Test 2 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDDec: Test 2 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDDec: Test 2 Part 5 Failed");
    
    _asset_ref = @"5";
    _asset_id  = @"12345678901234";
    [_encode withAssetRef:_asset_ref assetIDDec:_asset_id];
    _test_tiai_bin = @"000010100000000000000101000000000000000000000000000010110011101001110011110011100010111111110010";
    _test_tiai_hex = @"0A00050000000B3A73CE2FF2";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.5.12345678901234";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDDec: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDDec: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDDec: Test 3 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDDec: Test 3 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDDec: Test 3 Part 5 Failed");
}

- (void)testWithTiaiChar{
    _asset_ref = @"7";
    _asset_id  = @"Y2A630";
    [_encode withAssetRef:_asset_ref assetIDChar:_asset_id];
    _test_tiai_bin = @"000010100000000000000111000000000000000000000000000000000000011001110010000001110110110011110000";
    _test_tiai_hex = @"0A0007000000000672076CF0";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.7.Y2A630";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],     @"tiaiWithAssetIDChar: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],     @"tiaiWithAssetIDChar: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],     @"tiaiWithAssetIDChar: Test 1 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec], @"tiaiWithAssetIDChar: Test 1 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,               @"tiaiWithAssetIDChar: Test 1 Part 5 Failed");
    
    _asset_ref = @"07";
    _asset_id  = @"0Y2A630";
    [_encode withAssetRef:_asset_ref assetIDChar:_asset_id];
    _test_tiai_bin = @"000010100000000000000111000000000000000000000000000000110000011001110010000001110110110011110000";
    _test_tiai_hex = @"0A0007000000030672076CF0";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.7.0Y2A630";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],     @"tiaiWithAssetIDChar: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],     @"tiaiWithAssetIDChar: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],     @"tiaiWithAssetIDChar: Test 2 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec], @"tiaiWithAssetIDChar: Test 2 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,               @"tiaiWithAssetIDChar: Test 2 Part 5 Failed");
    
    _asset_ref = @"7";
    _asset_id  = @"y2a630";
    [_encode withAssetRef:_asset_ref assetIDChar:_asset_id];
    _test_tiai_bin = @"000010100000000000000111000000000000000000000000000000000000011001110010000001110110110011110000";
    _test_tiai_hex = @"0A0007000000000672076CF0";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.7.Y2A630";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],     @"tiaiWithAssetIDChar: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],     @"tiaiWithAssetIDChar: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],     @"tiaiWithAssetIDChar: Test 3 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec], @"tiaiWithAssetIDChar: Test 3 Part 4 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,               @"tiaiWithAssetIDChar: Test 3 Part 5 Failed");
}

- (void)testWithTiaiHex{
    _asset_ref = @"8";
    _asset_id  = @"1";
    [_encode withAssetRef:_asset_ref assetIDHex:_asset_id];
    _test_tiai_bin = @"000010100000000000001000000000000000000000000000000000000000000000000000000000000000000000000001";
    _test_tiai_hex = @"0A0008000000000000000001";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.8.1";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDChar: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDChar: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDChar: Test 1 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec],  @"tiaiWithAssetIDChar: Test 1 Part 4 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDChar: Test 1 Part 5 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDChar: Test 1 Part 6 Failed");
    
    _asset_ref = @"08";
    _asset_id  = @"01";
    [_encode withAssetRef:_asset_ref assetIDHex:_asset_id];
    _test_tiai_bin = @"000010100000000000001000000000000000000000000000000000000000000000000000000000000000000000000001";
    _test_tiai_hex = @"0A0008000000000000000001";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.8.1";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDChar: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDChar: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDChar: Test 2 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec],  @"tiaiWithAssetIDChar: Test 2 Part 4 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDChar: Test 2 Part 5 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDChar: Test 2 Part 6 Failed");
    
    _asset_ref = @"8";
    _asset_id  = @"929B35AD6B1BA6B5";
    [_encode withAssetRef:_asset_ref assetIDHex:_asset_id];
    _test_tiai_bin = @"000010100000000000001000000000001001001010011011001101011010110101101011000110111010011010110101";
    _test_tiai_hex = @"0A000800929B35AD6B1BA6B5";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.8.929B35AD6B1BA6B5";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDChar: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDChar: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDChar: Test 3 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec],  @"tiaiWithAssetIDChar: Test 3 Part 4 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDChar: Test 3 Part 5 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDChar: Test 3 Part 6 Failed");
    
    _asset_ref = @"008";
    _asset_id  = @"00929B35AD6B1BA6B5";
    [_encode withAssetRef:_asset_ref assetIDHex:_asset_id];
    _test_tiai_bin = @"000010100000000000001000000000001001001010011011001101011010110101101011000110111010011010110101";
    _test_tiai_hex = @"0A000800929B35AD6B1BA6B5";
    _test_tiai_uri = @"urn:epc:tag:tiai-a-96:0.8.929B35AD6B1BA6B5";
    
    XCTAssertEqualObjects(_test_tiai_bin , [_encode tiai_bin],      @"tiaiWithAssetIDChar: Test 4 Part 1 Failed");
    XCTAssertEqualObjects(_test_tiai_hex , [_encode tiai_hex],      @"tiaiWithAssetIDChar: Test 4 Part 2 Failed");
    XCTAssertEqualObjects(_test_tiai_uri , [_encode tiai_uri],      @"tiaiWithAssetIDChar: Test 4 Part 3 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_dec],  @"tiaiWithAssetIDChar: Test 4 Part 4 Failed");
    XCTAssertEqualObjects(_test_empty    , [_encode asset_id_char], @"tiaiWithAssetIDChar: Test 4 Part 5 Failed");
    XCTAssertTrue([[_encode tiai_bin] length] == 96,                @"tiaiWithAssetIDChar: Test 4 Part 6 Failed");
}

- (void)testChar2Bin2Char{
    NSString *test_input       = @"#-/01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *test_output      = [_encode Char2Bin:test_input];
    NSString *test_round_trip  = [_encode Bin2Char:test_output];
    NSString *test_round_trip2 = [_encode Char2Bin:test_round_trip];
    
    XCTAssertEqualObjects(test_input,  test_round_trip,  @"tiaiChar2Bin2Char: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(test_output, test_round_trip2, @"tiaiChar2Bin2Char: Test 1 Part 2 Failed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
