//
//  DefaultBankServiceProviderConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBankServiceProviderConnector: BankServiceProviderConnector {

    private let httpBankingRequestFactory: HTTPBankingRequestFactory
    private let webClient: WebClient
    private let supportedBankServicesProvider: SupportedBankServicesProvider

    init(
        httpBankingRequestFactory: HTTPBankingRequestFactory,
        webClient: WebClient,
        supportedBankServicesProvider: SupportedBankServicesProvider
    ) {
        self.httpBankingRequestFactory = httpBankingRequestFactory
        self.webClient = webClient
        self.supportedBankServicesProvider = supportedBankServicesProvider
    }

    func connectToBankService(
        using connectionInformation: BankServiceConnectionInformation
    ) -> Single<ConnectedBankServiceProvider> {

        if let oAuth2ConnectionInformation = connectionInformation as? OAuth2BankServiceConnectionInformation {

            return Single.just(
                ConnectedOAuth2BankServiceProvider(
                    oAuth2ConnectionInformation: oAuth2ConnectionInformation,
                    httpBankingRequestFactory: httpBankingRequestFactory,
                    webClient: webClient,
                    supportedBankServicesProvider: supportedBankServicesProvider
                )
            )
        }
        return Single.error(BankServiceProviderConnectorError.unsupportedConnectionInformation)
    }
}
