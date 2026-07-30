class FaviconService {
  static const int _size = 256;

  /// Returns the Google favicon API URL for a given website URL,
  /// or null if [websiteUrl] is null or empty.
  static String? getFaviconUrl(String? websiteUrl) {
    if (websiteUrl == null || websiteUrl.trim().isEmpty) return null;
    try {
      final uri = Uri.parse(websiteUrl.trim());
      final host = uri.host.isNotEmpty ? uri.host : websiteUrl.trim();
      if (host.isEmpty) return null;
      return 'https://www.google.com/s2/favicons?domain=$host&sz=$_size';
    } catch (_) {
      return null;
    }
  }
}
