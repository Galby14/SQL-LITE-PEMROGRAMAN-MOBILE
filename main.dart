import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'package:flutter_database/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'belajar SQLite',
      theme: ThemeData(

        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Database_helper _dbhelper = new Database_helper();
  final _namaController = TextEditingController();
  final _hobiController = TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  Mahasiswa mahasiswa;
  List<Mahasiswa>listmhs;
  int updateIndex;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.pinkAccent[100],
      appBar: AppBar(
        title: Text("SQL LITE Demo"),

      ),
      body: ListView(
        children: <Widget>[

          Form(key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Image.asset('assets/gambar_db.jpeg',width: 390,height: 180,),
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Nama Lengkap Mahasiswa',
                    ),
                    controller: _namaController,
                    validator: (val) => val.isNotEmpty? null: 'Anda harus mengisi nama mahasiswa',
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'hobi Mahasiswa',
                    ),
                    controller: _hobiController,
                    validator: (val) => val.isNotEmpty? null: 'Anda harus mengisi hobi mahasiswa',
                  ),
                  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue[400],
                      child: Container(
                        width: width*0.9,
                        child: Text('kirim',textAlign: TextAlign.center,),),
                      onPressed: (){
                        _submitMahasiswa(context);
                      }),
                  Padding(padding: EdgeInsets.all(20),),
                  Text('Data akan muncul di bawah'),
                  FutureBuilder(
                    future: _dbhelper.getMahasiswaList(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        listmhs = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listmhs == null?0 : listmhs.length,
                          itemBuilder: (BuildContext context, int index){
                            Mahasiswa mhs = listmhs[index];
                            return Card(
                              color: Colors.blue,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: width*0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Nama Mahasiswa: ${mhs.nama}',style: TextStyle(fontSize: 15),),
                                        Text('hobi Mahasiswa: ${mhs.hobi}',style: TextStyle(fontSize: 15,color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                  IconButton(icon: Icon(Icons.edit),color: Colors.greenAccent , onPressed: (){
                                    _namaController.text = mhs.nama;
                                    _hobiController.text = mhs.hobi;
                                    mahasiswa = mhs;
                                    updateIndex = index;


                                  }),
                                  IconButton(icon: Icon(Icons.delete),color: Colors.greenAccent , onPressed: (){
                                    _dbhelper.deleteMahasiswa(mhs.id);
                                    setState(() {
                                      listmhs.removeAt(index);
                                    });
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )

                ],),
              ))
        ],
      ),
    );
  }

  void _submitMahasiswa(BuildContext context) {
    if(_formkey.currentState.validate()){
      if(mahasiswa == null){
        Mahasiswa mhs = new Mahasiswa(nama: _namaController.text, hobi: _hobiController.text);
        _dbhelper.insertmahasiswa(mhs).then((id) =>{
          _namaController.clear(),
          _hobiController.clear(),
          print('Mahasiswa telah di tambah dengan id: ${id}')
        });
      }else{
        mahasiswa.nama = _namaController.text;
        mahasiswa.hobi = _hobiController.text;
        _dbhelper.updateMahasiswa(mahasiswa).then((id) =>{
          setState((){
            listmhs[updateIndex].nama = _namaController.text;
            listmhs[updateIndex].hobi = _hobiController.text;
          }),
          _namaController.clear(),
          _hobiController.clear(),
          mahasiswa = null
        });
      }
    }
  }
}