//
//  GustavPaginatedRequestResponse.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavPaginatedRequestResponse: Codable {

    let pageNumber: Int
    let pageCount: Int
    let pageSize: Int
    let nextPage: Int?
}
