import 'package:flutter/material.dart';
import '../models/artist.dart';
import 'artist_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Artist> artists;
  final ValueChanged<String> onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.artists,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    if (artists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: c.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Non hai ancora artisti preferiti',
              style: TextStyle(
                fontSize: 16,
                color: c.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];

        final artistGenre = artist.tags.isNotEmpty
            ? artist.tags.take(2).join(' · ')
            : artist.type ?? 'Artista italiano';

        return Card(
          color: c.surface,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: c.primaryContainer,
              child: Icon(
                Icons.music_note,
                color: c.onPrimaryContainer,
              ),
            ),
            title: Text(
              artist.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: c.onSurface,
              ),
            ),
            subtitle: Text(
              artistGenre,
              style: TextStyle(
                color: c.onSurfaceVariant,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistDetailScreen(
                    artistName: artist.name,
                  ),
                ),
              );
            },
            trailing: IconButton(
              onPressed: () {
                onToggleFavorite(artist.id);
              },
              icon: Icon(
                Icons.favorite,
                color: c.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
