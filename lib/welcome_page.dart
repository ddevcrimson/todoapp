import 'package:flutter/cupertino.dart';
import 'package:todoapp/main_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  build(context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Todo App',
                style: TextStyle(fontSize: 28),
              ),
            ),
            CupertinoButton.filled(
              child: const Text('Start!'),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const MainPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
