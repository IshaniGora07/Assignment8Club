import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final VoidCallback onTap;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5961FF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.transparent : Colors.grey,
                  isSelected ? BlendMode.dst : BlendMode.saturation,
                ),
                child: CachedNetworkImage(
                  imageUrl: experience.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF2A2A2A),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[700],
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          experience.name,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon
                    if (experience.iconUrl.isNotEmpty)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CachedNetworkImage(
                          imageUrl: experience.iconUrl,
                          fit: BoxFit.contain,
                          color: Colors.white,
                          errorWidget: (context, url, error) =>
                              const SizedBox(),
                        ),
                      ),

                    // Name
                    Text(
                      experience.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
