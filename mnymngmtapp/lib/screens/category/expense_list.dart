import 'package:flutter/material.dart';
import 'package:mnymngmtapp/db/category/category_db.dart';
import 'package:mnymngmtapp/models/category/category_model.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().expenseCategorylist,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final category = newList[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    CategoryDb().deleteCategory(category.id);
                  },
                  icon: Icon(Icons.delete_outline_rounded),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 4,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
