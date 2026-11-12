import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../services/artists_service.dart';

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

  late Future<Artist?> artistFuture;

  @override
  void initState() {
    super.initState();
    artistFuture = loadArtist();
  }

  // Search for the exact artist and load the image
  Future<Artist?> loadArtist() async {
    final artists = await artistService.searchArtists(widget.artistName);

    final matchingArtists = artists.where(
      (artist) => artist.name.toLowerCase() ==widget.artistName.toLowerCase(),
    );

    if (matchingArtists.isEmpty) {
      return null;
    }

    final artist = matchingArtists.first;

    return await artistService.loadArtistImage(artist);
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
      
      body: FutureBuilder<Artist?>(
        future: artistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: c.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Errore durante il caricamento dell\'artista',
                style: TextStyle(color: c.error),
              ),
            );
          }

          final artist = snapshot.data;

          if (artist == null) {
            return Center(
              child: Text(
                'Artista non trovato',
                style: TextStyle(color: c.onSurface),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (artist.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      artist.imageUrl!,
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
                  artist.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: c.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}