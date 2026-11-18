import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../services/artists_service.dart';
import '../models/album.dart';
import '../models/track.dart';
import '../services/album_service.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistName;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
  });

  @override
  State<ArtistDetailScreen> createState() {
    return ArtistDetailScreenState();
  }
}

class ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final ArtistService artistService = ArtistService();
  final AlbumService albumService = AlbumService();

  Artist? artist;
  String? artistDescription;

  List<Album> albums = [];
  List<Track> tracks = [];

  bool isDetailsLoading = true;
  String? detailsErrorMessage;
  bool isAlbumsLoading = true;
  bool isTracksLoading = true;


  @override
  void initState() {
    super.initState();
    loadArtistDetails();
  }

  // Search for the exact artist and load the image
  Future<void> loadArtistDetails() async {
    try {
        // Search for the exact artist
        final results = await artistService.searchArtists(
          widget.artistName,
        );

        final matchingArtists = results.where(
          (item) =>
              item.name.toLowerCase() ==
              widget.artistName.toLowerCase(),
        );

        if (matchingArtists.isEmpty) {
          throw Exception('Artist not found');
        }

        // Load artist image
        final selectedArtist = await artistService.loadArtistImage(
          matchingArtists.first,
        );

        if (selectedArtist.imageUrl == null) {
          throw Exception('Artist image not found');
        }

        if (!mounted) return;

        // Show the artist information immediately
        setState(() {
          artist = selectedArtist;
          isDetailsLoading = false;
          detailsErrorMessage = null;
        });

        // Load artist description
        try {
          final description = await artistService.getArtistDescription(
            selectedArtist.id,
          );

          if (!mounted) return;

          setState(() {
            artistDescription = description;
          });
        } catch (error) {
          debugPrint('Artist description unavailable: $error');
        }

        // Load artist albums and covers
        try {
          final artistAlbums =
              await albumService.getArtistAlbumsWithCovers(
            selectedArtist.id,
          );

          if (!mounted) return;

          setState(() {
            albums = artistAlbums;
            isAlbumsLoading = false;
          });
        } catch (error) {
          debugPrint('Artist albums unavailable: $error');
          if (!mounted) return;
          setState(() {
            isAlbumsLoading = false;
          });
        }

        // Load the first five tracks
        try {
          final artistTracks = await artistService.getArtistTracks(
            selectedArtist.id,
          );

          if (!mounted) return;

          setState(() {
            tracks = artistTracks;
            isTracksLoading = false;
          });
        } catch (error) {
          debugPrint('Artist tracks unavailable: $error');
          if (!mounted) return;

          setState(() {
            isTracksLoading = false;
          });
        }
      } catch (error, stackTrace) {
        debugPrint('Artist details error: $error');
        debugPrint('Stack trace: $stackTrace');

        if (!mounted) return;

        setState(() {
          isDetailsLoading = false;
          detailsErrorMessage = 'Errore durante il caricamento dell\'artista';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: c.surfaceContainerLowest,

      appBar: AppBar(
        backgroundColor: c.surfaceContainerLowest,
        title: Text(
          widget.artistName,
          style: TextStyle(
            color: c.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isDetailsLoading
          ? Center(
              child: CircularProgressIndicator(
                color: c.primary,
              ),
            )
          : detailsErrorMessage != null
              ? Center(
                  child: Text(
                    detailsErrorMessage!,
                    style: TextStyle(color: c.error),
                  ),
                )
              : artist == null
                  ? Center(
                      child: Text(
                        'Artista non trovato',
                        style: TextStyle(color: c.onSurface),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (artist!.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                artist!.imageUrl!,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Icon(
                              Icons.person,
                              size: 100,
                              color: c.onSurfaceVariant,
                            ),

                          const SizedBox(height: 16),

                          Text(
                            artist!.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: c.onSurface,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            artistDescription ??
                                'Descrizione non disponibile',
                            style: TextStyle(
                              fontSize: 14,
                              color: c.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Album',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: c.onSurface,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (isAlbumsLoading)
                            const SizedBox(
                              height: 220,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (albums.isEmpty)
                            const Text('Nessun album disponibile')
                          else
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: albums.length,
                                itemBuilder: (context, index) {
                                  final album = albums[index];

                                  return Container(
                                    width: 145,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: album.coverUrl != null
                                              ? Image.network(
                                                  album.coverUrl!,
                                                  width: 145,
                                                  height: 145,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 145,
                                                  height: 145,
                                                  color: c.surfaceContainerHighest,
                                                  child: Icon(
                                                    Icons.album,
                                                    size: 50,
                                                    color: c.onSurfaceVariant,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          album.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: c.onSurface,
                                          ),
                                        ),
                                        if (album.firstReleaseDate != null)
                                          Text(
                                            album.firstReleaseDate!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: c.onSurfaceVariant,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 28),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Brani',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: c.onSurface,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            if (isTracksLoading)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (tracks.isEmpty)
                              const Text('Nessun brano disponibile')
                            else
                              Column(
                                children: tracks.take(5).map((track) {
                                  final featuring = track.artists
                                      .where(
                                        (name) =>
                                            name.toLowerCase() != artist!.name.toLowerCase(),
                                      )
                                      .toList();

                                  String durationText = 'Durata non disponibile';

                                  if (track.duration != null) {
                                    final duration = Duration(
                                      milliseconds: track.duration!,
                                    );

                                    final minutes = duration.inMinutes;
                                    final seconds = duration.inSeconds % 60;

                                    durationText =
                                        '$minutes:${seconds.toString().padLeft(2, '0')}';
                                  }

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: c.primaryContainer,
                                      child: Icon(
                                        Icons.music_note,
                                        color: c.onPrimaryContainer,
                                      ),
                                    ),
                                    title: Text(
                                      track.title,
                                      style: TextStyle(
                                        color: c.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      featuring.isEmpty
                                          ? durationText
                                          : '$durationText · Feat. ${featuring.join(', ')}',
                                      style: TextStyle(
                                        color: c.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                        ],
                      ),
                    ),
    );
  }
}