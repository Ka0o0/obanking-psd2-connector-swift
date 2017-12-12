//
//  PlatformDependingWebBrowserLauncher.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class PlatformDependingExternalWebBrowserLauncher: ExternalWebBrowserLauncher {

    func open(url: URL) -> Single<Void> {

        #if TARGET_OS_IOS
            return IOSExternalWebBrowserLauncher().open(url: url)
        #endif

        #if TARGET_OS_MAC
            return MacOSExternalWebBrowserLauncher().open(url: url)
        #endif

        return Single.error(PlatformDependingExternalWebBrowserLauncherError.unsupported)
    }
}

enum PlatformDependingExternalWebBrowserLauncherError: Error {
    case unsupported
    case unknown
}
