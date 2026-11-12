import 'lib/services/track_service.dart';

void main() async {
  final trackService = TrackService();

  try {
    final tracks = await trackService.getArtistTracks(
      '3862342a-43c4-4cdb-8250-bfdbfb5e1419',
    );

    print('Tracks found: ${tracks.length}');

    for (var track in tracks) {
      print('Title: ${track.title}');
      print('Duration: ${track.duration}');
      print('Artists: ${track.artists}');
      print('--------------------');
    }
  } catch (error) {
    print('Error: $error');
  }
}
