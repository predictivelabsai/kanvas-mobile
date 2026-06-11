class AgentOut {
  final String slug;
  final String name;
  final String category;
  final String icon;
  final String oneLiner;
  final String prefix;
  final List<String> examplePrompts;

  const AgentOut({
    required this.slug,
    required this.name,
    required this.category,
    required this.icon,
    required this.oneLiner,
    required this.prefix,
    required this.examplePrompts,
  });

  // Defensive parsing: the API may omit optional fields (e.g. `prefix`).
  // A missing required String previously threw and silently emptied the
  // agents list in the sidebar.
  factory AgentOut.fromJson(Map<String, dynamic> json) => AgentOut(
    slug: json['slug'] as String? ?? '',
    name: json['name'] as String? ?? '',
    category: json['category'] as String? ?? '',
    icon: json['icon'] as String? ?? '•',
    oneLiner: (json['one_liner'] ?? json['description'] ?? '') as String,
    prefix: json['prefix'] as String? ?? '',
    examplePrompts:
        (json['example_prompts'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
  );
}
