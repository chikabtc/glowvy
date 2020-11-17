import 'dart:convert' as convert;

import 'package:localstorage/localstorage.dart';

class DimodoNotification {
  String body;
  String title;
  bool seen;
  String date;

  DimodoNotification.fromJsonFirebase(Map<String, dynamic> json) {
    try {
      var notification = json['data'] ?? json['notification'];
      body = notification['body'];
      title = notification['title'];
      seen = false;
      date = DateTime.now().toString();
      print(date);
    } catch (e) {
      print(e.toString());
    }
  }

  DimodoNotification.fromJsonFirebaseLocal(Map<String, dynamic> json) {
    try {
      var notification = json['data'] ?? json['notification'];
      body = notification['body'];
      title = notification['title'];
      seen = false;
      int time = notification['google.sent_time'] ?? ['from'];
      date = DateTime.fromMillisecondsSinceEpoch(time).toString();
      print(date);
    } catch (e) {
      print(e.toString());
    }
  }

  DimodoNotification.fromLocalStorage(Map<String, dynamic> json) {
    try {
      body = json['body'];
      title = json['title'];
      date = (DateTime.parse(json['date'])).toString();
      seen = false;
    } catch (e) {
      print(e.toString());
    }
  }

  DimodoNotification.from(String b, String t) {
    body = b;
    title = t;
    seen = false;
  }

  Map<String, dynamic> toJson() => {
        'body': body,
        'title': title,
        'seen': seen,
        'date': date,
      };

  void updateSeen(int index) async {
    final storage = LocalStorage('Dimodo');
    seen = true;
    try {
      final ready = await storage.ready;
      if (ready) {
        var list = storage.getItem('notifications');
        list ??= [];
        list[index] = convert.jsonEncode(toJson());
        await storage.setItem('notifications', list);
      }
    } catch (err) {
      print(err);
    }
  }

  void saveToLocal(String id) async {
    final storage = LocalStorage('Dimodo');

    try {
      final ready = await storage.ready;
      if (ready) {
        var list = storage.getItem('notifications');
        var old = storage.getItem('message-id').toString();
        if (old.isNotEmpty && id != 'null') {
          if (old == id) return;
          await storage.setItem('message-id', id);
        } else {
          await storage.setItem('message-id', id);
        }
        list ??= [];
        list.insert(0, convert.jsonEncode(toJson()));
        await storage.setItem('notifications', list);
      }
    } catch (err) {
      print(err);
    }
  }
}
