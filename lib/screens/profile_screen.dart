import 'package:flutter/material.dart';
import "../services/account_service.dart";


class ProfileScreen extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeChanged;
  final String currentEmail;
  final AccountService accountService;

  const ProfileScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentEmail,
    required this.accountService,
  });

  @override
  State<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  // Log out from the current account
  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // Delete the current account
  Future<void> deleteCurrentAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elimina account'),
          content: Text(
            'Vuoi eliminare definitivamente '
            'l\'account ${widget.currentEmail}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final deleted = widget.accountService.deleteAccount(
      widget.currentEmail,
    );

    if (!deleted) return;

    logout();
  }


  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
          
            Text(
              'Profilo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: c.onSurface,
              ),
            ),

        const SizedBox(height: 20),
        // Current account
        Card(
          color: c.surface,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: c.primaryContainer,
              child: Icon(
                Icons.person,
                color: c.onPrimaryContainer,
              ),
            ),
            title: const Text('Account corrente'),
            subtitle: Text(widget.currentEmail),
          ),
        ),

        const SizedBox(height: 20),

        // Settings section
        Text(
          'Impostazioni',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: c.onSurface,
          ),
        ),

        const SizedBox(height: 12),

        Card(
          elevation: 0,
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: c.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aspetto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Scegli il tema dell'app",
                  style: TextStyle(
                    fontSize: 14,
                    color: c.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          widget.onThemeChanged(ThemeMode.light);
                        },
                        child: const Text('☀ Chiaro'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          widget.onThemeChanged(ThemeMode.dark);
                        },
                        child: const Text('☾ Scuro'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

       
        const SizedBox(height: 20),

        // Log out button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('Esci dall’account'),
          ),
        ),

        const SizedBox(height: 12),

        // Delete account button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: deleteCurrentAccount,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Elimina account'),
            style: FilledButton.styleFrom(
              backgroundColor: c.error,
              foregroundColor: c.onError,
            ),
          ),
        ),

      ],
    );
  }
}