//
//  DefaultBankServiceConnectionInformationDecoder.swift
//  OBankingConnector
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public final class DefaultBankServiceConnectionInformationDecoder: BankServiceConnectionInformationDecoder {

    public init() {
    }

    public func decode(data: Data, using decoder: CodeableDecoder) -> BankServiceConnectionInformation? {

        if let connectionInformation = tryToDecode(
            OAuth2BankServiceConnectionInformation.self,
            data: data,
            using: decoder
        ) {
            return connectionInformation
        }

        return nil
    }
}

private extension DefaultBankServiceConnectionInformationDecoder {

    func tryToDecode<T: BankServiceConnectionInformation>(
        _ type: T.Type,
        data: Data,
        using decoder: CodeableDecoder
    ) -> T? {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            return nil
        }
    }
}
