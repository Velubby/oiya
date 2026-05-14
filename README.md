# OIYA - External Memory System

A Flutter-based "external memory system" designed to help users quickly capture and remember important information. OIYA emphasizes simplicity, speed, and human-centered design.

## Core Philosophy

- **Quick Capture**: Record thoughts in seconds before they're forgotten
- **Thought Dump Mode**: Rapid entry of multiple ideas without organization pressure
- **Smart Search**: Full-text search with context-aware results
- **Auto Context**: The app learns from user patterns over time
- **Memory Resurfacing**: Intelligent reminders of past thoughts at relevant moments

## Features Implemented

### ✅ Core Features
- **Quick Capture Screen**: Fast, focused text input with keyboard-first UX
- **Memory List View**: Chronological display of all captured memories
- **Smart Search**: Full-text search across all memories with instant results
- **Memory Resurfacing**: Shows memories from 7, 14, and 30 days ago
- **Theme Support**: Light, dark, and system theme modes with persistence

### ✅ Technical Stack
- **Frontend**: Flutter + Material 3 Design
- **State Management**: Flutter Riverpod
- **Local Storage**: Hive (fast, embedded database)
- **Utilities**: UUID for unique IDs, intl for internationalization

## Project Structure

```
lib/
├── main.dart                          # App initialization with Hive setup
├── src/
│   ├── app.dart                       # Material app root with theming
│   ├── features/
│   │   ├── memory/
│   │   │   ├── memory_note.dart       # Memory data model
│   │   │   ├── memory_repository.dart # Hive persistence layer
│   │   │   └── memory_controller.dart # Riverpod state management
│   │   └── settings/
│   │       ├── theme_repository.dart  # Theme persistence
│   │       └── theme_mode_controller.dart # Theme state
│   └── ui/
│       └── main_shell.dart            # UI shell with navigation
│
```

## Getting Started

### Prerequisites
- Flutter SDK (3.5.4+)
- Dart SDK
- Android Studio or Xcode (for running on device/emulator)

### Installation

```bash
# Get dependencies
flutter pub get

# Run the app (adjust target as needed)
flutter run -d <device>

# Examples:
flutter run -d android     # Android emulator
flutter run -d ios         # iOS simulator
flutter run -d windows     # Windows desktop
```

## Usage

### Quick Capture
1. Navigate to the **Capture** tab
2. Type your thought or memory
3. Press **Simpan Memory** to save

### View Memories
- **Home Tab**: Browse all memories in reverse chronological order
- Tap on any memory card to view full details

### Search Memories
1. Go to the **Search** tab
2. Type keywords to find relevant memories
3. Instant full-text search across all memories

### Memory Resurfacing
- Navigate to the **Resurface** tab
- See memories from exactly 7, 14, or 30 days ago
- Perfect for revisiting important past thoughts

### Change Theme
- Go to **Settings** tab
- Choose between System, Light, or Dark theme

## Future Enhancements (Phase 2+)

- [ ] Backup & Sync support (Firebase/Supabase)
- [ ] Memory tagging and categorization
- [ ] Rich text formatting
- [ ] Audio/image attachments
- [ ] Sharing memories
- [ ] Collaborative features
- [ ] Mobile & Web sync

## Development Notes

### Architecture Decisions
- **Riverpod**: For reactive state management with testable, composable providers
- **Hive**: For offline-first local storage with excellent performance
- **Material 3**: Modern, accessible UI components

### Key Providers
- `memoryControllerProvider`: Main state holder for all memories
- `filteredMemoriesProvider`: Computed search results
- `resurfacedMemoriesProvider`: Memories at key intervals (7/14/30 days)
- `themeModeProvider`: Current theme mode state

## License

Private project - All rights reserved.
