//
//  BankServiceConnectionInformationDecoder.swift
//  OBankingConnector
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public protocol BankServiceConnectionInformationDecoder {

    func decode(data: Data, using decoder: CodeableDecoder) -> BankServiceConnectionInformation?
}

public protocol CodeableDecoder {

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: CodeableDecoder {
}
