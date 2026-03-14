# Swéy: Premium E-Commerce Flutter Application

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blueviolet.svg)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28.svg)

Swéy is a professional, high-performance e-commerce mobile application built with Flutter. It features a modern, masonry-style product grid, secure Firebase authentication, and a scalable architecture designed to handle a growing catalogue of premium fashion items.

## 🚀 Recent Flutter Apps
*Replace the links below with your portfolio items:*
* [E-Commerce Fashion App (This Repository)](#)
* [Social Networking App Repo](#)
* [Fintech Dashboard Repo](#)

## 🏗️ Code Samples & Architecture

This application employs a modern, layered architecture utilizing **Riverpod** for state management and **GoRouter** for declarative routing. 

### State Management (Riverpod)
Below is an example of how we handle authentication state securely and reactively:

```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
```

### Declarative Routing (GoRouter)
Implementing strict access control and clean navigation flows:

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
```

## ✅ Definition of Done (DoD) & Performance Budgets

We strictly adhere to a rigorous Definition of Done to ensure enterprise-grade quality:

### Definition of Done:
1. **Feature Complete**: All UI components match Figma designs pixel-perfectly.
2. **State Segregation**: UI is entirely decoupled from business logic (Riverpod Providers).
3. **Zero Warnings**: The codebase compiles with zero Dart analyzer warnings or Firebase initialization errors.
4. **Secure Auth**: Firebase Authentication is implemented with robust error handling and duplicate-account safeguards.
5. **No Blind Commits**: Every feature is built incrementally with clear, atomic Git commits demonstrating the development lifecycle.

### Performance Budgets:
- **Build Times**: Keep `performTraversals` under 16ms to ensure 60fps scrolling.
- **Image Optimization**: Heavy assets utilize staggered loading and `ClipRRect` bounding to prevent UI thread blocking.
- **State Updates**: Reactive Riverpod streams ensure only necessary widgets rebuild during state changes (e.g., login, typing).

## 🛠 Getting Started

1. Clone the repository: `git clone <your-repo-url>`
2. Install dependencies: `flutter pub get`
3. Add your `google-services.json` to the Android app directory.
4. Run the app: `flutter run`
