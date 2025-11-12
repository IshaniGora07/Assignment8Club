import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/experience.dart';
import '../services/api_service.dart';

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Experiences Provider
final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getExperiences();
});

// Selected Experiences State
class ExperienceSelectionState {
  final List<int> selectedIds;
  final String description;

  ExperienceSelectionState({
    this.selectedIds = const [],
    this.description = '',
  });

  ExperienceSelectionState copyWith({
    List<int>? selectedIds,
    String? description,
  }) {
    return ExperienceSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
      description: description ?? this.description,
    );
  }
}

// Experience Selection Notifier
class ExperienceSelectionNotifier
    extends StateNotifier<ExperienceSelectionState> {
  ExperienceSelectionNotifier() : super(ExperienceSelectionState());

  void toggleSelection(int id) {
    final currentIds = List<int>.from(state.selectedIds);
    if (currentIds.contains(id)) {
      currentIds.remove(id);
    } else {
      currentIds.add(id);
    }
    state = state.copyWith(selectedIds: currentIds);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void clearSelection() {
    state = ExperienceSelectionState();
  }
}

final experienceSelectionProvider = StateNotifierProvider<
    ExperienceSelectionNotifier, ExperienceSelectionState>(
  (ref) => ExperienceSelectionNotifier(),
);

// Onboarding Answer State
class OnboardingAnswerState {
  final String textAnswer;
  final String? audioPath;
  final String? videoPath;

  OnboardingAnswerState({
    this.textAnswer = '',
    this.audioPath,
    this.videoPath,
  });

  OnboardingAnswerState copyWith({
    String? textAnswer,
    String? audioPath,
    String? videoPath,
    bool clearAudio = false,
    bool clearVideo = false,
  }) {
    return OnboardingAnswerState(
      textAnswer: textAnswer ?? this.textAnswer,
      audioPath: clearAudio ? null : (audioPath ?? this.audioPath),
      videoPath: clearVideo ? null : (videoPath ?? this.videoPath),
    );
  }
}

class OnboardingAnswerNotifier extends StateNotifier<OnboardingAnswerState> {
  OnboardingAnswerNotifier() : super(OnboardingAnswerState());

  void updateTextAnswer(String text) {
    state = state.copyWith(textAnswer: text);
  }

  void setAudioPath(String path) {
    state = state.copyWith(audioPath: path);
  }

  void setVideoPath(String? path) {
    state = state.copyWith(videoPath: path);
  }

  void clearAudio() {
    state = state.copyWith(clearAudio: true);
  }

  void clearVideo() {
    state = state.copyWith(clearVideo: true);
  }
}

final onboardingAnswerProvider =
    StateNotifierProvider<OnboardingAnswerNotifier, OnboardingAnswerState>(
  (ref) => OnboardingAnswerNotifier(),
);
