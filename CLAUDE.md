# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AppIntentsStudio is a SwiftUI iOS app that demonstrates the capabilities of the AppIntents framework. It showcases how to create intents, entities, and app shortcuts for Siri and Shortcuts app integration.

## Build and Development Commands

This is an Xcode project built with Swift and SwiftUI. Standard Xcode operations apply:

- **Build**: Use Xcode's Product → Build (⌘+B) or build from command line with `xcodebuild`
- **Run**: Use Xcode's Product → Run (⌘+R) to run on simulator or device
- **Test**: Use Xcode's Product → Test (⌘+U) to run unit and UI tests

The project includes three targets:
- `AppIntentsStudio` - Main app target
- `AppIntentsStudioTests` - Unit tests
- `AppIntentsStudioUITests` - UI tests

## Architecture

### Core Components

1. **Collection Model** (`Model/Collection.swift`)
   - Main data model representing collections of items
   - Contains mock data for demonstration purposes
   - Properties: id, name, description, rating, thumbnail images

2. **ModelData** (`Model/ModelData.swift`)
   - Central data manager using `@Observable` macro
   - Manages collection data and provides utility methods
   - Must be marked `@MainActor` for UI updates

3. **CollectionEntity** (`Entities/CollectionEntity.swift`)
   - AppIntents entity conforming to `IndexedEntity`
   - Bridges Collection model to AppIntents framework
   - Provides display representation and search capabilities
   - Includes `CollectionEntityQuery` for entity lookup

4. **OpenCollectionIntent** (`Intents/OpenCollectionIntent.swift`)
   - Core app intent conforming to `OpenIntent`
   - Handles "Open Collection" requests from Siri/Shortcuts

5. **App Shortcuts** (`IntentsStudioAppShortcuts.swift`)
   - Defines system shortcuts for the app
   - Currently provides "Open" shortcut with voice phrases

### Visual Intelligence Integration

The app includes Visual Intelligence search functionality (`VisualSearch/CollectionIntentValueQuery.swift`):
- Uses `SemanticContentDescriptor` for image-based searches
- Implements `IntentValueQuery` for visual search results
- Currently returns all collections as search results (demo implementation)

### Dependency Management

The app uses AppIntents' dependency injection system:
- `ModelData` is registered as a dependency in `AppIntentsStudioApp`
- Entities and intents access `ModelData` via `@Dependency` property wrapper

## Key Patterns

- All UI-related classes use `@MainActor` for thread safety
- Entity queries implement multiple protocols (`EntityQuery`, `EntityStringQuery`, `EnumerableEntityQuery`)
- Display representations use localized strings with table references
- Image URLs are used for entity display representations instead of local assets

## Development Notes

- The project demonstrates both local image assets (`thumbnailImage`) and remote URLs (`thumbnailImageURL`)
- Visual Intelligence features are conditionally compiled with `#if canImport(VisualIntelligence)`
- Mock data is provided for all collections to enable testing without external dependencies