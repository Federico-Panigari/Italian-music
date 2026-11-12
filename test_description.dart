import './lib/services/artists_service.dart';

void main() async {
  final artistService = ArtistService();

  try {
    final description =
        await artistService.getArtistDescription(
      '3862342a-43c4-4cdb-8250-bfdbfb5e1419',
    );

    print('Artist description:');
    print(description ?? 'Description not available');
  } catch (error) {
    print('Error: $error');
  }
}
