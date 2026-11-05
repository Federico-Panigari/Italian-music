import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

      body: Stack(
        children:[
          Positioned(
                top: -60,
                left: -60,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                bottom: -60,
                right: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),          

          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.music_note,
                    size: 90,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'ITALIA MUSIC',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'La musica italiana, tutta da scoprire',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 50),

                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
        ] 
      ,)

      
      
      
      
      
    );
  }
}