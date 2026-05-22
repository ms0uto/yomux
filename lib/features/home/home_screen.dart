import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo_reader/core/routing/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _horizontalPadding = 20.0;
  static const _sectionSpacing = 28.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            _horizontalPadding,
            20,
            _horizontalPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Yomu',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Scan it. Read it. Remember it.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: _sectionSpacing),
              _StartReadingCard(
                onScan: () => context.push(AppRoutes.ocrWithMode('camera')),
                onImport: () => context.push(AppRoutes.ocrWithMode('gallery')),
              ),
              const SizedBox(height: _sectionSpacing),
              Text(
                'Keep learning',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _LearningCard(
                        label: 'Flashcards',
                        icon: Icons.style_outlined,
                        onTap: () => context.push(AppRoutes.flashcards),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LearningCard(
                        label: 'Stats',
                        icon: Icons.bar_chart_outlined,
                        onTap: () => context.push(AppRoutes.stats),
                      ),
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

class _StartReadingCard extends StatelessWidget {
  const _StartReadingCard({
    required this.onScan,
    required this.onImport,
  });

  final VoidCallback onScan;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 22,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Start reading',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Capture Japanese from books, signs, menus, or screenshots.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _CompactActionButton(
                    label: 'Scan',
                    icon: Icons.camera_alt_outlined,
                    isPrimary: true,
                    onPressed: onScan,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CompactActionButton(
                    label: 'Import',
                    icon: Icons.photo_library_outlined,
                    isPrimary: false,
                    onPressed: onImport,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactActionButton extends StatelessWidget {
  const _CompactActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    );

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}

class _LearningCard extends StatelessWidget {
  const _LearningCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
