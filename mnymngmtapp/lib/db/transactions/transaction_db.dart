import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mnymngmtapp/models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getallTransactions();
  Future<void> deleteTransactions(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactioNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refesh() async {
    final _list = await getallTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactioNotifier.value.clear();
    transactioNotifier.value.addAll(_list);
    transactioNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getallTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    return _db.values.toList();
  }

  @override
  Future<void> deleteTransactions(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refesh();
  }
}
