import 'package:flutter/material.dart';
import 'package:mnymngmtapp/screens/home/Home_screen.dart';

class mnymngrbtmnavgtn extends StatelessWidget {
  const mnymngrbtmnavgtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: homeScreen.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget) {
        return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            currentIndex: updatedIndex,
            onTap: (newIndex) {
              homeScreen.selectedIndexNotifier.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
            ]);
      },
    );
  }
}
