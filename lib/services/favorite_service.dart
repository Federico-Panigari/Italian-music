import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {

  // Load favorites for a specific account
  Future<List<String>> loadFavorites(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList('favorites_$email');

    return favorites ?? [];
  }

  // Save favorites for a specific account
  Future<void> saveFavorites(
    String email,
    List<String> favorites,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('favorites_$email', favorites);
  }
}