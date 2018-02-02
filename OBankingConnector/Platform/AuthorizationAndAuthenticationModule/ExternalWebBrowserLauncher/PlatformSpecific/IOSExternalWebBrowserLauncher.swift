//
//  IOSExternalWebBrowserLauncher.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

#if os(iOS)

final class IOSExternalWebBrowserLauncher: ExternalWebBrowserLauncher {

    func open(url: URL) -> Single<Void> {
        guard #available(iOS 10.0, *) else {
            if UIApplication.shared.openURL(url) {
                return Single.just(())
            } else {
                return Single.error(PlatformDependingExternalWebBrowserLauncherError.unknown)
            }
        }

        return Single.create { (emitter) -> Disposable in
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    emitter(.success(()))
                } else {
                    emitter(.error(PlatformDependingExternalWebBrowserLauncherError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}

#endif
