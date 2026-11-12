import 'lib/services/album_service.dart';

void main() async {
  final albumService = AlbumService();

  try {
    final albums = await albumService.getArtistAlbums(
      '3862342a-43c4-4cdb-8250-bfdbfb5e1419',
    );

    print('Albums found: ${albums.length}');

    for (var album in albums) {
      print('Title: ${album.title}');
      print('Release date: ${album.firstReleaseDate}');
      print('Type: ${album.type}');
      print('--------------------');
    }
  } catch (error) {
    print('Error: $error');
  }
}
