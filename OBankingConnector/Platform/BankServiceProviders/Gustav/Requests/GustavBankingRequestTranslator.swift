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

    init(baseURL: URL) {
        supportedBankServiceProcessorMap = [
            String(describing: GetBankAccountRequest.self): {
                GustavGetBankAccountsRequest(baseURL: baseURL)
            },
            String(describing: GetBankAccountDetailsRequest.self): {
                GustavGetBankAccountDetailsRequest(baseURL: baseURL)
            },
            String(describing: GetTransactionHistoryRequest.self): {
                GustavGetTransactionHistoryRequest(baseURL: baseURL)
            },
            String(describing: GetDateFilteredTransactionHistoryRequest.self): {
                GustavGetDateFilteredTransactionHistoryRequest(baseURL: baseURL)
            },
            String(describing: PaginatedBankingRequest<GetBankAccountRequest>.self): {
                GustavPaginatedRequest(actualRequestProcessor: GustavGetBankAccountsRequest(baseURL: baseURL))
            },
            String(describing: PaginatedBankingRequest<GetTransactionHistoryRequest>.self): {
                GustavPaginatedRequest(actualRequestProcessor: GustavGetTransactionHistoryRequest(baseURL: baseURL))
            },
            String(describing: PaginatedBankingRequest<GetDateFilteredTransactionHistoryRequest>.self): {
                GustavPaginatedRequest(
                    actualRequestProcessor: GustavGetDateFilteredTransactionHistoryRequest(baseURL: baseURL)
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
