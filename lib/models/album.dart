class Album {
  final String id;
  final String title;
  final String? firstReleaseDate;
  final String? type;
  final String? coverUrl;

  Album({
    required this.id,
    required this.title,
    this.firstReleaseDate,
    this.type,
    this.coverUrl,
  });


  // Create a copy of the album with updated data
  Album copyWith({
    String? coverUrl,
  }) {
    return Album(
      id: id,
      title: title,
      firstReleaseDate: firstReleaseDate,
      type: type,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }

  // Convert JSON data into an Album object
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      firstReleaseDate: json['first-release-date'] as String?,
      type: json['primary-type'] as String?,
    );
  }
}
