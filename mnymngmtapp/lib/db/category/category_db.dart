import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mnymngmtapp/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb._internal();

  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategorylist = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategorylist = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _CategoryDB.put(value.id, value);
    RefreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _CategoryDB.values.toList();
  }

  Future<void> RefreshUI() async {
    final _allCategories = await getCategories();
    incomeCategorylist.value.clear();
    expenseCategorylist.value.clear();
    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategorylist.value.add(category);
        } else {
          expenseCategorylist.value.add(category);
        }
      },
    );

    incomeCategorylist.notifyListeners();
    expenseCategorylist.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.delete(categoryID);
    RefreshUI();
  }
}
