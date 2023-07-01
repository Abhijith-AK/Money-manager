import 'package:flutter/material.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/db/transactions/transaction_db.dart';
import 'package:mnymngmtapp/models/category/category_model.dart';
import 'package:mnymngmtapp/screens/transaction/Transaction_screen.dart';

import '../../models/transactions/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = 'add-transactions';
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    CategoryDb().RefreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Purpose

              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),

              //Amount

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
              ),

              //Date

              TextButton.icon(
                onPressed: () async {
                  final _selectDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );

                  if (_selectDate == null) {
                    return;
                  } else {
                    print(_selectDate.toString());
                    setState(() {
                      _selectedDate = _selectDate;
                    });
                  }
                },
                icon: Icon(Icons.date_range_outlined),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate.toString()),
              ),

              //Category

              Row(
                children: [
                  Row(
                    children: [
                      Text('Income/Expense:'),
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _categoryId = null;
                          });
                        },
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            _categoryId = null;
                          });
                        },
                      ),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),

              //Category Type

              DropdownButton(
                hint: const Text('Select Category'),
                value: _categoryId,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDb().incomeCategorylist
                        : CategoryDb().expenseCategorylist)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categoryId = selectedValue;
                  });
                },
                onTap: () {},
              ),

              //Submit

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      addTrandaction();
                    },
                    icon: Icon(Icons.check),
                    label: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTrandaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryId == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refesh();
  }
}
