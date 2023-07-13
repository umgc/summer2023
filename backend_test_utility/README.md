# backend_test_utility

Testing project for STeMS Backend Services (backend_services package). Includes unit test, integration tests, and a simple UI for exercising a small subset of backend_services functionality. 

## Getting Started

1. Clone https://github.com/umgc/summer2023.git with git
2. Checkout the development branch (default)
3. In a terminal, cd to the backend_services directory in the repository root and enter `flutter pub get`.
4. cd to the backend_test_utility directory (in the repository root) and enter `flutter pub get`.

At this point, you should be able to run the application, run unit test, or run integration tests in the VS Code IDE depending which file you have open.

## BESie Integration

1. Follow the instructions in BESie/README.md to start the BESie server
2. Open file backend_test_utility/.env and update WS_URL to match the IP address of your development machine where you are running BESie. Localhost will not work, as the host emulator or device needs to connect to your development machine.
3. Follow the instructions in form-filler-extension\README.md to setup the browser extension in Chrome.

Once this is done, you can startup the app (lib/main.dart) and watch the logs in the Debug Console to check the status of the websocket connection. Enter code `8736` in the form filler browser extension to connect to allow fill requests to be picked up by the backend_test_utility for processing.

## Folders

|Folder| Description |
|--|--|
|**test** | Unit tests, no device required |
|**integration_test** | Integration tests, requires a connected device |
|**lib** | Contains entry point main for backend_test_utility application |
