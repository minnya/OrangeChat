import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  final Future<void> Function(String value) onSubmitted;
  const SearchAppBar({super.key, required this.onSubmitted});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Posts",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _isActive
                  ? Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0)),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Search (English Only)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                              widget.onSubmitted("");
                            });
                          },
                          icon: const Icon(Icons.close))),
                  onSubmitted: (value){
                    if(value.isNotEmpty){
                      widget.onSubmitted(value);
                    }
                  },
                ),
              )
                  : IconButton(
                  onPressed: () {
                    setState(() {
                      _isActive = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}