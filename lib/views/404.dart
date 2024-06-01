import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;


class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse(html.window.location.href);
    final Map<String, String> queryParams = uri.queryParameters;

    return Scaffold(
      body: Center(
        child: CustomContainer(
          constraints: const BoxConstraints(maxWidth: 600),
          children: [
            Icon(
              Icons.error_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              '404',
              style: TextStyle(
                fontSize: 80,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'The page you are looking for might have been removed,\n'
                  'had its name changed, or is temporarily unavailable.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            CustomContainer(
              alignment: Alignment.centerLeft,
              width: 400,
              children: [
                ...queryParams.entries.map((entry) {
                  return Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}