//
//  URLBuilder.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class URLBuilder {

    private let baseUrl: URL
    private var queryParameters: [(String, String)] = []

    init(from baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    func append(queryParameter: (String, String)) {
        queryParameters.append(queryParameter)
    }

    func build() -> URL? {
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            return nil
        }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []

        queryParameters.forEach { queryParameter in
            let queryItem = URLQueryItem(name: queryParameter.0, value: queryParameter.1)
            queryItems.append(queryItem)
        }

        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
