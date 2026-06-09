import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanvas/config/theme.dart';
import 'package:kanvas/providers/agent_provider.dart';

class WelcomeMessage extends ConsumerWidget {
  final ValueChanged<String> onPromptTap;

  const WelcomeMessage({super.key, required this.onPromptTap});

  static const _fallbackPrompts = [
    'Tell me about Konrad Mägi and his market trajectory',
    'Compare Adamson-Eric and Ado Vabbe as investments',
    'What are the auction trends for Estonian contemporary art?',
    'Estimate the value of an Endel Kõks oil painting from the 1960s',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsync = ref.watch(agentsProvider);

    final prompts =
        agentsAsync.whenOrNull(
          data: (agents) => agents.isNotEmpty
              ? agents.first.examplePrompts
              : _fallbackPrompts,
        ) ??
        _fallbackPrompts;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.ink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'K',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Kanvas AI Advisor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Your intelligent assistant for researching artists, tracking auctions, and analyzing the Baltic art market.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.gray500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Try asking',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray500,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ...prompts
                .take(4)
                .map(
                  (prompt) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PromptChip(
                      text: prompt,
                      onTap: () => onPromptTap(prompt),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PromptChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  size: 16,
                  color: AppTheme.gray400,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.ink,
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppTheme.gray400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
