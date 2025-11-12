import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../providers/experience_provider.dart';

import '../widgets/audio_recorder_widget.dart';
import '../widgets/video_recorder_widget.dart';

class OnboardingQuestionScreen extends ConsumerStatefulWidget {
  const OnboardingQuestionScreen({super.key});

  @override
  ConsumerState<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState
    extends ConsumerState<OnboardingQuestionScreen> {
  final TextEditingController _textController = TextEditingController();
  final int _maxCharacters = 600;
  bool _showInlineAudioRecorder = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final answerState = ref.read(onboardingAnswerProvider);

    developer.log('Text Answer: ${answerState.textAnswer}');
    developer.log('Audio Path: ${answerState.audioPath}');
    developer.log('Video Path: ${answerState.videoPath}');

    if (answerState.textAnswer.isEmpty &&
        answerState.audioPath == null &&
        answerState.videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an answer (text, audio, or video)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Onboarding submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  Widget _buildStepBar(int totalSteps, {required int currentStep}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Container(
          width: 60,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: isActive
                ? const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF9196FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : const LinearGradient(
              colors: [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      }),
    );
  }

  void _showVideoRecorder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoRecorderWidget(
        onRecordingComplete: (path) {
          ref.read(onboardingAnswerProvider.notifier).setVideoPath(path);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answerState = ref.watch(onboardingAnswerProvider);
    final isNextEnabled =
        (answerState.textAnswer.trim().isNotEmpty) ||
            (answerState.audioPath != null && answerState.audioPath!.isNotEmpty) ||
            (answerState.videoPath != null && answerState.videoPath!.isNotEmpty);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildStepBar(3, currentStep: 2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 🔹 Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why do you want to host\nwith us?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us about your intent and what motivates you to create experiences.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 📝 Text Field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _textController,
                          maxLines: 6,
                          maxLength: _maxCharacters,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'I want to host because...',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            counterStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          onChanged: (value) {
                            ref
                                .read(onboardingAnswerProvider.notifier)
                                .updateTextAnswer(value);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🎙️ Audio Recorder (UI only)
                      if (_showInlineAudioRecorder)
                        const InlineAudioRecorder(),

                      // 🎥 Video Preview (only if video exists)
                      if (answerState.videoPath != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Recorded Video:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(onboardingAnswerProvider.notifier).clearVideo();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Video deleted'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_outlined,
                                    color: Color(0xFF6C63FF),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Bottom Actions
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              color: const Color(0xFF1A1A1A),
              child: Row(
                children: [
                  // 🎙️ Audio + Video Controls
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        // 🎤 Mic Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showInlineAudioRecorder =
                              !_showInlineAudioRecorder;
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.mic_none_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),

                        // Divider
                        SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                            thickness: 1.5,
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(width: 5),

                        // 🎥 Video Button
                        GestureDetector(
                          onTap: () => _showVideoRecorder(context),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.videocam_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 🔹 Next Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        height: 52,
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF101010),
                                    Color(0xFF505050),
                                    Color(0xFF101010),
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: isNextEnabled ? _handleNext : null,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(
                                              isNextEnabled ? 1.0 : 0.5),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white.withOpacity(
                                            isNextEnabled ? 1.0 : 0.5),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (!isNextEnabled)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
