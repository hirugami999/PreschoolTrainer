import 'package:flutter/material.dart';

import 'app_style.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const AppScaffold({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Theme(
    data: AppStyle.theme(Theme.of(context)),
    child: Scaffold(
      backgroundColor: AppStyle.navy,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/math_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Row(
                    children: [
                      if (Navigator.canPop(context))
                        IconButton(
                          tooltip: 'Назад',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: Colors.white,
                          constraints: const BoxConstraints(
                            minWidth: 56,
                            minHeight: 56,
                          ),
                        )
                      else
                        const SizedBox(width: 56),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: child,
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
