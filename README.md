# MindZone App

MindZone is a Flutter-based mobile application designed to support mental health and reduce anxiety. The app allows users to anonymously share their problems and receive advice from the community, fostering a supportive and safe environment.

## Features

- **Anonymous Sharing:** Post your thoughts, problems, or questions without revealing your identity.
- **Community Advice:** Receive helpful advice and support from other users.
- **User-Friendly Interface:** Clean and intuitive design for easy navigation.
- **Real-Time Updates:** Instantly see new posts and responses.

## Tech Stack

- **Flutter:** Cross-platform mobile app development.
- **Firebase:** Backend services including:
    - **Authentication:** Secure and anonymous sign-in.
    - **Firestore:** Real-time database for posts and comments.
    - **Cloud Functions:** Serverless backend logic.
    - **Firebase Storage:** Store images or media (if needed).
    - **Firebase Analytics:** Track user engagement.
    - **Firebase Messaging:** Push notifications for updates.

## Getting Started

1. **Clone the repository:**
     ```bash
     git clone https://github.com/yourusername/MindZone-App.git
     cd MindZone-App
     ```

2. **Install dependencies:**
     ```bash
     flutter pub get
     ```

3. **Set up Firebase:**
     - Create a Firebase project.
     - Add Android/iOS apps in Firebase console.
     - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
     - Place them in the appropriate directories.

4. **Run the app:**
     ```bash
     flutter run
     ```

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

## License

This project is licensed under the MIT License.
