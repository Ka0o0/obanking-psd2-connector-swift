//
//  DefaultDeepLinkHandlerTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import OBankingConnector

class DefaultDeepLinkHandlerTests: XCTestCase {

    func test_handle_PublishesURL() {
        guard let url = URL(string: "https://duckduckgo.com") else {
            XCTFail("Failed to create URL")
            return
        }

        let sut = DefaultDeepLinkHandler()
        let disposeBag = DisposeBag()

        let publishExpectation = expectation(description: "Deep link should be published")
        sut.deepLinkTriggered.subscribe(onNext: { _ in
            publishExpectation.fulfill()
        })
            .disposed(by: disposeBag)
        sut.handle(deepLink: url)

        wait(for: [publishExpectation], timeout: 1)
    }
}
