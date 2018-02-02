//
//  BankServiceConnectionInformationEncoder.swift
//  OBankingConnector
//
//  Created by Kai Takac on 29.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public protocol BankServiceConnectionInformationEncoder {

    func encode(
        connectionInformation: BankServiceConnectionInformation,
        using encoder: CodeableEncoder
    ) -> Data?
}

public protocol CodeableEncoder {

    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: CodeableEncoder {
}
