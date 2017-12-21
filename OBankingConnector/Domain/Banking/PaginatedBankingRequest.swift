//
//  PaginatedBankingRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct PaginatedBankingRequest<T: BankingRequest>: BankingRequest {

    public struct Result {
        public let totalPages: Int
        public let currentPage: Int
        public let nextPage: Int?

        public let result: T.Type
    }

    let page: Int
    let itemsPerPage: Int

    public init(page: Int, itemsPerPage: Int) {
        self.page = page
        self.itemsPerPage = itemsPerPage
    }
}