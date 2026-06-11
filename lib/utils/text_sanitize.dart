/// Safety net for assistant text: occasionally the LLM prefaces an answer
/// with the raw SQL it (thinks it) ran, e.g.
///   "SELECT COUNT(*) ... FROM kanvas.auction_lots ... ILIKE '%Mägi%'Mägi was..."
/// The backend prompt forbids this, but we strip a leading SQL statement
/// client-side as defense-in-depth so users never see a query.
///
/// Conservative by design: only acts when the text *starts* with SELECT/WITH
/// AND references the `kanvas.` schema, so ordinary prose is never touched.
library;

final RegExp _schemaRef = RegExp(r'FROM\s+kanvas\.', caseSensitive: false);

final RegExp _leadingSql = RegExp(
  // A leading SELECT/WITH statement, greedily up to the LAST typical terminal
  // clause (so chained clauses like "ORDER BY x DESC LIMIT 10" are fully
  // consumed): an ILIKE '%...%' literal, a LIMIT n, or a trailing ASC/DESC.
  r"^\s*(?:SELECT|WITH)\b[\s\S]*(?:'%[^']*%'|LIMIT\s+\d+|\b(?:ASC|DESC)\b)\s*",
  caseSensitive: true,
);

String stripLeadingSql(String text) {
  final head = text.length > 600 ? text.substring(0, 600) : text;
  final upper = text.trimLeft();
  final startsSql =
      upper.length >= 4 &&
      (upper.toUpperCase().startsWith('SELECT') ||
          upper.toUpperCase().startsWith('WITH '));
  if (!startsSql || !_schemaRef.hasMatch(head)) return text;
  return text.replaceFirst(_leadingSql, '').trimLeft();
}

final RegExp _technicalError = RegExp(
  r'psycopg|sqlalchemy|relation\s|syntax error|\bSELECT\b|\bFROM\b|UndefinedTable|'
  r'traceback|exception|stacktrace',
  caseSensitive: false,
);

/// Convert a raw backend error into a user-safe message. DB/SQL/stack-trace
/// errors must never be shown verbatim (they leak SQL and internals).
String friendlyError(String raw) {
  if (_technicalError.hasMatch(raw)) {
    return "Sorry — I couldn't complete that request. Please try rephrasing your question.";
  }
  if (raw.trim().isEmpty || raw.length > 200) {
    return 'Something went wrong. Please try again.';
  }
  return raw;
}
