/// Utility functions untuk string matching.
library;

/// Fuzzy match [query] terhadap list [candidates].
///
/// Urutan prioritas:
/// 1. Exact match (case-insensitive)
/// 2. Candidate mengandung query
/// 3. Candidate mengandung query setelah strip prefix (Kab., Kabupaten, Kota)
/// 4. Semua token query ada di candidate
///
/// Return candidate pertama yang cocok, atau null jika tidak ada.
String? fuzzyMatch(String query, List<String> candidates) {
  final q = query.toUpperCase().trim();

  final exact = candidates.where((c) => c.toUpperCase() == q);
  if (exact.isNotEmpty) return exact.first;

  final containsQ = candidates.where((c) => c.toUpperCase().contains(q));
  if (containsQ.isNotEmpty) return containsQ.first;

  final stripped = candidates.where((c) {
    final upper = c.toUpperCase();
    final clean = upper
        .replaceFirst(RegExp(r'^KAB\.\s*'), '')
        .replaceFirst(RegExp(r'^KABUPATEN\s+'), '')
        .replaceFirst(RegExp(r'^KOTA\s+'), '')
        .trim();
    return clean == q || clean.contains(q) || q.contains(clean);
  });
  if (stripped.isNotEmpty) return stripped.first;

  final qTokens = q.split(RegExp(r'\s+'));
  bool allTokensIn(String c) {
    final upper = c.toUpperCase();
    return qTokens.every(upper.contains);
  }

  return candidates.where(allTokensIn).firstOrNull;
}
