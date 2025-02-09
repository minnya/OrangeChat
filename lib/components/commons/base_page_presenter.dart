
import 'package:flutter/material.dart';

class BasePagePresenter extends StatefulWidget {
  final List<BasePageModel> pages;

  const BasePagePresenter({super.key, required this.pages});

  @override
  State<BasePagePresenter> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<BasePagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                      content: const Text("Do you want to exit?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("OK")),
                      ],
                    ));
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Form(
        key: _formKeys,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () => setState(() {}),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.pages.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (context, idx) {
                  final item = widget.pages[idx];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        Text(item.title,
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(item.description,
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Colors.black54,
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        widget.pages[_currentPage].widget
                      ]),
                    ),
                  );
                },
              ),
            ),

            // Current page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.pages
                  .map((item) =>
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width:
                    _currentPage == widget.pages.indexOf(item) ? 30 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10.0)),
                  ))
                  .toList(),
            ),

            // Bottom buttons
            Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.comfortable,
                      foregroundColor: Colors.black54,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _formKeys.currentState?.validate() == true
                      ? () async {
                    final result = await widget.pages[_currentPage].function();
                    if (result == true &&
                        _currentPage != widget.pages.length - 1) {
                      await _pageController.animateToPage(_currentPage + 1,
                          curve: Curves.easeInOutCubic,
                          duration: const Duration(milliseconds: 250));
                      _formKeys.currentState?.reset();
                    }
                  }
                      : null,
                  child: Row(
                    children: [
                      Text(
                        _currentPage == widget.pages.length - 1
                            ? "Finish"
                            : "Next",
                      ),
                      const SizedBox(width: 8),
                      Icon(_currentPage == widget.pages.length - 1
                          ? Icons.done
                          : Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BasePageModel {
  final String title;
  final String description;
  final Widget widget;
  final Future<bool> Function() function;

  BasePageModel({
    required this.title,
    required this.description,
    required this.widget,
    required this.function,
  });
}