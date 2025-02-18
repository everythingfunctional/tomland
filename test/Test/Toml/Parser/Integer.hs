module Test.Toml.Parser.Integer
    ( integerSpecs
    ) where

import Test.Hspec (Spec, context, describe, it)

import Test.Toml.Parser.Common (integerFailOn, parseInteger)


integerSpecs :: Spec
integerSpecs = describe "integerP" $ do
    context "when the integer is in decimal representation" $ do
        it "can parse positive integer numbers" $ do
            parseInteger "10" 10
            parseInteger "+3" 3
            parseInteger "0"  0
        it "can parse negative integer numbers" $
            parseInteger "-123" (-123)
        it "can parse sign-prefixed zero as an unprefixed zero" $ do
            parseInteger "+0" 0
            parseInteger "-0" 0
        it "can parse both the minimum and maximum numbers in the 64 bit range" $ do
            parseInteger "-9223372036854775808" (-9223372036854775808)
            parseInteger "9223372036854775807"  9223372036854775807
        it "can parse numbers with underscores between digits" $ do
            parseInteger "1_000" 1000
            parseInteger "5_349_221" 5349221
            parseInteger "1_2_3_4_5" 12345
        it "does not parse incorrect underscores" $ do
            integerFailOn "1_2_3_"
            integerFailOn "13_"
            integerFailOn "_123_"
            integerFailOn "_13"
            integerFailOn "_"
        it "does not parse numbers with leading zeros" $ do
            parseInteger "0123" 0
            parseInteger "-023" 0
    context "when the integer is in binary representation" $ do
        it "can parse numbers prefixed with `0b`" $ do
            parseInteger "0b1101" 13
            parseInteger "0b0"    0
        it "does not parse numbers prefixed with `0B`" $
            parseInteger "0B1101" 0
        it "can parse numbers with leading zeros after the prefix" $ do
            parseInteger "0b000"   0
            parseInteger "0b00011" 3
        it "does not parse negative numbers" $
            parseInteger "-0b101" 0
        it "does not parse numbers with non-valid binary digits" $
            parseInteger "0b123" 1
    context "when the integer is in octal representation" $ do
        it "can parse numbers prefixed with `0o`" $ do
            parseInteger "0o567" 0o567
            parseInteger "0o0"   0
        it "does not parse numbers prefixed with `0O`" $
            parseInteger "0O567" 0
        it "can parse numbers with leading zeros after the prefix" $ do
            parseInteger "0o000000" 0
            parseInteger "0o000567" 0o567
        it "does not parse negative numbers" $
            parseInteger "-0o123" 0
        it "does not parse numbers with non-valid octal digits" $
            parseInteger "0o789" 0o7
    context "when the integer is in hexadecimal representation" $ do
        it "can parse numbers prefixed with `0x`" $ do
            parseInteger "0x12af" 0x12af
            parseInteger "0x0"    0
        it "does not parse numbers prefixed with `0X`" $
            parseInteger "0Xfff" 0
        it "can parse numbers with leading zeros after the prefix" $ do
            parseInteger "0x00000" 0
            parseInteger "0x012af" 0x12af
        it "does not parse negative numbers" $
            parseInteger "-0xfff" 0
        it "does not parse numbers with non-valid hexadecimal digits" $
            parseInteger "0xfgh" 0xf
        it "can parse numbers when hex digits are lowercase" $
            parseInteger "0xabcdef" 0xabcdef
        it "can parse numbers when hex digits are uppercase" $
            parseInteger "0xABCDEF" 0xABCDEF
        it "can parse numbers when hex digits are in both lowercase and uppercase" $ do
            parseInteger "0xAbCdEf" 0xAbCdEf
            parseInteger "0xaBcDeF" 0xaBcDeF
    context "when there is underscore in hexadecimal, octal and binary representation" $ do
        it "can parse numbers with underscore in hexadecimal representation" $ do
            parseInteger "0xAb_Cd_Ef" 0xabcdef
            parseInteger "0xA_bcd_ef" 0xabcdef
            parseInteger "0x123_abc" 0x123abc
            parseInteger "0xa_b_c_1_2_3" 0xabc123
        it "can't parse when underscore is between hexadecimal prefix and suffix" $ do
            integerFailOn "0x_Abab_ca"
            integerFailOn "0x_ababbac"
        it "can parse numbers with underscore in octal representation" $ do
            parseInteger "0o12_34_56" 0o123456
            parseInteger "0o1_2345_6" 0o123456
            parseInteger "0o76_54_21" 0o765421
            parseInteger "0o4_5_3_2_6" 0o45326
        it "can't parse when underscore is between octal prefix and suffix" $ do
            integerFailOn "0o_123_4567"
            integerFailOn "0o_1234567"
        it "can parse numbers with underscore in binary representation" $ do
            parseInteger "0b10_101_0" 42
            parseInteger "0b10_10_10" 42
            parseInteger "0b1_0_1" 5
            parseInteger "0b1_0" 2
        it "can't parse numbers when underscore is between binary prefix and suffix" $ do
            integerFailOn "0b_10101_0"
            integerFailOn "0b_101010"
        it "doesn't parse underscore not followed by any numbers" $ do 
            integerFailOn "0b_"
            integerFailOn "0o_"
            integerFailOn "0x_"
        it "doesn't parse when number is ending with underscore" $ do 
            integerFailOn "0b101_110_"
            integerFailOn "0b10101_"
            integerFailOn "0x1_23_daf_"
            integerFailOn "0x1214adf_"
            integerFailOn "0o1_15_41_"
            integerFailOn "0o1215147_"
            
       
