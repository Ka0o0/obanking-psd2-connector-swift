//
//  IBANValidatorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class IBANValidatorTests: XCTestCase {

    // swiftlint:disable line_length
    /// List taken from
    /// https://www.rbs.co.uk/corporate/international/g0/guide-to-international-business/regulatory-information/iban/iban-example.ashx
    // swiftlint:enable line_length
    private let countryIBANMap: [String: String] = [
        "Albania": "AL47212110090000000235698741",
        "Andorra": "AD1200012030200359100100",
        "Austria": "AT611904300234573201",
        "Azerbaijan": "AZ21NABZ00000000137010001944",
        "Bahrain": "BH67BMAG00001299123456",
        "Belgium": "BE62510007547061",
        "Bosnia and Herzegovina": "BA391290079401028494",
        "Bulgaria": "BG80BNBG96611020345678",
        "Croatia": "HR1210010051863000160",
        "Cyprus": "CY17002001280000001200527600",
        "Czech Republic": "CZ6508000000192000145399",
        "Denmark": "DK5000400440116243",
        "Estonia": "EE382200221020145685",
        "Faroe Islands": "FO9754320388899944",
        "Finland": "FI2112345600000785",
        "France": "FR1420041010050500013M02606",
        "Georgia": "GE29NB0000000101904917",
        "Germany": "DE89370400440532013000",
        "Gibraltar": "GI75NWBK000000007099453",
        "Greece": "GR1601101250000000012300695",
        "Greenland": "GL5604449876543210",
        "Hungary": "HU42117730161111101800000000",
        "Iceland": "IS140159260076545510730339",
        "Ireland": "IE29AIBK93115212345678",
        "Israel": "IL620108000000099999999",
        "Italy": "IT40S0542811101000000123456",
        "Jordan": "JO94CBJO0010000000000131000302",
        "Kuwait": "KW81CBKU0000000000001234560101",
        "Latvia": "LV80BANK0000435195001",
        "Lebanon": "LB62099900000001001901229114",
        "Liechtenstein": "LI21088100002324013AA",
        "Lithuania": "LT121000011101001000",
        "Luxembourg": "LU280019400644750000",
        "Macedonia": "MK07250120000058984",
        "Malta": "MT84MALT011000012345MTLCAST001S",
        "Mauritius": "MU17BOMM0101101030300200000MUR",
        "Moldova": "MD24AG000225100013104168",
        "Monaco": "MC9320052222100112233M44555",
        "Montenegro": "ME25505000012345678951",
        "Netherlands": "NL39RABO0300065264",
        "Norway": "NO9386011117947",
        "Pakistan": "PK36SCBL0000001123456702",
        "Poland": "PL60102010260000042270201111",
        "Portugal": "PT50000201231234567890154",
        "Qatar": "QA58DOHB00001234567890ABCDEFG",
        "Romania": "RO49AAAA1B31007593840000",
        "San Marino": "SM86U0322509800000000270100",
        "Saudi Arabia": "SA0380000000608010167519",
        "Serbia": "RS35260005601001611379",
        "Slovak Republic": "SK3112000000198742637541",
        "Slovenia": "SI56191000000123438",
        "Spain": "ES8023100001180000012345",
        "Sweden": "SE3550000000054910000003",
        "Switzerland": "CH9300762011623852957",
        "Tunisia": "TN5910006035183598478831",
        "Turkey": "TR330006100519786457841326",
        "UAE": "AE070331234567890123456",
        "United Kingdom": "GB29NWBK60161331926819"
    ]

    private var sut: IBANValidator!

    override func setUp() {
        super.setUp()

        sut = IBANValidator()
    }

    func test_Validate_ReturnsTrueForValidIBAN() {
        countryIBANMap.forEach { param in
            let country = param.key
            let iban = param.value

            if !self.sut.validate(iban: iban) {
                XCTFail(String(format: "IBAN %@ for country %@ is invalid", iban, country))
            }
        }
    }

    func test_Validate_ReturnsFalseForInalidIBAN() {
        XCTAssertFalse(sut.validate(iban: "AT611904300034573201"))
    }

    func test_Validate_ReturnsFalseForEmptyString() {
        XCTAssertFalse(sut.validate(iban: ""))
    }
}
