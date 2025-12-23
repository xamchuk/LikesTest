# Likes Test Task

This repository contains an iOS test task implementation of a Likes module.
The project demonstrates pagination, optimistic UI updates, local caching,
and synchronization with backend services.

---

## Setup Instructions

### Requirements
- macOS
- Xcode (latest stable version recommended)
- iOS Simulator (iOS 16+)

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the project:
   ```bash
   open Likes.xcodeproj
   ```

---

## Architecture Summary

The Likes module is built using a layered architecture with clear separation
of concerns.

### Layers
- **UI Layer**
  - ViewControllers
  - UICollectionView with Diffable Data Source
  - Custom cells and image loading

- **Presentation Layer**
  - ViewModels
  - Combine publishers for state updates

- **Domain Layer**
  - UseCases coordinating business logic
  - Pagination handling
  - Sync orchestration

- **Data Layer**
  - RemoteDataSource for network requests
  - LocalDataSource for cached items and pending actions
  - Lightweight `ImageCache` for disk-based image caching

---

### Data Flow
- Cached data is displayed immediately on screen.
- Network requests update the local cache in the background.
- UI reacts to state changes via Combine.
- User actions are handled optimistically and synchronized with backend services.

---

### Pagination
- The current implementation uses **item ID–based pagination**.
- Pagination requests are triggered during scrolling.
- In a production backend environment, **cursor-based pagination** would be
  preferred for improved consistency.

---

### Sync & Caching
- Optimistic updates provide immediate UI feedback.
- Failed actions are stored locally and retried.
- Items and media assets are cached on disk to reduce network usage.

---

A more detailed description of the architecture can be found in
`ARCHITECTURE.txt`.
