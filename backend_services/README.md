<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

.ENV SETUP: The .env file is used to store the paths for the s3 buckets used for the diarization service.

```dart
const like = 'sample';
```

## Additional information

### RecordingSelectionActivator

The `RecordingSelectionActivator` is an interface that specifies a `Future<void> getSelectorCallback()` method.

The idea is that the front-end application can provide a callback to the backend to trigger a conversation selection screen for the form filler browser extension. On selection of a conversation on this screen, the front-end can call `Agent.extractFormValues()` with the selected conversation guid to kick off completion of the form fill request. A `RecordingSelectionActivator` implementing object is required to initialize the Agent as a parameter to `Agent.initialize()`.

Expected flow is:

1. The browser extension API receives a request over BESie on the "/topic/form-model" topic.
2. The API checks the app instance code and calls the previously provided RecordingSelectionActivator instance.
3. The activator is responsible for displaying the UI for the user to select a recording and calling `Agent.extractFormValues()` with the selected recording guid.
4. The browser extension API will query ChatGPT and then send the results back to BESie on the filled-form topic.

### Using Mocks

Flutter package [Mockito](https://pub.dev/packages/mockito) is uses to provide mocks in unit tests. Mocks can be enabled for a test with an annotation and import pair such as this one from `browser_extension_api_test.dart`:

```
@GenerateNiceMocks([MockSpec<RecordingSelectionActivator>()])
import 'browser_extension_api_test.mocks.dart';
```

If the target of the mock is updated, then the mock should be recreated. This can be done by running the command `dart run build_runner build` in the package directory.
