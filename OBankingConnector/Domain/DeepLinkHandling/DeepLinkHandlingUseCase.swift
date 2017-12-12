//
//  DeepLinkHandlingUseCase.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol DeepLinkHandlingUseCase {

    /// This method has to be called inside the AppDelegate's `application(_:open:options:)` method
    ///
    /// - parameter deepLink The URL provided by the AppDelegate
    ///
    /// - returns true if the url was successfully handled
    func handle(deepLink url: URL) -> Bool
}
