//
//  AccountNumber.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public protocol AccountNumber {
    
    func equals(other: AccountNumber) -> Bool
}
