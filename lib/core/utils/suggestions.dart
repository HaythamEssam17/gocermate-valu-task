List<String> buildSearchSuggestions(
  Iterable<String> titles,
  String query, {
  int limit = 6,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];
  final words = <String>{};
  final phrases = <String>{};
  for (final raw in titles) {
    final title = raw.toLowerCase().replaceAll(RegExp(r'\(.*?\)'), '').trim();
    if (title.startsWith(q)) phrases.add(title);
    for (final w in title.split(RegExp(r'\s+'))) {
      if (w.length > 1 && w.startsWith(q)) words.add(w);
    }
  }
  final sortedWords = words.toList()..sort();
  final sortedPhrases = phrases.toList()..sort();
  return {...sortedWords, ...sortedPhrases}.take(limit).toList();
}
