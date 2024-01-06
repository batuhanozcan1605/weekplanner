import 'package:sqflite/sqflite.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import 'package:weekplanner/database/DatabaseHelper2.dart';
import 'package:weekplanner/model/UniqueId.dart';

class UniqueIdDao {

  Future<void> insertData(String uniqueId) async {
    final db = await DatabaseHelper2.database();
    print('debugg $uniqueId');
    await db.insert(
      'uniqueId',
      {'uniqueId': uniqueId},
    );
    print('debugg $uniqueId');
  }

  Future<void> deleteAppointment(String uniqueId) async {
    final database = await DatabaseHelper2.database();
    await database.delete(
      'uniqueId.db',
      where: 'uniqueId = ?',
      whereArgs: [uniqueId],
    );
  }

  Future<List<String>> getAllUniqueIds() async {
    final database = await DatabaseHelper2.database();
    final List<Map<String, dynamic>> maps = await database.query('uniqueId');
    return List.generate(maps.length, (i) {
      return maps[i]['uniqueId'] as String;
    });
  }


}