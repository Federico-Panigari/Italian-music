
class Artist {
  final String id;
  final String name;
  final String? type;
  final String? country;
  final String? beginArea;
  final List<String> tags;
  final String? imageUrl;

  Artist({
    required this.id,
    required this.name,
    this.type,
    this.country,
    this.beginArea,
    this.tags = const [],
    this.imageUrl,
  });

  // Create a copy of the artist with updated data
  Artist copyWith({
    String? imageUrl,
  }) {
    return Artist(
      id: id,
      name: name,
      type: type,
      country: country,
      beginArea: beginArea,
      tags: tags,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  // Convert JSON data into an Artist object
  factory Artist.fromJson(Map<String, dynamic> json) {
    final tagsJson = json['tags'] as List<dynamic>? ?? [];

    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      country: json['country'] as String?,
      beginArea: json['begin-area'] == null? null : json['begin-area']['name'] as String?,
      tags: tagsJson.map((tag) => tag['name'] as String).toList(),
      imageUrl: json['imageUrl'] as String?,
    );

    
  }
}
