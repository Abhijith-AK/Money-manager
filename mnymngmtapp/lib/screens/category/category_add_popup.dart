import 'package:flutter/material.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                  hintText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: "Expense", type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    final _name = _nameEditingController.text;
                    if (_name.isEmpty) {
                      return;
                    }
                    final _type = selectedCategoryNotifier.value;
                    final _category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type,
                    );

                    CategoryDb.instance.insertCategory(_category);
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Add')),
            )
          ],
        );
      });
}

class RadioButton extends StatefulWidget {
  final String title;
  final CategoryType type;
  const RadioButton({super.key, required this.title, required this.type});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  CategoryType? _type;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ValueListenableBuilder(
        valueListenable: selectedCategoryNotifier,
        builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
          return Radio<CategoryType>(
            value: widget.type,
            groupValue: newCategory,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              selectedCategoryNotifier.value = value;
              selectedCategoryNotifier.notifyListeners();
            },
          );
        },
      ),
      Text(widget.title),
    ]);
  }
}
