
import './lib/services/artists_service.dart';

void main() async {
  final artistService = ArtistService();

  try {
    final artists =
        await artistService.searchArtistsWithImages('Lucio Dalla');

    for (var artist in artists) {
      print('Artist: ${artist.name}');
      print('Country: ${artist.country}');
      print('Genres: ${artist.tags}');
      print('Image URL: ${artist.imageUrl}');
      print('----------------------');
    }
  } catch (error) {
    print(error);
  }
}
