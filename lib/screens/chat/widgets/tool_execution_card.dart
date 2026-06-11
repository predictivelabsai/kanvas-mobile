import 'package:flutter/material.dart';
import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/chat.dart';

class ToolExecutionCard extends StatelessWidget {
  final ToolCall toolCall;
  final bool isActive;

  const ToolExecutionCard({
    super.key,
    required this.toolCall,
    required this.isActive,
  });

  /// Human-readable label for a tool name like "search_listings" -> "Search Listings"
  String get _displayName {
    return toolCall.name
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w)
        .join(' ');
  }

  /// The output a tool returns can contain an embedded chart payload
  /// (`...__ARTIFACT__{json}`) and, for query tools, raw SQL. Neither belongs
  /// in the human-facing summary, so strip them before display.
  String _cleanOutput(String text) {
    var t = text;
    final marker = t.indexOf('__ARTIFACT__');
    if (marker != -1) t = t.substring(0, marker).trim();
    if (t.length > 500) t = '${t.substring(0, 500)}...';
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? AppTheme.blue600.withValues(alpha: 0.4)
                : AppTheme.gray200,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            leading: isActive
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.blue600,
                    ),
                  )
                : Icon(Icons.check_circle, size: 16, color: AppTheme.green600),
            title: Text(
              _displayName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              isActive ? 'Calling...' : 'Done',
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppTheme.blue600 : AppTheme.green600,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              // Output summary only — raw arguments (which can contain SQL or
              // internal params) are intentionally not shown.
              if (toolCall.output != null &&
                  _cleanOutput(toolCall.output!).isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.gray50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _cleanOutput(toolCall.output!),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray500,
                      height: 1.4,
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No additional details.',
                    style: TextStyle(fontSize: 12, color: AppTheme.gray400),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
