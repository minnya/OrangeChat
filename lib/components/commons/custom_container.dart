import 'package:flutter/cupertino.dart';

class CustomContainer extends StatelessWidget {
  final Direction? direction;
  final List<Widget>? children;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final bool expand;

  const CustomContainer({
    super.key,
    this.direction,
    this.children,
    this.padding,
    this.alignment,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.onTap,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        alignment: alignment,
        color: color,
        decoration: decoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        child: direction == Direction.HORIZONTAL
            ? Row(
          crossAxisAlignment: _mapAlignmentToCrossAxisAlignment(alignment),
          mainAxisAlignment: _mapAlignmentToMainAxisAlignment(alignment),
          children: children ?? [],
        )
            : Column(
          crossAxisAlignment: _mapAlignmentToCrossAxisAlignment(alignment),
          mainAxisAlignment: _mapAlignmentToMainAxisAlignment(alignment),
          children: children ?? [],
        ),
      ),
    );

    return expand ? Expanded(child: container) : container;
  }

  CrossAxisAlignment _mapAlignmentToCrossAxisAlignment(Alignment? alignment) {
    if (alignment == Alignment.topLeft ||
        alignment == Alignment.centerLeft ||
        alignment == Alignment.bottomLeft) {
      return CrossAxisAlignment.start;
    } else if (alignment == Alignment.topRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.bottomRight) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.center;
    }
  }

  MainAxisAlignment _mapAlignmentToMainAxisAlignment(Alignment? alignment) {
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.topLeft ||
        alignment == Alignment.topRight) {
      return MainAxisAlignment.start;
    } else if (alignment == Alignment.bottomCenter ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomRight) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.center;
    }
  }
}

enum Direction { VERTICAL, HORIZONTAL }
