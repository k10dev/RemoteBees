# Remote Bees

Remote Bees is a simple remote job search mobile app. It's a reference implementation for developing portable native iOS and Android apps.

The primary goal of this project is to promote code portability between Swift and Kotlin. It's useful for organizations want to implement native mobile apps but have not found or cannot adopt a cross-platform mobile framework. By using common libraries with exact API, business logics written in Swift or Kotlin can be easily ported to the other platform.

Please note the app is not intended to be fully functional but rather served as a template. Functional features such as, login, sign up, and account management, are currently not implemented.

## Job Listing API

Remotive API, https://remotive.io/api-documentation, is used to provide job listing data for the app. The data is intended for development/demonstration purpose only. If you use this project outside of its intended scope, please follow the Remotive's Terms of Services.

## Open Source Libraries

The following common libraries are used to provide the core components for the app:

| Name | Description | iOS | Android |
|------|-------------|-----|---------|
| CouchbaseLite | Lightweight, embedded, syncable NoSQL database engine for iOS and Android |https://github.com/couchbase/couchbase-lite-ios|https://github.com/couchbase/couchbase-lite-android|
| FlowKit | A library for building finite state machines for iOS and Android | https://github.com/inmotionsoftware/FlowKit/tree/develop | https://github.com/inmotionsoftware/FlowKit/tree/develop |
| HTTPServiceKit & HTTPServiceKt| A lightweight HTTP library for implementing RESTful web services in Swift and Kotlin | https://github.com/inmotionsoftware/HTTPServiceKit| https://github.com/inmotionsoftware/HTTPServiceKt |
| Logging | A logging API for Swift and Kotlin | https://github.com/apple/swift-log | https://github.com/inmotionsoftware/kotlin-log|
| Logging Backend| Logging backend for Swift and Kotlin | https://github.com/inmotionsoftware/swift-log-oslog | https://github.com/inmotionsoftware/kotlin-log-android|
| Lottie | Render After Effects animations natively on Android and iOS, Web, and React Native | https://github.com/airbnb/lottie-ios | https://github.com/airbnb/lottie-android |
| PromiseKit & PromiseKt| Promises for Swift and Kotlin | https://github.com/mxcl/PromiseKit | https://github.com/inmotionsoftware/promisekt |

## Model-View-Flow (MVF)

In this implementation, we introduce a new design pattern, Model-View-Flow (MVF), for modeling business logic and UI as a state machine or flow. MVF can be used in place or complement the commonly used MVC and MVVM design patterns. 

For more information on how to define state machines, please follow the instructions here: https://github.com/inmotionsoftware/FlowKit/tree/develop.

## Remote Bees State Machines

![alt text](https://github.com/k10dev/RemoteBees/blob/main/RemoteBeesFlow/flow/src/main/flows/Startup.png?raw=true)

![alt text](https://github.com/k10dev/RemoteBees/blob/main/RemoteBeesFlow/flow/src/main/flows/Onboard.png?raw=true)

![alt text](https://github.com/k10dev/RemoteBees/blob/main/RemoteBeesFlow/flow/src/main/flows/Login.png?raw=true)

![alt text](https://github.com/k10dev/RemoteBees/blob/main/RemoteBeesFlow/flow/src/main/flows/SignUp.png?raw=true)

![alt text](https://github.com/k10dev/RemoteBees/blob/main/RemoteBeesFlow/flow/src/main/flows/JobBoard.png?raw=true)

## License

MIT
