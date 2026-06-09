import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kanvas/config/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(),
              _StatsRow(),
              _FeaturesSection(),
              _HowItWorksSection(),
              _AgentsBar(),
              _BottomCta(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      color: AppTheme.gray50,
      child: Column(
        children: [
          Text(
            'Kanvas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your AI Art Advisor.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Research artists, track auctions, and value artworks across the Baltic and Nordic markets.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.gray500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go('/auth/login'),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.go('/about'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.ink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Learn More'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  static const _stats = [
    _Stat('8', 'AI Agents'),
    _Stat('1000+', 'Artists'),
    _Stat('6', 'Countries'),
    _Stat('5+', 'Auction Houses'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Row(
        children: _stats
            .map((s) => Expanded(child: _StatCard(stat: s)))
            .toList(),
      ),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            Text(
              stat.value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat.label,
              style: TextStyle(fontSize: 12, color: AppTheme.gray500),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  static const _features = [
    _Feature(
      Icons.palette_outlined,
      'Artist Research',
      'Look up any Estonian or Baltic artist — biography, exhibition history, auction results, and market trajectory.',
    ),
    _Feature(
      Icons.insights_outlined,
      'Market Intelligence',
      'Track auction trends, price indices, and market movements across Baltic and Nordic art markets.',
    ),
    _Feature(
      Icons.calculate_outlined,
      'Valuation',
      'Get data-driven artwork valuations powered by auction records and comparable sales analysis.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.gray50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        children: [
          Text(
            'What Kanvas Does',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 24),
          ..._features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FeatureCard(feature: f),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  const _Feature(this.icon, this.title, this.description);
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(feature.icon, size: 24, color: AppTheme.ink),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.gray500,
                      height: 1.5,
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
}

class _HowItWorksSection extends StatelessWidget {
  static const _steps = [
    _Step(
      '1',
      'Ask About Art',
      'Describe what you want to know — an artist, a medium, market trends, or a specific artwork.',
    ),
    _Step(
      '2',
      'AI Agents Research',
      'Our 8 specialist agents search auction records, artist databases, and market data.',
    ),
    _Step(
      '3',
      'Get Expert Insights',
      'Receive curated analysis with valuations, comparisons, and provenance research.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        children: [
          Text(
            'How it Works',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 24),
          ..._steps.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _StepRow(step: s),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step {
  final String number;
  final String title;
  final String description;
  const _Step(this.number, this.title, this.description);
}

class _StepRow extends StatelessWidget {
  final _Step step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.ink,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step.number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.gray500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AgentsBar extends StatelessWidget {
  static const _agents = [
    'Artist Lookup',
    'Market Analyst',
    'Auction Tracker',
    'Valuator',
    'Portfolio Analyst',
    'Provenance Checker',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.gray50,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            'Specialist AI Agents',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _agents.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    _agents[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray400,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          Text(
            'Ready to explore the art market?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join collectors and advisors who trust Kanvas for smarter art decisions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/auth/login'),
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.go('/about'),
                child: Text(
                  'About',
                  style: TextStyle(color: AppTheme.gray500, fontSize: 13),
                ),
              ),
              Text(' | ', style: TextStyle(color: AppTheme.gray400)),
              TextButton(
                onPressed: () => context.go('/contact'),
                child: Text(
                  'Contact',
                  style: TextStyle(color: AppTheme.gray500, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
