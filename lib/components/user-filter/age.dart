
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/supabase/filter.dart';

class AgeFilter extends StatefulWidget{
  final FilterModel userFilter;
  const AgeFilter({super.key, required this.userFilter});


  @override
  State<AgeFilter> createState() => _AgeFilterState();
}

class _AgeFilterState extends State<AgeFilter> {
  final double _minValue = 16;
  final double _maxValue = 80;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.labelMedium!;

    return Column(
      children: [
        const SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 左右に16のパディングを適用
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左端と右端に配置
            children: [
              Text('${widget.userFilter.minAge}', style: textStyle,),
              Text('~', style: textStyle,),
              Text(' ${widget.userFilter.maxAge}',style: textStyle,),
            ],
          ),
        ),
        RangeSlider(
          values: RangeValues(
              widget.userFilter.minAge.toDouble(),
              widget.userFilter.maxAge.toDouble()
          ),
          min: _minValue,
          max: _maxValue,
          divisions: (_maxValue-_minValue).toInt(),
          onChanged: (RangeValues values) {
            setState(() {
              widget.userFilter.minAge = values.start.toInt();
              widget.userFilter.maxAge = values.end.toInt();
            });
          },
        ),
      ],
    );
  }
}