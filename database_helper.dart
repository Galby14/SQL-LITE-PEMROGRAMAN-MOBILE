import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class Database_helper{
  Database _database;

  Future setDb() async{
    if(_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "kampus.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            db.execute(
                "CREATE TABLE mahasiswa (id INTEGER PRIMARY KEY autoincrement, nama TEXT, hobi TEXT)");
          }
      );
    }
  }
  Future<int> insertmahasiswa (Mahasiswa mahasiswa) async{
    await setDb();
    return _database.insert('mahasiswa', mahasiswa.toMap());
  }

  Future<List<Mahasiswa>> getMahasiswaList() async{
    await setDb();
    final List<Map<String, dynamic>> maps = await _database.query('mahasiswa');
    return List.generate(maps.length, (i){
      return Mahasiswa(
          id: maps[i]['id'],
          nama: maps[i]['nama'],
          hobi: maps[i]['hobi']
      );
    });
  }

  Future<int> updateMahasiswa(Mahasiswa mahasiswa) async{
    await setDb();
    return await _database.update(
        'mahasiswa',
        mahasiswa.toMap(),
        where: "id = ?",
        whereArgs: [mahasiswa.id]);
  }

  Future<void> deleteMahasiswa(int id) async{
    await setDb();
    _database.delete('mahasiswa',where: "id = ?", whereArgs: [id]);

  }
}



class Mahasiswa {
  int id;
  String nama;
  String hobi;

  Mahasiswa({
    @required this.nama,
    @required this.hobi,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {'nama': nama, 'hobi': hobi};
  }
}