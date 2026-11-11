
import './lib/models/artist.dart';
import './lib/services/artists_service.dart';

void main() async {
  final artistService = ArtistService();

  try {
    final artists =
        await artistService.searchArtists('Måneskin');

    if (artists.isNotEmpty) {
      final artist = artists.first;

      final artistWithImage =
          await artistService.loadArtistImage(artist);

      print('Artist: ${artistWithImage.name}');
      print('Image URL: ${artistWithImage.imageUrl}');
    }
  } catch (error) {
    print(error);
  }
}
