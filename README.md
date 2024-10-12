CogniHive App

The CogniHive application comes under a hybrid category that
combines elements of "Education" and "Social Networking". It
offers a seamless platform designed to enhance one’s
academic performance by providing an effective collaboration
of like-minded people.


# CogniHive

CogniHive is a mobile application developed to help students find study partners and create or join study events. It enhances academic collaboration by connecting like-minded individuals and providing a seamless experience for creating and participating in study events. CogniHive is designed for both local and international students, with features such as event creation, event discovery, calendar integration, notifications, and a user-friendly UI with adaptable themes.

## Features

- **Event Creation & Joining**: Create new study events or join existing ones with ease.
- **Google Calendar Integration**: Automatically add events to Google Calendar with a single click.
- **Real-Time Notifications**: Get timely updates and notifications for your signed-up events.
- **Event Search**: Search for study events that match your interests.
- **Adaptable Themes**: Switch between light and dark themes based on your preference.

## Technologies Used

- **Flutter**: Cross-platform mobile development framework.
- **Firebase Authentication**: Handles user sign-up and login via Google authentication.
- **Firestore**: Stores user profile data and event details.
- **Firebase Cloud Messaging**: Manages push notifications for event updates and announcements.
- **Google Calendar**: Integrates with events to schedule them in your calendar using the `url_launcher` package.

## Getting Started

### Prerequisites

To run this project, you will need:

- Flutter SDK (version 3.10 or above).
- Android Studio or VS Code with Flutter plugin installed.
- Firebase account and project setup for authentication and Firestore.
- A Google account for calendar integration.

### Installation

#### 1. Clone the Repository

Use the following command to clone the repository:

```bash
git clone https://github.com/abhirammmmm/CogniHive.git
```

#### 2. Download the ZIP

Alternatively, you can download the project as a ZIP file and extract it:

- Go to the GitHub repository: [CogniHive](https://github.com/abhirammmmm/CogniHive)
- Click on the "Code" button.
- Select "Download ZIP" and extract the contents.

### Firebase Configuration

1. Set up Firebase in your project by visiting the [Firebase Console](https://console.firebase.google.com).
2. Create a Firebase project and enable Authentication and Firestore services.
3. Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place them in the appropriate directories.
4. Update the Firebase credentials in the project files:
   - Modify the **Firebase Authentication** settings in `lib/services/auth_service.dart`.
   - Update Firestore settings in `lib/services/firestore_service.dart`.

### Running the App

1. Open the project in your IDE (VS Code or Android Studio).
2. Install the required dependencies:

```bash
flutter pub get
```

3. Run the project:

```bash
flutter run
```

The app will launch on your connected Android or iOS device or on the emulator.

## How to Use

### 1. **Sign Up / Log In**
   - Users can sign up or log in using Google authentication.

### 2. **Explore Events**
   - View upcoming study events on the dashboard.
   - Search for events using the search bar.

### 3. **Create or Join an Event**
   - Create your own study event with a few simple details.
   - Join an existing event with one click and sync it with your Google Calendar.

### 4. **Real-Time Notifications**
   - Get notifications for the events you are interested in or created.

### 5. **Switch Themes**
   - Toggle between light and dark themes in the app's settings.

## Security Measures

- **User Authentication**: Google sign-in via Firebase ensures secure login.
- **Data Encryption**: All data transmitted between the app and Firestore is encrypted using HTTPS.
- **Firestore Security Rules**: Access to Firestore data is restricted to authorized users only.

## Development

### Project Structure
```plaintext
|-- test
|   |-- eventcard_test.dart           # Unit test for the EventCard widget to ensure proper functionality.
|   |-- login_ui_test.dart            # UI test for the login screen, checking the login flow and UI components.
|
|-- .metadata                         # Metadata used internally by Flutter and Dart tools.
|
|-- web
|   |-- index.html                    # Main entry point for the web version of the app.
|   |-- favicon.png                   # Favicon for the web version.
|   |-- icons                         # Contains the icons used in the web version.
|       |-- Icon-192.png              # Web app icon with 192px size.
|       |-- Icon-maskable-192.png     # Maskable icon for web.
|       |-- Icon-maskable-512.png     # Maskable icon for higher resolution devices.
|       |-- Icon-512.png              # Web app icon with 512px size.
|   |-- manifest.json                 # Manifest file containing metadata like app name, icons, and theme for the web app.
|
|-- print_structure.py                # (Assumed) A Python script for printing or generating the directory structure.
|
|-- ios
|   |-- Runner.xcworkspace            # Xcode workspace for the iOS version of the app.
|       |-- contents.xcworkspacedata  # Stores workspace settings for Xcode.
|       |-- xcshareddata
|           |-- IDEWorkspaceChecks.plist  # Xcode configuration file for workspace checks.
|           |-- WorkspaceSettings.xcsettings  # Custom workspace settings for the iOS project.
|   |-- firebase_app_id_file.json     # Firebase App ID configuration for iOS.
|   |-- RunnerTests
|       |-- RunnerTests.swift         # Swift test file for unit tests on iOS.
|   |-- Runner
|       |-- Runner-Bridging-Header.h  # Bridging header for using Objective-C in Swift.
|       |-- Assets.xcassets           # Directory containing image and icon assets for iOS.
|           |-- LaunchImage.imageset
|               |-- LaunchImage@2x.png  # Launch image for iOS (2x size).
|               |-- LaunchImage@3x.png  # Launch image for iOS (3x size).
|               |-- README.md           # Readme explaining usage of LaunchImage assets.
|               |-- Contents.json       # Metadata for the asset files.
|               |-- LaunchImage.png     # Default launch image for iOS.
|           |-- AppIcon.appiconset      # iOS app icon set with multiple resolutions.
|               |-- Icon-App-76x76@2x.png   # iOS icon (76x76 at 2x resolution).
|               |-- Icon-App-29x29@1x.png   # iOS icon (29x29 at 1x resolution).
|               |-- ...                 # Other icons for different iOS screen sizes and resolutions.
|       |-- GoogleService-Info.plist    # Firebase configuration file for iOS.
|       |-- Base.lproj                 # Directory containing storyboard files for the app’s UI.
|           |-- LaunchScreen.storyboard  # iOS storyboard for the launch screen.
|           |-- Main.storyboard         # iOS storyboard for the main app interface.
|       |-- AppDelegate.swift          # App delegate for handling app lifecycle events in iOS.
|       |-- Info.plist                 # Configuration file containing app metadata for iOS.
|   |-- Runner.xcodeproj               # Xcode project configuration for the iOS app.
|       |-- project.pbxproj            # Main project file used by Xcode to manage the build process.
|       |-- xcshareddata               # Shared data for the Xcode project.
|           |-- xcschemes
|               |-- Runner.xcscheme    # Scheme used for building and running the iOS app.
|
|-- README.md                         # Project README with details about the app, setup instructions, and more.
|-- ATTRIBUTIONS.md                   # Attribution for third-party libraries and assets used in the app.
|-- pubspec.yaml                      # Flutter configuration file specifying dependencies, assets, and fonts.
|
|-- android
|   |-- app
|       |-- build.gradle               # Gradle build script for configuring the Android build.
|       |-- google-services.json       # Firebase configuration file for Android.
|       |-- src
|           |-- androidTest
|               |-- java
|                   |-- com
|                       |-- example
|                           |-- cognihive_version1
|                               |-- MainActivityTest.java  # Test file for Android app's main activity.
|           |-- profile
|               |-- AndroidManifest.xml  # AndroidManifest for profile mode (used during profiling).
|           |-- main
|               |-- res
|                   |-- mipmap-mdpi     # Icons in medium-density resolution for Android.
|                       |-- ic_launcher.png  # App launcher icon for mdpi screens.
|                       |-- launcher_icon.png  # Alternative launcher icon.
|                   |-- mipmap-hdpi     # High-density icons.
|                       |-- ic_launcher.png
|                       |-- launcher_icon.png
|                   |-- drawable        # General drawable resources like images and shapes.
|                       |-- launch_background.xml  # Background used during app launch.
|                   |-- mipmap-xxxhdpi  # Extra high-density icons.
|                   |-- values-night    # Styles for dark mode.
|                       |-- styles.xml  # XML file defining dark mode styles.
|                   |-- values
|                       |-- styles.xml  # XML file defining light mode styles and other general styles.
|                   |-- mipmap-xhdpi    # Extra high-density icons for Android.
|               |-- AndroidManifest.xml  # Main AndroidManifest for declaring app permissions, activities, etc.
|               |-- java
|                   |-- io
|                       |-- flutter
|                           |-- app
|                               |-- FlutterMultiDexApplication.java  # Java class for handling multidex in Flutter.
|               |-- kotlin
|                   |-- com
|                       |-- example
|                           |-- cognihive_version1
|                               |-- MainActivity.kt  # Main entry point for Android in Kotlin.
|           |-- debug
|               |-- AndroidManifest.xml  # AndroidManifest for debug mode.
|   |-- gradle
|       |-- wrapper
|           |-- gradle-wrapper.properties  # Configuration for the Gradle wrapper.
|   |-- build.gradle               # Main build script for the Android project.
|   |-- gradle.properties          # Properties file for configuring Gradle settings.
|   |-- settings.gradle            # Settings file for Gradle, including multi-project configuration.
|
|-- .gradle                          # Gradle-related cache and metadata.
|   |-- 6.8
|   |-- buildOutputCleanup
|   |-- vcs-1
|
|-- lib
|   |-- routes.dart                  # File containing route configurations for navigation between screens.
|   |-- providers
|       |-- firebaseGoogleSigninProvider.dart  # Provider managing Google sign-in using Firebase Authentication.
|   |-- theme_notifier.dart          # Handles theme switching (light/dark mode).
|   |-- firebase_options.dart        # Firebase configuration options for the app.
|   |-- models
|       |-- user_data.dart           # Model representing user data in the app.
|   |-- screens                     # Directory containing all the app’s UI screens.
|       |-- home
|           |-- drawer_item.dart     # Widget for items in the app's navigation drawer.
|           |-- view_event_page.dart  # Screen to view details of a specific event.
|           |-- profile_ui.dart      # Screen displaying user profile and allowing edits.
|           |-- your_events_page.dart  # Screen listing events created by the user.
|           |-- create_event_page.dart  # Screen for creating a new event.
|           |-- new_user_details.dart  # Form to input details for new users during onboarding.
|           |-- home_page.dart       # Main home page displaying available events.
|           |-- my-interested-events.dart  # Screen listing events the user is interested in.
|           |-- search_page.dart     # Search page for finding events based on user queries.
|       |-- Login
|           |-- login_ui.dart        # Login screen with Google sign-in functionality.
|   |-- main.dart                    # Main entry point of the Flutter application.
|   |-- api
|       |-- notification_service.dart  # Handles sending and receiving push notifications.
|       |-- FirebaseApi.dart         # Service file for interacting with Firebase (Auth and Firestore).
|   |-- widgets                      # Directory for reusable UI components.
|       |-- googleSignInButtonWidget.dart  # Widget for Google Sign-In button.
|       |-- event_card.dart          # Widget for displaying event information as a card.
|
|-- assets                           # Directory containing static assets for the app.
|   |-- google_icon.png              # Google icon for sign-in button.
|   |-- Kalam-Regular.ttf            # Custom font used in the app.
|   |-- Kalam-Light.ttf              # Light-weight version of the custom font.
|   |-- Kalam-Bold.ttf               # Bold version of the custom font.
|   |-- App-icon.png                 # App icon for use within the app.
|   |-- OFL.txt                      # Open Font License for the custom fonts.
|   |-- icon.jpeg                    # Generic icon used in the app.
|
|-- coverage                         # Directory containing coverage reports from test runs.
|   |-- lcov.info                    # LCov code coverage report for test coverage.
|
|-- analysis_options.yaml            # Linting rules and analysis options for Dart code quality.
|
|-- .git                             # Git version control folder containing information for repository management.
|   |-- config
|   |-- objects
|   |-- refs
|   |-- logs
|   |-- index
|   |-- hooks
|   |-- ...
```
### Known Issues

- Limited offline functionality.
- The app is currently supported on Android only.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.
