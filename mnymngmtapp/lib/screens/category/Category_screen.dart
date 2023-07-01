import 'package:flutter/material.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/screens/category/expense_list.dart';
import 'package:mnymngmtapp/screens/category/icome_list.dart';

class categoryScreen extends StatefulWidget {
  const categoryScreen({super.key});

  @override
  State<categoryScreen> createState() => _categoryScreenState();
}

class _categoryScreenState extends State<categoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabcontroller;

  @override
  void initState() {
    _tabcontroller = TabController(length: 2, vsync: this);
    CategoryDb().RefreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabcontroller,
            labelStyle: TextStyle(fontSize: 15),
            tabs: [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              ),
            ]),
        Expanded(
          child: TabBarView(
            controller: _tabcontroller,
            children: [
              ExpenseCategory(),
              IncomeCategory(),
            ],
          ),
        )
      ],
    );
  }
}
