//
//  CoinbaseBankingRequestTranslator.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

final class CoinbaseBankingRequestTranslator: BankingRequestTranslator {

    private typealias ProcessorFactory = () -> Any

    private var supportedBankServiceProcessorMap: [String: ProcessorFactory]

    init(baseURL: URL, certificate: Data) {
        supportedBankServiceProcessorMap = [
            String(describing: GetBankAccountRequest.self): {
                CoinbaseGetBankAccountsRequest(baseURL: baseURL, certificate: certificate)
            },
            String(describing: GetBankAccountDetailsRequest.self): {
                CoinbaseGetBankAccountDetailsRequest(baseURL: baseURL, certificate: certificate)
            }
        ]
    }

    func makeProcessor<T>(for bankingRequest: T) -> BankingRequestProcessor<T>? where T: BankingRequest {
        let entry = supportedBankServiceProcessorMap[String(describing: type(of: bankingRequest))]

        guard let factory = entry else {
            return nil
        }

        return factory() as? BankingRequestProcessor<T>
    }
}
