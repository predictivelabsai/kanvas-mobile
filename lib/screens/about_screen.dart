import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kanvas/config/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'K',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kanvas',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your AI Art Advisor',
                    style: TextStyle(fontSize: 15, color: AppTheme.gray500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _sectionTitle('Our Mission'),
            const SizedBox(height: 12),
            Text(
              'Kanvas helps art collectors and advisors make smarter decisions. We combine '
              'auction records, artist databases, and market data with advanced AI to provide '
              'research, valuations, and expert-level analysis -- '
              'all through a simple chat interface.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 12),
            Text(
              'Whether you are researching Estonian contemporary art or tracking Nordic '
              'auction trends, Kanvas surfaces insights, identifies opportunities, and '
              'delivers provenance research tailored to your interests.',
              style: _bodyStyle,
            ),

            const SizedBox(height: 32),

            _sectionTitle('Technology'),
            const SizedBox(height: 12),
            Text(
              'Kanvas is powered by a multi-agent AI system. Eight specialist agents '
              'handle artist lookup, market analysis, auction tracking, valuation, '
              'portfolio analysis, and provenance research, orchestrated by a triage '
              'agent that routes your questions to the right expert.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 12),
            Text(
              'Our data pipeline aggregates auction records and artwork data across '
              'Baltic and Nordic markets, building a comprehensive picture of artist '
              'trajectories and market movements.',
              style: _bodyStyle,
            ),

            const SizedBox(height: 32),

            _sectionTitle('Get in Touch'),
            const SizedBox(height: 12),
            Text(
              'Have questions, feedback, or partnership inquiries? We would love to hear from you.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/contact'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.ink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.mail_outline, size: 18),
                label: const Text('Contact Us'),
              ),
            ),

            const SizedBox(height: 48),

            Center(
              child: Text(
                'Kanvas v1.0.0',
                style: TextStyle(fontSize: 12, color: AppTheme.gray400),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppTheme.ink,
      ),
    );
  }

  static final _bodyStyle = TextStyle(
    fontSize: 14,
    color: AppTheme.gray500,
    height: 1.6,
  );
}
