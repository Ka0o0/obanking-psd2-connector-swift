//
//  DeepLinkProviderMock.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
@testable import OBankingConnector

final class DeepLinkProviderMock: DeepLinkProvider {

    var nextRequestResponse: URL?

    var deepLinkTriggered: Observable<URL> {
        if let responseURL = nextRequestResponse {
            return Observable.just(responseURL)
        } else {
            return Observable.error(DeepLinkProviderMockError.noResponseProvided)
        }
    }
}

enum DeepLinkProviderMockError: Error {
    case noResponseProvided
}
