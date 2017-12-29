//
//  ISO8601JSONDateDecodingStrategy.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

let ISO8601JSONDateDecodingStrategy: ((Decoder) throws -> Date) = { decoder -> Date in
    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    throw DateError.invalidDate
}

enum DateError: String, Error {
    case invalidDate
}
