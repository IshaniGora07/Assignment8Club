import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'dart:math' as math;
import '../providers/experience_provider.dart';
import '../models/experience.dart';
import '../widgets/experience_card.dart';
import 'onboarding_question_screen.dart';

class ExperienceSelectionScreen extends ConsumerStatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  ConsumerState<ExperienceSelectionScreen> createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState
    extends ConsumerState<ExperienceSelectionScreen> {
  final TextEditingController _textController = TextEditingController();
  final int _maxCharacters = 250;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final selectionState = ref.read(experienceSelectionProvider);

    developer.log('Selected Experience IDs: ${selectionState.selectedIds}');
    developer.log('Description: ${selectionState.description}');

    if (selectionState.selectedIds.isNotEmpty ||
        selectionState.description.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingQuestionScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an experience or add a description'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final experiencesAsync = ref.watch(experiencesProvider);
    final selectionState = ref.watch(experienceSelectionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: _buildStepBar(3, currentStep: 1),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: experiencesAsync.when(
                data: (experiences) =>
                    _buildContent(experiences, selectionState),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading experiences',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.refresh(experiencesProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      List<Experience> experiences, ExperienceSelectionState selectionState) {
    bool isSelected = selectionState.selectedIds.isNotEmpty ||
        selectionState.description.trim().isNotEmpty;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'What kind of hotspots do\nyou want to host?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select all the kinds of experiences you'd like to host",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 6),
                      itemCount: experiences.length,
                      itemBuilder: (context, index) {
                        final experience = experiences[index];
                        final isSelected =
                        selectionState.selectedIds.contains(experience.id);
                        final rotations = [-0.1, 0.08, -0.09, 0.11, -0.07, 0.09];
                        final rotation = rotations[index % rotations.length];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Transform.rotate(
                            angle: rotation,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: ExperienceCard(
                                  experience: experience,
                                  isSelected: isSelected,
                                  onTap: () {
                                    ref
                                        .read(experienceSelectionProvider.notifier)
                                        .toggleSelection(experience.id);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _textController,
                          maxLines: 4,
                          maxLength: _maxCharacters,
                          style:
                          const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '/ Describe your perfect hotspot',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            counterStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          onChanged: (value) {
                            ref
                                .read(experienceSelectionProvider.notifier)
                                .updateDescription(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    onTap: isSelected ? _handleNext : null,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white.withOpacity(isSelected ? 1.0 : 0.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            'assets/images/next_arrow.png',
                            color: Colors.white.withOpacity(isSelected ? 1.0 : 0.5),
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isSelected)
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
      ],
    );
  }
}