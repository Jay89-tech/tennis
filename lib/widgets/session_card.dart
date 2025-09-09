import 'package:flutter/material.dart';
import 'package:tennis_training_app/core/app_colors.dart';
import 'package:tennis_training_app/models/training_session_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  final TrainingSessionModel session;

  const SessionCard({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatSessionType(session.sessionType),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                _buildRatingStars(session.rating),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: AppColors.darkGrey),
                const SizedBox(width: 4),
                Text(
                  '${session.duration} min',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: AppColors.darkGrey),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(session.startTime),
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            if (session.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.notes,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (session.videoUrls.isNotEmpty || session.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (session.videoUrls.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.videocam, size: 16, color: AppColors.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          '${session.videoUrls.length} video(s)',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  if (session.imageUrls.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(Icons.photo, size: 16, color: AppColors.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          '${session.imageUrls.length} photo(s)',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatSessionType(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          size: 16,
          color: AppColors.yellow,
        );
      }),
    );
  }
}