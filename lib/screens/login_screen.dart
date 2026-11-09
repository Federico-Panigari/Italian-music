import 'package:flutter/material.dart';
import '../services/account_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {

  String? messaggioErrore;
  final AccountService accountService = AccountService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xFFF0E7FF),

        child: Stack(
          children: [

            // Cerchio decorativo superiore
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCCBFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Cerchio decorativo inferiore
            Positioned(
              bottom: -10,
              left: -80,
              child: Container(
                width: 270,
                height: 270,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6D9FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Contenuto principale
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 35),

                  Text(
                    'ITALIA MUSIC',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Entra nel mondo della musica italiana',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Card del Login
                 Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                    offset: const Offset(0, 110),

                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(                 
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Benvenuto!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Accedi al tuo spazio musicale',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Etichetta EMAIL
                          const Text(
                            'EMAIL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Campo Email
                          TextField(
                            controller: emailController,

                            decoration: InputDecoration(
                              hintText: 'nome@email.com',
                              hintStyle: const TextStyle(fontSize: 11),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 15,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAF8FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6DDF5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6DDF5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Etichetta PASSWORD
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Campo Password
                          TextField(
                            controller: _passwordController,
                            obscureText: true,

                            decoration: InputDecoration(
                              hintText: 'Inserisci la password',
                              hintStyle: const TextStyle(fontSize: 11),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                size: 15,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAF8FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6DDF5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6DDF5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Pulsante Accedi
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: FilledButton(
                              onPressed: () {
                                setState(() {
                                  if (emailController.text.isEmpty || _passwordController.text.isEmpty) {

                                    messaggioErrore = 'Inserisci email e password';

                                  } else if (!accountService.verificaAccesso(
                                      emailController.text,
                                      _passwordController.text)) {

                                    messaggioErrore = 'Email o password non corrette';

                                  } else {

                                    messaggioErrore = null;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Accesso effettuato!'),
                                      ),
                                    );
                                  }
                                });
                              },
                              
                              child: const Text(
                                'ACCEDI',
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),

                          // Messaggio di errore
                          if (messaggioErrore != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              messaggioErrore ?? '',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                     ),
                    ),
                   ),
                 ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
