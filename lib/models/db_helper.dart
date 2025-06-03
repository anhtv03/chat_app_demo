import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/models/message.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _db;

  DBHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('chat_app.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filePath';
      print('Attempting to open database at path: $path');

      // Kiểm tra và tạo thư mục nếu không tồn tại
      final dir = Directory(directory.path);
      if (!await dir.exists()) {
        print('Directory does not exist, creating it');
        await dir.create(recursive: true);
      }

      // Kiểm tra quyền ghi bằng cách thử tạo một tệp tạm
      try {
        final testFile = File('${directory.path}/test_write.tmp');
        await testFile.writeAsString('test', flush: true);
        await testFile.delete();
        print('Directory is writable');
      } catch (e) {
        print('Directory is not writable: $e');
        throw Exception('No write permission for directory: $e');
      }

      // Mở cơ sở dữ liệu với quyền ghi
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        readOnly: false, // Đảm bảo không mở ở chế độ chỉ đọc
      );
      print('Database opened successfully');

      // Kiểm tra xem cơ sở dữ liệu có thể ghi được không
      try {
        await database.execute('CREATE TABLE IF NOT EXISTS TestWrite (id INTEGER PRIMARY KEY)');
        await database.delete('TestWrite'); // Thử một thao tác ghi
        print('Database is writable');
      } catch (e) {
        print('Database write test failed: $e');
        throw Exception('Database is read-only or inaccessible: $e');
      }

      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Friends (
      id TEXT PRIMARY KEY,
      fullName TEXT,
      username TEXT,
      avatar TEXT,
      isOnline INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE Messages (
      id TEXT PRIMARY KEY,
      content TEXT,
      files TEXT,
      images TEXT,
      isSend INTEGER,
      createdAt TEXT,
      messageType INTEGER,
      friendId TEXT
    )
    ''');
  }

  Future<List<Friend>> getFriends() async {
    final db = await database;
    final result = await db.query('Friends');
    print("db_helper: bay vao get friend");
    return result.map((json) {
      json['isOnline'] = json['isOnline'] == 1 ? true : false;
      return Friend.fromJson(json);
    }).toList();
  }

  Future<void> setFriends(List<Friend> friends) async {
    final db = await database;
    try {
      print('Starting transaction to set friends');
      await db.transaction((txn) async {
        print('Deleting existing friends');
        await txn.delete('Friends');
        print('Inserting ${friends.length} friends');
        for (var item in friends) {
          await txn.insert('Friends', {
            'id': item.friendID,
            'fullName': item.fullName,
            'username': item.username,
            'avatar': item.avatar ?? '',
            'isOnline': item.isOnline ? 1 : 0,
          });
        }
      });
      print('Successfully saved friends to database');
    } catch (e) {
      print('Error saving friends to database: $e');
      rethrow;
    }
  }

  Future<List<Message>> getMessages(String friendId) async {
    final db = await database;
    final result = await db.query(
      'Messages',
      where: 'friendId=?',
      whereArgs: [friendId],
    );
    return result.map((json) => Message.fromJson(json)).toList();
  }

  Future<void> setMessages(List<Message> messages, String friendId) async {
    final db = await database;
    await db.delete('Messages', where: 'friendId = ?', whereArgs: [friendId]);

    final limit = messages.take(50).toList();
    for (var item in limit) {
      await db.insert('Messages', {
        'id': item.id,
        'content': item.content ?? '',
        'files': jsonEncode(item.files),
        'images': jsonEncode(item.images),
        'isSend': item.isSend,
        'createdAt': item.createdAt.toIso8601String(),
        'messageType': item.messageType,
        'friendId': friendId,
      });
    }
  }
}
