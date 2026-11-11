import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artist.dart';

class ArtistService {

  
  // Search Italian artists on MusicBrainz
  Future<List<Artist>> searchArtists(String artistName) async {
  final uri = Uri.https(
    'musicbrainz.org',
    '/ws/2/artist/',
    {
      'query': 'artist:"$artistName" AND country:IT',
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
      final data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final artistsJson = data['artists'] as List<dynamic>? ?? [];

      return artistsJson.map((artist) {
        return Artist.fromJson(artist as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Artist search failed: $error');
  }
}

// Get the Wikidata ID of an artist
Future<String?> getWikidataId(String artistId) async {
  final uri = Uri.https(
    'musicbrainz.org',
    '/ws/2/artist/$artistId',
    {
      'inc': 'url-rels',
      'fmt': 'json',
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
      final data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final relations = data['relations'] as List<dynamic>? ?? [];

      for (var relation in relations) {
        if (relation['type'] == 'wikidata') {
          final resource = relation['url']['resource'] as String;

          final wikidataUri = Uri.parse(resource);

          return wikidataUri.pathSegments.last;
        }
      }

      return null;
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Wikidata ID search failed: $error');
  }
}



  // Get the artist image from Wikidata and Wikimedia Commons
  Future<String?> getArtistImage(String wikidataId) async {
    final wikidataUri = Uri.https(
      'www.wikidata.org',
      '/w/api.php',
      {
        'action': 'wbgetentities',
        'ids': wikidataId,
        'props': 'claims',
        'format': 'json',
      },
    );

    try {
      // Get the artist data from Wikidata
      final wikidataResponse = await http.get(
        wikidataUri,
        headers: {
          'User-Agent': 'ITALIA-MUSIC/1.0 (ITS Flutter project)',
        },
      ).timeout(const Duration(seconds: 10));

      if (wikidataResponse.statusCode != 200) {
        throw Exception(
          'Wikidata error: ${wikidataResponse.statusCode}',
        );
      }

      final wikidataData =
          jsonDecode(wikidataResponse.body) as Map<String, dynamic>;

      final entities =
          wikidataData['entities'] as Map<String, dynamic>;

      final entity =
          entities[wikidataId] as Map<String, dynamic>;

      final claims = entity['claims'] as Map<String, dynamic>;

      // Get the P18 image filename
      final imageClaims =
          claims['P18'] as List<dynamic>? ?? [];

      if (imageClaims.isEmpty) {
        return null;
      }

      final firstClaim =imageClaims.first as Map<String, dynamic>;

      final mainSnak =firstClaim['mainsnak'] as Map<String, dynamic>?;

      final dataValue =mainSnak?['datavalue'] as Map<String, dynamic>?;

      final imageName = dataValue?['value'] as String?;

      if (imageName == null) {
        return null;
      }

      // Get the image URL from Wikimedia Commons
      final commonsUri = Uri.https(
        'commons.wikimedia.org',
        '/w/api.php',
        {
          'action': 'query',
          'titles': 'File:$imageName',
          'prop': 'imageinfo',
          'iiprop': 'url',
          'iiurlwidth': '500',
          'format': 'json',
        },
      );

      final commonsResponse = await http.get(
        commonsUri,
        headers: {
          'User-Agent': 'ITALIA-MUSIC/1.0 (ITS Flutter project)',
        },
      ).timeout(const Duration(seconds: 10));

      if (commonsResponse.statusCode == 200) {
        final commonsData =
            jsonDecode(commonsResponse.body) as Map<String, dynamic>;

        final query =
            commonsData['query'] as Map<String, dynamic>;

        final pages =
            query['pages'] as Map<String, dynamic>;

        final page =
            pages.values.first as Map<String, dynamic>;

        final imageInfoList =
            page['imageinfo'] as List<dynamic>? ?? [];

        if (imageInfoList.isEmpty) {
          return null;
        }

        final imageInfo =
            imageInfoList.first as Map<String, dynamic>;

        return imageInfo['thumburl'] as String? ??
            imageInfo['url'] as String?;
      } else {
        throw Exception(
          'Wikimedia Commons error: ${commonsResponse.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Artist image search failed: $error');
    }
  }


  // Add the artist image to an Artist object
  Future<Artist> loadArtistImage(Artist artist) async {
    try {
      // Get the Wikidata ID
      final wikidataId = await getWikidataId(artist.id);

      if (wikidataId == null) {
        return artist;
      }

      // Get the artist image
      final imageUrl = await getArtistImage(wikidataId);

      // Return the artist with the image
      return artist.copyWith(imageUrl: imageUrl);
    } catch (error) {
      print('Image loading failed for ${artist.name}: $error');
      return artist;
    }
  }


}
