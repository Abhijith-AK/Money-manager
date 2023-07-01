import 'package:flutter/material.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/screens/add_transaction/screen_add_transaction.dart';
import 'package:mnymngmtapp/screens/category/Category_screen.dart';
import 'package:mnymngmtapp/screens/category/category_add_popup.dart';
import 'package:mnymngmtapp/screens/home/widgets/bottom_navigation.dart';
import 'package:mnymngmtapp/screens/transaction/Transaction_screen.dart';

class homeScreen extends StatelessWidget {
  homeScreen({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [
    transactionScreen(),
    categoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Manager'),
        backgroundColor: Colors.purple[300],
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBar: mnymngrbtmnavgtn(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('add Transactions');
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
            print('add Caategory');
            showCategoryPopup(context);
            // CategoryDb().insertCategory();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
