# Sunspot

Sunspot is a modern Flutter application for managing the full solar customer and operations journey in one place. It brings together product discovery, quoting, order tracking, installations, notifications, and role-based dashboards for both customers and staff.

Built for solar teams that need speed, clarity, and a mobile-first experience, Sunspot turns fragmented workflows into a connected platform.

<img src="/assets/1.png" width="600" height="700" />


<img src="/assets/2.png" width="600" height="700" />


## Vision

Sunspot is designed to be the digital operating system for a solar business.

Instead of splitting work across spreadsheets, messaging apps, admin portals, and disconnected storefronts, Sunspot creates a single experience where:

- customers can explore products, request quotes, track orders, and monitor their installation journey
- internal teams can manage leads, quotes, orders, and field progress from one interface
- both sides stay aligned through real-time visibility and role-aware workflows

<img src="/assets/3.png" width="600" height="700" />


<img src="/assets/4.png" width="600" height="700" />


## Core Experience

Sunspot currently delivers a multi-feature mobile application with:

- role-based authentication for customers and staff
- dedicated dashboards tailored to each user type
- solar product catalog browsing with cart support
- quote management and quote-related workflows
- order management and order tracking
- installation management with timeline views
- leads management for internal teams
- notifications and settings screens
- light mode and dark mode support

<img src="/assets/5.png" width="600" height="700" />


<img src="/assets/6.png" width="600" height="700" />


## Product Highlights

### Customer App

- personalized dashboard with savings, orders, quotes, and installation summaries
- in-app solar shopping experience with product cards and cart flow
- visibility into quotes, active orders, and installation progress
- simple, mobile-first navigation for non-technical users

<img src="/assets/7.png" width="600" height="700" />


<img src="/assets/8.png" width="600" height="700" />


### Staff App

- operational dashboard for solar teams
- lead management workflows
- installation tracking and timeline access
- order and quote visibility for internal follow-up

## Architecture

Sunspot uses a feature-oriented Flutter architecture with clear separation of concerns.

### Stack

- Flutter
- Dart
- `flutter_bloc` for state management
- `go_router` for app navigation
- `dio` and `retrofit` for API communication
- `flutter_secure_storage` for token and credential persistence

### Project Structure

```text
lib/
  core/
    models/
    router/
    services/
    theme/
  features/
    auth/
    dashboard/
    leads/
    installations/
    orders/
    products/
    quotes/
    notifications/
    settings/
  shared/
    widgets/
```


<img src="/assets/9.png" width="600" height="700" />


<img src="/assets/10.png" width="600" height="700" />


### Design Principles

- feature-first organization for maintainability and scale
- reusable shared widgets for consistent UI
- role-aware routing and access control
- theme-driven design for light and dark mode support
- repository + bloc pattern for testable business logic

## Routing Overview

Sunspot includes a protected navigation model powered by `go_router`.

Main flows include:

- `/login`
- `/dashboard`
- `/dashboard/shop`
- `/dashboard/cart`
- `/dashboard/leads`
- `/dashboard/installations`
- `/dashboard/quotes`
- `/dashboard/orders`
- `/dashboard/notifications`
- `/dashboard/settings`

The dashboard destination is role-aware, with separate customer and staff experiences.

## Why Sunspot Matters

Solar businesses need more than a storefront. They need a system that supports:

- customer trust through transparency
- faster quote-to-installation cycles
- better coordination between office and field teams
- a polished brand experience on mobile
- scalable operations as the business grows

Sunspot is built to support that shift.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio, VS Code, or another Flutter-ready editor
- Android emulator, iOS simulator, or physical device

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Analyze the Project

```bash
flutter analyze
```

## Development Notes

The app currently uses a mix of API-backed repositories and demo/mock data depending on the feature. This makes it possible to iterate on UI and experience while backend integrations continue to mature.

Key implementation areas:

- authentication is connected through a dedicated auth flow
- product browsing includes mock solar catalog data
- dashboards and operations screens are organized by feature
- theme management is centralized under `core/theme`

## Future Direction

Sunspot is positioned to grow into a full solar lifecycle platform. Natural next steps include:

- richer customer profiles and household energy insights
- payment workflows and financing integration
- field technician workflows and job assignment
- installation photo uploads and completion evidence
- analytics dashboards for operators and management
- real-time status sync with backend systems
- offline-friendly support for field use

## Brand Position

Sunspot is not just a utility app. It is a product-facing solar platform that should feel:

- clean
- trustworthy
- operationally strong
- premium on mobile
- easy for customers and efficient for teams

That product standard should guide future design and engineering decisions.

## Contributing

If you are extending Sunspot, aim to preserve:

- feature-based organization
- reusable component patterns
- strong theme support across light and dark mode
- clean mobile layouts with careful handling of smaller screens

## License

This project is private and intended for internal or controlled distribution unless explicitly relicensed by the project owners.
