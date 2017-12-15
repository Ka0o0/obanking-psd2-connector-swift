//
//  AccountNumberMock.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
@testable import OBankingConnector

struct AccountNumberMock: AccountNumber {

    let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }

    func equals(other: AccountNumber) -> Bool {
        return identifier == identifier
    }
}
