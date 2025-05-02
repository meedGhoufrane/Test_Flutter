# Blitz Partner

A modern mobile application built with Flutter that connects users with delivery riders for on-demand delivery services.

![Flutter Version](https://img.shields.io/badge/Flutter-3.7+-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.7+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Overview

Blitz Partner is a comprehensive rider delivery request application that allows users to request delivery services, track delivery status, and manage delivery history. The application features a clean, intuitive UI built with Material Design principles.

## Features

- **Real-time Rider Availability**: Check when the next rider will be available
- **Request a Rider**: Easily request a delivery rider with your phone number
- **Request History**: View your past and current delivery requests
- **Request Status Tracking**: Monitor the status of your requests (Pending, Accepted, Completed, Cancelled)
- **Search Functionality**: Find specific delivery requests
- **Command Management**: View and manage delivery commands
- **Profile Management**: View and update user profile information

## Screenshots

(Add your app screenshots here)

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Stateful Widgets (with potential to migrate to more robust solutions)
- **HTTP Requests**: http package
- **Date/Time Handling**: intl package

## Project Structure

The project follows a modular architecture for maintainability and scalability:

```
lib/
├── config/           # Configuration files
├── models/           # Data models
│   ├── delivery_request.dart
│   └── rider_info.dart
├── screens/          # Application screens
│   ├── commands_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── request_history_screen.dart
│   ├── search_screen.dart
│   └── tab_controller_screen.dart
├── services/         # API and other services
│   └── api_service.dart
├── utils/            # Utility functions
├── widgets/          # Reusable UI components
│   ├── request_form_dialog.dart
│   ├── request_list_item.dart
│   ├── rider_availability_card.dart
│   └── success_notification.dart
└── main.dart         # Application entry point
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/blitz-partner.git
```

2. Navigate to the project directory:
```bash
cd blitz-partner
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Development Setup

### Prerequisites

- Flutter SDK (version 3.7 or higher)
- Dart SDK (version 3.7 or higher)
- An IDE (VS Code, Android Studio, or IntelliJ)
- Android or iOS device/emulator

### API Configuration

The application is currently using mock data for development purposes. When ready to connect to a real backend:

1. Update the `_useMockData` flag in `api_service.dart` to `false`
2. Configure your API endpoints in `config/api_config.dart`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design for the UI inspiration

---

Developed with ❤️ by [Mohammed Ghoufarne  Youcode ]
