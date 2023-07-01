import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/db/transactions/transaction_db.dart';
import 'package:mnymngmtapp/models/category/category_model.dart';

import '../../models/transactions/transaction_model.dart';

class transactionScreen extends StatelessWidget {
  const transactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refesh();
    CategoryDb.instance.RefreshUI;

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactioNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: EdgeInsets.all(10),

          //values
          itemBuilder: (context, index) {
            final _value = newList[index];
            return Slidable(
              key: Key(_value.id!),
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransactions(_value.id!);
                      },
                      icon: Icons.delete)
                ],
              ),
              child: Card(
                child: ListTile(
                  leading: Text(parseDate(_value.date) + ' :'),
                  title: Text(
                    'Rs ${_value.amount}',
                    style: _value.type == CategoryType.income
                        ? TextStyle(color: Colors.green, fontSize: 20)
                        : TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  subtitle: Text(
                    _value.category.name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: ((context, index) {
            return const SizedBox(
              height: 5,
            );
          }),
          itemCount: newList.length,
        );
      },
    );
  }
}

String parseDate(DateTime date) {
  final _date = DateFormat.MMMd().format(date);
  final _splitDate = _date.split(' ');
  return "${_splitDate.last}\t${_splitDate.first}";
  // return '${date.day}\n${date.month}';
}
