
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String searchQuery = '';

  // List of artists
  final List<Map<String, String>> artists = [
    {'name': 'Måneskin', 'genre': 'Rock · Alternative'},
    {'name': 'Laura Pausini', 'genre': 'Pop'},
    {'name': 'Ultimo', 'genre': 'Pop · Cantautorato'},
    {'name': 'Mahmood', 'genre': 'Pop · R&B'},
    {'name': 'Elisa', 'genre': 'Pop · Rock'},
    {'name': 'Tiziano Ferro', 'genre': 'Pop'},
  ];

  // List of favorite artists
  final Set<String> favoriteArtists = {};

  // Toggle an artist as favorite
  void toggleFavorite(String artistName) {
    setState(() {
      if (favoriteArtists.contains(artistName)) {
        favoriteArtists.remove(artistName);
      } else {
        favoriteArtists.add(artistName);
      }
    });
  }


  // Build a temporary screen for sections not implemented yet
  Widget buildPlaceholderScreen(String title) {
    final c = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        '$title - In arrivo',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: c.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    // Filter artists based on the search query
    final filteredArtists = artists.where((artist) {
      return artist['name']!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    // Colors for artist initials
    final List<Color> avatarColors = [
      c.primaryContainer,
      c.secondaryContainer,
      c.tertiaryContainer,
      c.errorContainer,
      c.surfaceContainerHighest,
      c.primaryContainer,
    ];

    return Scaffold(
      backgroundColor: c.surfaceContainerLowest,

      appBar: AppBar(
        backgroundColor: c.surfaceContainerLowest,
        elevation: 0,
        toolbarHeight: 65,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ITALIA MUSIC',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: c.primary,
              ),
            ),
            Text(
              'La tua enciclopedia musicale',
              style: TextStyle(
                fontSize: 13,
                color: c.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      ),

      body: IndexedStack(
      index: selectedIndex,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Text(
                'Scopri gli artisti',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: c.onSurface,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Esplora la scena musicale italiana',
                style: TextStyle(
                  fontSize: 13,
                  color: c.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 15),

              // Search bar
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },

                decoration: InputDecoration(
                  hintText: 'Cerca un artista...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: c.onSurfaceVariant,
                  ),

                  prefixIcon: Icon(
                    Icons.search,
                    color: c.primary,
                    size: 18,
                  ),

                  filled: true,
                  fillColor: c.surface,

                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: c.outlineVariant,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: c.outlineVariant,
                    ),
                  ),

                ),
              ),

              const SizedBox(height: 14),

              // Artists section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Artisti',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: c.onSurface,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: c.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${filteredArtists.length} artisti',
                      style: TextStyle(
                        fontSize: 13,
                        color: c.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Artists list
              Expanded(
                child: filteredArtists.isEmpty? 
                Center(
                  child: Text(
                    'Nessun artista trovato',
                     style: TextStyle(
                       fontSize: 15,
                       color: c.onSurfaceVariant,
                     ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredArtists.length,
                        itemBuilder: (context, index) {
                          final artist = filteredArtists[index];
                          final artistName = artist['name']!;
                          final isFavorite =
                              favoriteArtists.contains(artistName);

                          return Card(
                            color: c.surface,
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: avatarColors[index % avatarColors.length],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    artistName[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: c.primary,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                artistName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: c.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                artist['genre']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: c.onSurfaceVariant,
                                ),
                              ),
                              trailing: IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  toggleFavorite(artistName);
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? c.primary
                                      : c.onSurfaceVariant,
                                  size: 19,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                ],
              ),
            ),

        buildPlaceholderScreen('Preferiti'),
        buildPlaceholderScreen('Profilo'),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            label: 'Artisti',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Preferiti',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profilo',
          ),
        ],
      ),
    );
  }
}
