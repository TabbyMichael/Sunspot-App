# Sunspot Solar Management Platform

A comprehensive Flutter-based solar energy management application designed for solar companies to manage leads, installations, quotes, orders, and e-commerce operations. The app features role-based access control, real-time state management, and a modern dark/light theme UI.

## 🌟 Features

### Core Features
- **Role-Based Authentication**: Secure login system with JWT tokens and role-based routing (Customer, Staff, Admin)
- **Dark/Light Theme**: Dynamic theme switching with persistent state
- **Navigation Drawer**: Context-aware navigation based on user role
- **Real-time State Management**: BLoC pattern for efficient state handling

### Lead Management
- View and manage customer leads
- Track lead status (New, Contacted, Qualified, Lost, Converted)
- Add notes to leads
- Filter and search leads
- Demo data for offline testing

### Installation Tracking
- Monitor installation progress with timeline UI
- Track installation steps and status
- Visual progress indicators
- Installation history and details

### Quotes Management
- Create and manage quotes
- Track quote status
- Role-based quote views
- Demo quote data

### Orders Management
- Track customer orders
- Monitor order status
- Order history and details
- Demo order data

### E-commerce
- **Product Catalog**: Browse solar products with images, ratings, and reviews
- **Category Filtering**: Filter by product categories (Solar Panels, Inverters, Batteries, etc.)
- **Search**: Search products by name
- **Shopping Cart**: Add products, manage quantities
- **Checkout**: Simple checkout flow
- **Stock Status**: Real-time stock availability

### Notifications
- View system notifications
- Mark as read/unread
- Mark all as read functionality
- Notification categories

### Settings
- Profile management
- Theme toggle (Dark/Light mode)
- Push notifications preferences
- Logout functionality

## 🛠 Tech Stack

### Core
- **Flutter**: ^3.11.5
- **Dart**: ^3.11.5

### State Management
- **flutter_bloc**: ^8.1.3
- **equatable**: ^2.0.5

### Networking
- **dio**: ^5.4.0
- **retrofit**: ^4.0.3
- **json_annotation**: ^4.8.1

### UI Components
- **cupertino_icons**: ^1.0.8
- **go_router**: ^12.1.3

## 📁 Project Structure

```
sunspot/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_theme.dart
│   │   │   └── theme_bloc.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   └── secure_storage_service.dart
│   │   ├── models/
│   │   │   └── user.dart
│   │   └── router/
│   │       └── app_router.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── bloc/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── leads/
│   │   ├── installations/
│   │   ├── quotes/
│   │   ├── orders/
│   │   ├── products/
│   │   ├── notifications/
│   │   └── settings/
│   └── shared/
│       ├── widgets/
│       │   ├── buttons/
│       │   ├── cards/
│       │   ├── inputs/
│       │   └── badges/
│       └── widgets/
│           └── layout/
├── android/
├── ios/
└── pubspec.yaml
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.11.5 or higher)
- Dart SDK (3.11.5 or higher)
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/TabbyMichael/Sunspot-App.git
cd Sunspot-App/sunspot
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

For specific platform:
```bash
flutter run -d android    # Android
flutter run -d ios        # iOS
flutter run -d chrome     # Web
flutter run -d windows    # Windows
```

## 📱 Screens

### Authentication
- **Login Screen**: Secure login with email and password

### Dashboards
- **Customer Dashboard**: E-commerce focused with cart summary and featured products
- **Staff Dashboard**: Quick access to leads, installations, quotes, and orders
- **Admin Dashboard**: Full system overview

### Lead Management
- **Leads List**: View all leads with status badges
- **Lead Detail**: View lead details, add notes, update status

### Installation Management
- **Installations List**: View all installations with progress indicators
- **Installation Detail**: View timeline and step-by-step progress

### E-commerce
- **Products Catalog**: Grid view with product images, ratings, and prices
- **Cart Screen**: View cart items, manage quantities, checkout
- **Product Cards**: Category badges, stock status, ratings

### Other Features
- **Quotes Screen**: View and manage quotes
- **Orders Screen**: View and manage orders
- **Notifications Screen**: View system notifications
- **Settings Screen**: Profile, theme toggle, preferences

## 🎨 Theme

The app supports both dark and light themes:
- **Dark Mode**: Dark gray backgrounds, white text, amber accents
- **Light Mode**: White backgrounds, dark text, amber accents
- Theme preference is persisted across sessions

## 🔐 Authentication

The app uses JWT-based authentication:
- Secure token storage using Flutter Secure Storage
- Automatic token refresh
- Role-based access control
- Protected routes with guards

## 📡 API Integration

The app is set up for REST API integration:
- Dio for HTTP requests
- Request/response interceptors
- Automatic token injection
- Error handling and logging
- Demo data fallback for offline testing

## 🧪 Demo Data

For demonstration purposes, the app includes:
- Mock lead data (3 sample leads)
- Mock product data (8 solar products)
- Mock installation data
- Mock quote and order data

## 📝 Future Enhancements

- [ ] Real backend API integration
- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Offline support with local storage
- [ ] Analytics and reporting
- [ ] Customer support chat
- [ ] Document upload for installations
- [ ] Video call support for consultations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Author

**Tabby Michael**

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication inspiration
- Unsplash for product images

---

Built with ❤️ using Flutter
