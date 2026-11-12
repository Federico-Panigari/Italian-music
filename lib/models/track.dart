class Track {
  final String id;
  final String title;
  final int? duration;
  final List<String> artists;

  Track({
    required this.id,
    required this.title,
    this.duration,
    this.artists = const [],
  });

  // Convert JSON data into a Track object
  factory Track.fromJson(Map<String, dynamic> json) {
    final artistCredits =json['artist-credit'] as List<dynamic>? ?? [];

    final artistNames = artistCredits.map((credit) {
      if (credit is Map<String, dynamic>) {
        return credit['name'] as String? ?? '';
      }

      return '';
    }).where((name) => name.isNotEmpty).toList();

    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['length'] as int?,
      artists: artistNames,
    );
  }
}
