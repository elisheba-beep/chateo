# chateo

a chat application made using flutter.

## table of contents

- [about the project](#-about-the-project)
- [built with](#-built-with)
- [getting started](#-getting-started)
- [usage](#-usage)

## about the project

this is a very simple chat application, created to have one on one conversations with users registered on the application.

## built with

this is a flutter project. state management using riverpod and firebase firestore for the backend.

- [futter](https://docs.flutter.dev/get-started/learn-flutter)
- [riverpod](https://riverpod.dev/docs/introduction/getting_started)
- [firebase](https://console.firebase.google.com/)

## getting started

to get a copy of this project, follow these instructions.

### prerequisites

before running, make sure you have these installed
- [flutter sdk](https://flutter.dev)
- [dart sdk](https://dart.dev)
- an ide such as [vs code](https://visualstudio.com)
- a physical device or simulator

### installation

```bash
flutter pub get
dart run build_runner build
```

## usage

to run in development mode

```bash
flutter devices
flutter run -d <device_id> #run on a specific device
flutter run -d all #run on all available devices
```

