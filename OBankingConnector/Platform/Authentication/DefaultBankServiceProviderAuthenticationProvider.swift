//
//  DefaultBankServiceProviderAuthenticationProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBankServiceProviderAuthenticationProvider: BankServiceProviderAuthenticationProvider {

    typealias SupportedBankServiceProviderMap = [BankServiceProvider: BankServiceProviderAuthenticationRequestFactory]

    private let supportedBankServiceProviderMap: SupportedBankServiceProviderMap
    private let bankServiceProviderRequestProcessors: [BankServiceProviderAuthenticationRequestProcessor]

    init(supportedBankServiceProviderMap: SupportedBankServiceProviderMap,
         bankServiceProviderRequestProcessors: [BankServiceProviderAuthenticationRequestProcessor]) {
        self.supportedBankServiceProviderMap = supportedBankServiceProviderMap
        self.bankServiceProviderRequestProcessors = bankServiceProviderRequestProcessors
    }

    func authenticate(against bankServiceProvider: BankServiceProvider)
        -> Single<BankServiceProviderAuthenticationResult> {

        guard let requestFactory = supportedBankServiceProviderMap[bankServiceProvider] else {
            return Single.error(BankServiceProviderAuthenticationProviderError.unsupportedBankServiceProvider)
        }

        let request = requestFactory.makeBankServiceProviderAuthenticationRequest()

        let supportedProcessors = bankServiceProviderRequestProcessors.filter { $0.canProcess(request: request) }
        guard let processor = supportedProcessors.first else {
            return Single.error(BankServiceProviderAuthenticationProviderError.noProperProcessorFound)
        }

        return processor.authenticate(using: request)
    }
}
