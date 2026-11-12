import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';

class AlbumService {
  // Get albums for an artist
  Future<List<Album>> getArtistAlbums(String artistId) async {
    final uri = Uri.https(
      'musicbrainz.org',
      '/ws/2/release-group/',
      {
        'query': 'arid:$artistId AND primarytype:album',
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

        final albumsJson = data['release-groups'] as List<dynamic>? ?? [];

        return albumsJson.map((album) {
          return Album.fromJson(
            album as Map<String, dynamic>,
          );
        }).toList();
      } else {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Album search failed: $error');
    }
  }


  // Get the album cover from Cover Art Archive
  Future<String?> getAlbumCoverUrl(String releaseGroupId) async {
    final uri = Uri.https(
      'coverartarchive.org',
      '/release-group/$releaseGroupId/front-500',
    );

    try {
      final response = await http.head(
        uri,
        headers: {
          'User-Agent': 'ITALIA-MUSIC/1.0 (ITS Flutter project)',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return uri.toString();
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception(
        'Cover Art Archive error: ${response.statusCode}',
      );
    } catch (error) {
      throw Exception('Album cover search failed: $error');
    }
  }




  // Load albums with their cover images
  Future<List<Album>> getArtistAlbumsWithCovers(
    String artistId,
  ) async {
    final albums = await getArtistAlbums(artistId);

    final List<Album> albumsWithCovers = [];

    for (var album in albums) {
      final coverUrl = await getAlbumCoverUrl(album.id);

      albumsWithCovers.add(
        album.copyWith(coverUrl: coverUrl),
      );

      await Future.delayed(const Duration(seconds: 1));
    }

    return albumsWithCovers;
  }


}
