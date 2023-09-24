# BaseAPI

This repository is part of a larger demo project called the Simple3D Viewer. You can check out the main project [here](https://github.com/hassanvfx/simple3DViewer).

This framework was built with the [ios-framework config tool](https://github.com/hassanvfx/ios-framework).

## Overview

The BaseAPI exposes async functions that return a Result type with the corresponding optional payload, encapsulating all network errors and handlers within the module. It is considered a Base component as it links CoreModels into this module.

## Core Dependencies

The Core layer allows for atomic or composite modules distinguished with the Base prefix to reflect their composite nature and represent that its dependency is final. A Base module can be safely linked to any module within the Middleware as well with other Core Modules. In this case, we will be linking the BaseAPI both, in the Main Application and also within the LoginKit component.

## Global Notifications

Some API errors may raise app state level changes. For example, if a JWT token is returned invalid and the server returns a 401 code, it is common to sign out the user to enable the user to obtain a new session token. This kind of global context errors are published to the NotificationCenter, then the application or modules can subscribe for such specific events and respond accordingly, allowing for both indirect global observation and modularization.

## Shared Instance

When abstracting the API in its own module, we also separate the app state and thus the session state. But given the API requires a session token, it arises the challenge of how to access this state. A more elegant solution would be to share the already coordinated/configured instance when instantiating components that also require BaseAPI interaction.

## Moya API

We use the external library Moya as our API abstraction Layer. Moya offers a declarative and powerful DSL that allows to handle all common requirements from HTTP methods, headers, payload structure as well as more advanced integrations like Combine providers. The goal is to provide a robust solution that can encapsulate all of the API concerns and exposes an async/await friendly interface for calling the endpoints. The retry count, delay and error handling are all part of the BaseAPI module.

## API Mocking

Moya already provides a sampleData getter that we can use to easily mock the return data. However this requires configuring the Moya.Provider with a stubClosure.

## API Session

While this example won’t cover any calls that would require it, it’s still worth to provide a way to showcase the solution that can support an internal session state, meaning that when it’s present we can properly attach a JWT token to all authenticated requests.

## Dependencies

This project depends on the following packages:

- [S3DCoreModels](https://github.com/hassanvfx/s3d-coremodels)
- [Moya](https://github.com/Moya/Moya)

## License

This project is licensed under the terms of the MIT license.
