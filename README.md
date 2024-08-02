# MindInSYNC

Welcome to the MindInSync application! This guide will help you set up and run the application on an Android emulator using Flutter.

## Prerequisites

Before you start, make sure you have the following installed:

- Flutter SDK: [Install Flutter](https://docs.flutter.dev/get-started/install)
- Android Studio: [Download Android Studio](https://developer.android.com/studio)
- Visual Studio Code: [Download VSCode](https://code.visualstudio.com/download)

## Getting Started

### Configure Visual Studio Code:
- Open Visual Studio Code
- [Install Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) for VS Code.
- Connect to [Github](https://github.com/umgc/Summer2024/tree/TeamA) to pull in the latest repo
- Verify that you are working out of the "TeamA" branch

### Configure Android Studio
- Open Android Studio
- Install the following components:
    - Android SDK Platform, API 34.0.5
    - Android SDK Command-line Tools
    - Android SDK Build-Tools
    - Android SDK Platform-Tools
    - Android Emulator
- Setup the Android Emulator
    - Go to Tools > Device Manager.
	- Click on Create Virtual Device.
	- Select a device definition and click Next.
	- Select a system image (recommend using the latest stable release) and click Next.
	- Click Finish to create the device.

### Add additional runtime components
- Add the .env file to the root directory
    - This file will contain the OpenAI key needed to connect to ChatGPT.
    - Ex: ```OPEN_AI_API_KEY = " "```
- Add the service account json file to the assets directory
    - This will be used to connect to the Google Cloud Speech-to-Text transcriber. 
    - Ex: ```{
            "type": " ",
            "project_id": " ",
            "private_key_id": " ",
            "private_key": " ",
            "client_email": " ",
            "client_id": " ",
            "auth_uri": " ",
            "token_uri": " ",
            "universe_domain": "googleapis.com"
        }```

### Running the MindInSYNC application
- Pick your emulator that you want to run (ex. Pixel 8 )
    - Run the following command to pick the emulator: ```flutter emulators --launch [emulator_name]```
- Start the emulator: ```flutter run```

## Troubleshooting
- Verify that all dependencies are up-to-date: ```flutter pub get```
- Verify that flutter has all the components it needs to run: ```flutter doctor -v```
- Verify fingerprint/face scan is setup in Android settings:
    - Settings -> Security & Privacy -> Device Unlock
    - Set a PIN then user the Fingerint Unlock function to set up a finger print.
- Verify microphone is enabled on the emulator device:
    - Settings -> Microphone -> Enable "Virtual microphone uses host audio input"
    - Make sure the application prompts with "Use microphone while using" when using the application for the first time.