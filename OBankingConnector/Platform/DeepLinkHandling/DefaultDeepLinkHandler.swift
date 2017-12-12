//
//  DefaultDeepLinkHandler.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultDeepLinkHandler: DeepLinkHandler, DeepLinkProvider {

    var deepLinkTriggered: Observable<URL> {
        return deepLinkPublisher.asObserver()
    }

    private let deepLinkPublisher = PublishSubject<URL>()

    func handle(deepLink url: URL) {
        deepLinkPublisher.on(.next(url))
    }
}
