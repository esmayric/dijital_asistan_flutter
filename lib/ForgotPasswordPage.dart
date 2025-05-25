// ForgotPasswordPage.dart
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key); // ✅ Doğru constructor

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState(); // ✅ createState eksikti
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şifremi Unuttum')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Şifre sıfırlamak için e-posta adresinizi girin:'),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Backend'e isteği gönder
              },
              child: Text('Sıfırlama Linki Gönder'),
            )
          ],
        ),
      ),
    );
  }
}