import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class TrackService {
  // Get recordings for an artist
  Future<List<Track>> getArtistTracks(String artistId) async {
    final uri = Uri.https(
      'musicbrainz.org',
      '/ws/2/recording/',
      {
        'query': 'arid:$artistId',
        'fmt': 'json',
        'limit': '10',
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'ITALIA-MUSIC/1.0 (ITS Flutter project)',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data =jsonDecode(response.body) as Map<String, dynamic>;

        final recordings =data['recordings'] as List<dynamic>? ?? [];

        final tracks = recordings.map((recording) {
          return Track.fromJson(
            recording as Map<String, dynamic>,
          );
        }).toList();

        return tracks.take(5).toList();
      } else {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Track search failed: $error');
    }
  }
}
