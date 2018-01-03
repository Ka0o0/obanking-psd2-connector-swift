//
//  GustavPaginatedRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class GustavPaginatedRequestTests: XCTestCase {

    func test_PerformRequest() {
        let actualProcessor = RequestMockRequestProcessor()
        let webClient = WebClientMock()
        let sut = GustavPaginatedRequestProcessor(actualRequestProcessor: actualProcessor)

        let mockedResponse = "{\"pageNumber\":2,\"pageCount\":3,\"pageSize\":20}"
        guard let mockedResponseData = mockedResponse.data(using: .utf8) else {
            XCTFail("Could not create data from string")
            return
        }
        webClient.responseData = mockedResponseData

        do {
            let result = try sut.perform(
                request: PaginatedBankingRequest(page: 1, itemsPerPage: 20, request: RequestMock()),
                using: webClient
            )
            .toBlocking(timeout: 3)
            .single()

            if let parameters = webClient.lastRequest?.parameters as? [String: String] {
                let expectedParamters: [String: String] = [
                    "page": "1",
                    "size": "20"
                ]
                XCTAssertEqual(parameters, expectedParamters)
            } else {
                XCTFail("No request")
            }

            XCTAssertEqual(result.currentPage, 2)
            XCTAssertEqual(result.totalPages, 3)
            XCTAssertNil(result.nextPage)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension GustavPaginatedRequestTests {

    class RequestMock: BankingRequest {
        // swiftlint:disable nesting
        struct Result {
        }
        // swiftlint:enable nesting
    }

    class RequestMockRequestProcessor: BankingRequestProcessor<RequestMock> {

        override func perform(
            request: GustavPaginatedRequestTests.RequestMock,
            using webClient: WebClient
        ) -> Single<GustavPaginatedRequestTests.RequestMock.Result> {
            let fakeHTTPRequest = HTTPRequest(
                method: .get,
                url: URL(fileURLWithPath: "test"),
                parameters: nil,
                encoding: .urlEncoding,
                headers: nil
            )
            return webClient.request(fakeHTTPRequest, certificate: Data())
                .map { _ -> RequestMock.Result in
                    RequestMock.Result()
                }
                .asSingle()
        }
    }
}
