//
//  GustavBankingRequestTranslator.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavBankingRequestTranslator: BankingRequestTranslator {

    private typealias ProcessorFactory = () -> Any

    private var supportedBankServiceProcessorMap: [String: ProcessorFactory]

    init(baseURL: URL, certificate: Data) {
        supportedBankServiceProcessorMap = [
            String(describing: GetBankAccountRequest.self): {
                GustavGetBankAccountsRequest(baseURL: baseURL, certificate: certificate)
            },
            String(describing: GetBankAccountDetailsRequest.self): {
                GustavGetBankAccountDetailsRequest(baseURL: baseURL, certificate: certificate)
            },
            String(describing: GetTransactionHistoryRequest.self): {
                GustavGetTransactionHistoryRequest(baseURL: baseURL, certificate: certificate)
            },
            String(describing: GetDateFilteredTransactionHistoryRequest.self): {
                GustavGetDateFilteredTransactionHistoryRequest(baseURL: baseURL, certificate: certificate)
            },
            String(describing: PaginatedBankingRequest<GetBankAccountRequest>.self): {
                GustavPaginatedRequestProcessor(
                    actualRequestProcessor: GustavGetBankAccountsRequest(
                        baseURL: baseURL,
                        certificate: certificate
                    )
                )
            },
            String(describing: PaginatedBankingRequest<GetTransactionHistoryRequest>.self): {
                GustavPaginatedRequestProcessor(
                    actualRequestProcessor: GustavGetTransactionHistoryRequest(
                        baseURL: baseURL,
                        certificate: certificate
                    )
                )
            },
            String(describing: PaginatedBankingRequest<GetDateFilteredTransactionHistoryRequest>.self): {
                GustavPaginatedRequestProcessor(
                    actualRequestProcessor: GustavGetDateFilteredTransactionHistoryRequest(
                        baseURL: baseURL,
                        certificate: certificate
                    )
                )
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
