import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text(
          'About',
          style: TextStyle(
              color: colorScheme.onBackground, fontFamily: 'Montserrat'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Column(
          children: [
            Text('I am a solo developer. Please contact me to send suggestions about potential features and changes you may want to see and to notify bugs.\n\n'
                'contact: batuhanozcan1605@gmail.com',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
