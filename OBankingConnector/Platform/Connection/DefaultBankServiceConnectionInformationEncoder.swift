//
//  DefaultBankServiceConnectionInformationEncoder.swift
//  OBankingConnector
//
//  Created by Kai Takac on 29.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public final class DefaultBankServiceConnectionInformationEncoder: BankServiceConnectionInformationEncoder {

    public init() {
    }

    public func encode(
        connectionInformation: BankServiceConnectionInformation,
        using encoder: CodeableEncoder
    ) -> Data? {

        if let oAuth2ConnectionInformation = connectionInformation as? OAuth2BankServiceConnectionInformation {
            return try? encoder.encode(oAuth2ConnectionInformation)
        }

        return nil
    }
}
