<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# OBanking PSD2 Bank API Connector - Swift

*The easiest way of adding banking functionality to your app  💰💵 .* 

## What is this repository about?

The goal of this project is to provide developers the ability to create Apps that connect to various bank APIs in a straight forward manner.
This project is the Swift subproject of the [obanking-psd2-connector project](https://github.com/Ka0o0/obanking-psd2-connector).

## Installation

### Using Cocoapods

Add the OBanking connector project as a framework to your application:

```
pod 'OBankingConnector'
```

## Usage

The OBanking connector is easy and straight forward to use.

### First - Setup

create an **single** instance of the `OBankingConnector` and make it available inside your app:

```swift
let configuration = OBankingConnectorConfiguration(...)

let connector = OBankingConnector(configuration: configuration)
```

### Second - Deep-Link Support

Make sure to handle Deep-Links properly (e.g. used for oAuth2 redirects).

**iOS:**

```swift
public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
	let deepLinkHandler = connector.makeDeepLinkHandler()
	deepLinkHandler.handle(deepLink: url)

	return true
}
```

**macOS:**

```swift
func application(_ application: NSApplication, open urls: [URL]) {
	let deepLinkHandler = connector.makeDeepLinkHandler()
        
	urls.forEach {
		deepLinkHandler.handle(deepLink: $0)
	}
}
```

### Third - Use the connector

That's all! Now you can use the connector to access banking APIs.

This project uses [RxSwift](https://github.com/ReactiveX/RxSwift) so it might be useful to learn the basics before starting with the connector.

#### Example Authentication

In this example we authenticate against Gustav, the Netbanking API from the Česká spořitelna. 

```swift
let provider = connector.makeBankServiceProviderAuthenticationProvider()

let csasBankService = GustavBankServiceProvider()
provider.authenticate(against: csasBankService)
	.debug()
	.subscribe() // you will receive a BankServiceConnectionInformation object here
	.disposed(by: disposeBag)
```

#### Perform requests

Make sure to first authenticate against a bank service provider to obtain a `BankServiceConnectionInformation` object.

Create a `ConnectedBankServiceProvider` using the previously received `BankServiceConnectionInformation`:

```swift
connector.makeBankServiceProviderConnector()
	.connectToBankService(using: connectionInformation)
	.debug()
	.subscribe() // you will receive a ConnectedBankServiceProvider object here
	.disposed(by: disposeBag)
```

Perform the actual request:

```swift
let exampleBankAccount: BankAccount = ...
connectedBankServiceProvider
	.perform(GetTransactionHistoryRequest(bankAccount: exampleBankAccount)
	.debug()
	.subscribe() // you will receive the result of the request here
	.disposed(by: disposeBag)
```

## Supported Banks

Currently the following banks are supported:

- **Česká spořitelna** via *Gustav Netbanking API*
	- Supports Sandbox + Production (just use apropriate the `BankServiceConfiguration`)

## Contribution

A guide of how new bank service providers can be added will be supplied shortly.

## Security

**Certificate Validation:** This project implements certificate pinning for all HTTPS requests as a protection against Man-In-The-Middle attacks. 

**Direct Communication:** Other than that, the OBanking connector does **only** communicate with the bank service provider's servers directly and does not route any traffic via some shady servers.

## License

See [License](LICENSE).

