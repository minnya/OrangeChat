import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';

// You can replace these colors with your theme or custom color values.
class AppColors {
  static const Color secondaryContainerGray = Color(0xFFB0BEC5);
  static const Color ratingPrimaryColor =
      Color(0xFFFFD700); // Gold color for rating stars
}

enum Size { small, medium, large }

class StarRatingWidget extends StatefulWidget {
  final int starCount;
  final double rating;
  final Size? size;
  final EdgeInsets? padding;
  final Color? color;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final Alignment? alignment;
  final void Function(int starIndex)? onStarTap;

  const StarRatingWidget(
      {super.key,
      this.starCount = 5, // Default to 5 stars
      this.rating = 0.0, // Default rating is 0
      this.size = Size.medium,
      this.color,
      this.onStarTap,
      this.alignment,
      this.onTap,
      this.padding,
      this.textStyle});

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.rating;
  }

  // Method to build each individual star based on the rating and index
  Widget buildStar(final BuildContext context, final int index) {
    double starSize = widget.size == Size.small
        ? 16
        : widget.size == Size.medium
            ? 24
            : 32;
    Icon icon;
    // If the index is greater than or equal to the rating, we show an empty star
    if (index >= currentRating) {
      icon = Icon(
        Icons.star_border, // Empty star
        size: starSize,
        color: AppColors.secondaryContainerGray, // Light gray for empty stars
      );
    }
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > currentRating - 1 && index < currentRating) {
      icon = Icon(
        Icons.star_half, // Half star
        size: starSize,
        color: widget.color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    // Otherwise, we show a full star
    else {
      icon = Icon(
        Icons.star, // Full star
        size: starSize,
        color: widget.color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    return icon;
  }

  @override
  Widget build(final BuildContext context) {
    double labelSize = widget.size == Size.small
        ? 12
        : widget.size == Size.medium
            ? 16
            : 20;
    // Creating a row of stars based on the starCount
    return CustomContainer(
      onTap: widget.onTap,
      alignment: widget.alignment,
      direction: Direction.HORIZONTAL,
      padding: widget.padding,
      children: List.generate(
            widget.starCount, // Generate a row with 'starCount' stars
            (final index) => buildStar(context, index),
          ) +
          [
            CustomContainer(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Text(
                  currentRating.toStringAsFixed(1),
                  style: widget.textStyle != null
                      ? widget.textStyle?.copyWith(fontSize: labelSize)
                      : TextStyle(fontSize: labelSize),
                ),
              ],
            )
          ],
    );
  }
}
