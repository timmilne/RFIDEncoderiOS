//
//  TCINEncoderTests.m
//  RFIDEncoderTests
//
//  Created by Tim.Milne on 2/28/19.
//  Copyright © 2019 Tim.Milne. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCINEncoder.h"

@interface TCINEncoderTests : XCTestCase
{
    TCINEncoder *_encode;
    NSString    *_tcin;
    NSString    *_ser;
    NSString    *_test_tcin_bin;
    NSString    *_test_tcin_hex;
    NSString    *_test_tcin_uri;
    NSString    *_result_tcin_bin;
    NSString    *_result_tcin_hex;
    NSString    *_result_tcin_uri;
    NSString    *_test_empty;
}

@end

@implementation TCINEncoderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (_encode == nil) _encode = [TCINEncoder alloc];
    _test_empty = @"";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWithTcin{
    _tcin   = @"13951442";
    [_encode withTCIN:_tcin];
    _test_tcin_bin = @"0000100000000000000000110101001110000111010010";
    _test_tcin_hex = @"08000353874";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.13951442";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCIN: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCIN: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCIN: Test 1 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCIN: Test 1 Part 4 Failed");
    
    _tcin   = @"14448796";
    [_encode withTCIN:_tcin];
    _test_tcin_bin = @"0000100000000000000000110111000111100010011100";
    _test_tcin_hex = @"08000371E27";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.14448796";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCIN: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCIN: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCIN: Test 2 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCIN: Test 2 Part 4 Failed");
    
    _tcin   = @"16399080";
    [_encode withTCIN:_tcin];
    _test_tcin_bin = @"0000100000000000000000111110100011101011101000";
    _test_tcin_hex = @"080003E8EBA";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.16399080";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCIN: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCIN: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCIN: Test 3 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCIN: Test 3 Part 4 Failed");
}


- (void)testWithTcinSeed{
    unsigned long long seed;
    seed = 7725272730706;
    
    _tcin   = @"13951442";
    [_encode withTCIN:_tcin seed:seed];
    _test_tcin_bin = @"0000100000000000000000110101001110000111010010";
    _test_tcin_hex = @"08000353874";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.13951442";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCINseed: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCINseed: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCINseed: Test 1 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCINseed: Test 1 Part 4 Failed");
    
    _tcin   = @"014448796";
    [_encode withTCIN:_tcin seed:seed];
    _test_tcin_bin = @"0000100000000000000000110111000111100010011100";
    _test_tcin_hex = @"08000371E27";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.14448796";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCINseed: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCINseed: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCINseed: Test 2 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCINseed: Test 2 Part 4 Failed");
    
    _tcin   = @"0016399080";
    [_encode withTCIN:_tcin seed:seed];
    _test_tcin_bin = @"0000100000000000000000111110100011101011101000";
    _test_tcin_hex = @"080003E8EBA";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.16399080";
    _result_tcin_bin = [[_encode tcin_bin] substringToIndex:46];
    _result_tcin_hex = [[_encode tcin_hex] substringToIndex:11];
    _result_tcin_uri = [[_encode tcin_uri] substringToIndex:30];
    
    XCTAssertEqualObjects(_test_tcin_bin , _result_tcin_bin, @"tcinWithTCINseed: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , _result_tcin_hex, @"tcinWithTCINseed: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , _result_tcin_uri, @"tcinWithTCINseed: Test 3 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,         @"tcinWithTCINseed: Test 3 Part 4 Failed");
}

- (void)testWithTcinSer{
    _tcin   = @"16399080";
    _ser     = @"001";
    [_encode withTCIN:_tcin ser:_ser];
    _test_tcin_bin = @"000010000000000000000011111010001110101110100000000000000000000000000000000000000000000000000001";
    _test_tcin_hex = @"080003E8EBA0000000000001";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.16399080.1";
    
    XCTAssertEqualObjects(_test_tcin_bin , [_encode tcin_bin], @"tcinWithTCINser: Test 1 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , [_encode tcin_hex], @"tcinWithTCINser: Test 1 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , [_encode tcin_uri], @"tcinWithTCINser: Test 1 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,           @"tcinWithTCINser: Test 1 Part 4 Failed");
    
    _tcin   = @"13951442";
    _ser     = @"123456789012345";
    [_encode withTCIN:_tcin ser:_ser];
    _test_tcin_bin = @"000010000000000000000011010100111000011101001000011100000100100010000110000011011101111101111001";
    _test_tcin_hex = @"0800035387487048860DDF79";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.13951442.123456789012345";
    
    XCTAssertEqualObjects(_test_tcin_bin , [_encode tcin_bin], @"tcinWithTCINser: Test 2 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , [_encode tcin_hex], @"tcinWithTCINser: Test 2 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , [_encode tcin_uri], @"tcinWithTCINser: Test 2 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,           @"tcinWithTCINser: Test 2 Part 4 Failed");
    
    _tcin   = @"14448796";
    _ser     = @"543210987654321";
    [_encode withTCIN:_tcin ser:_ser];
    _test_tcin_bin = @"000010000000000000000011011100011110001001110001111011100000110000101001111101010000110010110001";
    _test_tcin_hex = @"08000371E271EE0C29F50CB1";
    _test_tcin_uri = @"urn:epc:tag:tcin-96:0.14448796.543210987654321";
    
    XCTAssertEqualObjects(_test_tcin_bin , [_encode tcin_bin], @"tcinWithTCINser: Test 3 Part 1 Failed");
    XCTAssertEqualObjects(_test_tcin_hex , [_encode tcin_hex], @"tcinWithTCINser: Test 3 Part 2 Failed");
    XCTAssertEqualObjects(_test_tcin_uri , [_encode tcin_uri], @"tcinWithTCINser: Test 3 Part 3 Failed");
    XCTAssertTrue([[_encode tcin_bin] length] == 96,           @"tcinWithTCINser: Test 3 Part 4 Failed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
