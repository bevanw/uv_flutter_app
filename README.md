# UV Index Flutter App

A Flutter prototype project for displaying UV Index data based on location in New Zealand.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Install Flutter](https://docs.flutter.dev/get-started/install/windows)
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## VS Code Debugging
- Go to `Run and Debug` and run `uv_flutter_app (debug mode)`.

## Scripts

package.json contains helpful flutter scripts using npm.

## APIs
- [NIWA APIs](https://developer.niwa.co.nz/apis)

## Environmental Variables

Information on environmental variables in Flutter can be found [here](https://itnext.io/secure-your-flutter-project-the-right-way-to-set-environment-variables-with-compile-time-variables-67c3163ff9f4).

In `packages.json`, ensure each `run` command has the argument `--dart-define-from-file=.env`.

For local development, et up a .env file and add the following:
```
NIWA_API_KEY=<API_KEY_HERE>
```