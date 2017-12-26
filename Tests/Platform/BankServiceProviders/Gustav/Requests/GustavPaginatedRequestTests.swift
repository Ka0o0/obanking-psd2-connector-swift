//
//  GustavPaginatedRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavPaginatedRequestTests: XCTestCase {

    func test_MakeHTTPRequest_AppendsPaginationInformation() {
        let actualProcessor = RequestMockRequestProcessor()
        let sut = GustavPaginatedRequest(actualRequestProcessor: actualProcessor)

        let result = sut.makeHTTPRequest(
            from: PaginatedBankingRequest(page: 1, itemsPerPage: 20, request: RequestMock())
        )

        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, URL(fileURLWithPath: "test"))

        guard let paramters = result.parameters as? [String: String] else {
            XCTFail("Parameters must not be nil")
            return
        }

        let expectedParamters: [String: String] = [
            "page": "1",
            "size": "20"
        ]
        XCTAssertEqual(paramters, expectedParamters)
    }

    func test_ParseResponse_ParsesResponesProperlyWithoutNextPage() {
        let mockedResponse = "{\"pageNumber\":2,\"pageCount\":3,\"pageSize\":20}"
        guard let mockedResponseData = mockedResponse.data(using: .utf8) else {
            XCTFail("Could not create data from string")
            return
        }

        let actualProcessor = RequestMockRequestProcessor()
        let sut = GustavPaginatedRequest(actualRequestProcessor: actualProcessor)

        do {
            let result = try sut.parseResponse(
                of: PaginatedBankingRequest(page: 1, itemsPerPage: 20, request: RequestMock()),
                response: mockedResponseData
            )

            XCTAssertEqual(result.currentPage, 2)
            XCTAssertEqual(result.totalPages, 3)
            XCTAssertNil(result.nextPage)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_ParseResponse_ParsesResponesProperlyWithNextPage() {
        let mockedResponse = "{\"pageNumber\":2,\"pageCount\":3,\"pageSize\":20,\"nextPage\":3}"
        guard let mockedResponseData = mockedResponse.data(using: .utf8) else {
            XCTFail("Could not create data from string")
            return
        }

        let actualProcessor = RequestMockRequestProcessor()
        let sut = GustavPaginatedRequest(actualRequestProcessor: actualProcessor)

        do {
            let result = try sut.parseResponse(
                of: PaginatedBankingRequest(page: 1, itemsPerPage: 20, request: RequestMock()),
                response: mockedResponseData
            )

            XCTAssertEqual(result.currentPage, 2)
            XCTAssertEqual(result.totalPages, 3)
            XCTAssertEqual(result.nextPage, 3)
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

        override func makeHTTPRequest(from bankingRequest: GustavPaginatedRequestTests.RequestMock) -> HTTPRequest {
            return HTTPRequest(
                method: .get,
                url: URL(fileURLWithPath: "test"),
                parameters: nil,
                encoding: .urlEncoding,
                headers: nil
            )
        }

        override func parseResponse(
            of bankingRequest: GustavPaginatedRequestTests.RequestMock,
            response: Data
        ) throws -> GustavPaginatedRequestTests.RequestMock.Result {
            return RequestMock.Result()
        }
    }
}
