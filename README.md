Hotspot Host Onboarding App

A Flutter application designed to onboard hotspot hosts, featuring a modern and interactive UI.

Implemented Features


Core Functionality

1. Experience Selection Screen
  API Integration: Fetches available experiences from the staging API using Dio.
  Selection/Deselection: Tap cards to select or deselect multiple experiences.
  Visual Feedback:
  Unselected cards are grayscale.
  Selected cards display colored images with a purple border and a check icon.
  Additional Details: Multi-line text field with a 250-character limit.
  State Management: Riverpod handles selected IDs and text input.
  Navigation: Logs the current selection and moves to the onboarding question screen.

2. Onboarding Question Screen
   Text Answer: Multi-line text field with a 600-character limit.
   Audio Recording:
    Bottom sheet modal with live waveform animation.
    Timer shows recording duration.
    Options to cancel, save, or delete recordings.
  Video Recording:
    Bottom sheet modal with a camera preview placeholder.
    Timer and recording indicator included.
    Cancel, save, and delete options.
  Dynamic Layout: Recording buttons disappear once media is recorded.
  Keyboard Handling: Layout adjusts automatically when the keyboard appears.


State Management

Riverpod:
  experiencesProvider fetches API data.
  experienceSelectionProvider tracks selected experiences.
  onboardingAnswerProvider stores answers for onboarding questions.
Architecture: Clean separation of providers, models, and services.
API Handling: Dio configured with timeouts and error handling.
  

UI & UX Highlights
Dark Theme: Consistent dark styling throughout the app.
Colors:
  Background: #1A1A1A
  Cards: #2A2A2A
  Primary: #6C63FF (Purple)
  Text: White & gray tones
Typography & Layout: Readable font hierarchy, proper spacing, responsive design.
Animations:
  Smooth transitions for card selection.
  Button width animation when recording options change.
  Live waveform during audio recording.
Loading & Error States: Circular progress indicators and user-friendly messages.


Code Structure

Organized for scalability and readability:

lib/
├── main.dart
├── models/
│   └── experience.dart
├── providers/
│   └── experience_provider.dart
├── screens/
│   ├── experience_selection_screen.dart
│   └── onboarding_question_screen.dart
├── services/
│   └── api_service.dart
└── widgets/
├── experience_card.dart
├── audio_recorder_widget.dart
└── video_recorder_widget.dart

Extra Features

Pixel-perfect design matching Figma specs
Full Riverpod state management
Efficient API handling with Dio
Smooth and responsive animations
Proper keyboard handling and viewport adjustments


Getting Started

Prerequisites

Flutter 3.0.0+
Dart SDK
Android Emulator or iOS Simulator

Installation

git clone <repository-url>
cd hotspot_onboarding
flutter pub get
flutter run

Dependencies

flutter_riverpod – state management
dio – HTTP client for API calls
cached_network_image – image caching

Architecture & API

Providers:
  experiencesProvider – fetches experiences
  experienceSelectionProvider – tracks selections
  onboardingAnswerProvider – stores answers

API:
  Base URL: https://staging.chamberofsecrets.8club.co
  Endpoint: /v1/experiences?active=true
  HTTP handled via Dio with proper error handling


Demo Features

Experience Selection
  Grid of experiences fetched from API
  Tap to select/deselect cards
  Selected cards show color + check icon
  Add optional description
  Navigate to next screen

Onboarding Question
  Text, audio, or video responses supported
  Text input with 600-character limit
  Audio with live waveform and timer
  Video with timer
  Delete media if needed
  Submit answers

Technical Highlights
  Robust error handling for API & user inputs
  Async loading indicators
  Input validation & character limits
  Logging for state debugging
  Clean Material UI with custom dark theme
  Optimized performance with cached images

Completion Status
  All core requirements implemented
  All extra features included
  Clean, modular code
  Engaging UI/UX
  Proper error handling & validation
  Riverpod state management
  API integration with Dio
  Smooth animations throughout