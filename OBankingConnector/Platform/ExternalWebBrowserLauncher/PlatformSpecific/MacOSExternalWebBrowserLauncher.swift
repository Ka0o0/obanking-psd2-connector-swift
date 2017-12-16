//
//  MacOSExternalWebBrowserLauncher.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
import Cocoa

#if os(OSX)

final class MacOSExternalWebBrowserLauncher: ExternalWebBrowserLauncher {

    func open(url: URL) -> Single<Void> {
        if NSWorkspace.shared.open(url) {
            return Single.just(())
        } else {
            return Single.error(PlatformDependingExternalWebBrowserLauncherError.unknown)
        }
    }
}

#endif
