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

        #if os(iOS)
            return IOSExternalWebBrowserLauncher().open(url: url)
        #elseif os(OSX)
            return MacOSExternalWebBrowserLauncher().open(url: url)
        #else
            return Single.error(PlatformDependingExternalWebBrowserLauncherError.unsupported)
        #endif
    }
}

enum PlatformDependingExternalWebBrowserLauncherError: Error {
    case unsupported
    case unknown
}
