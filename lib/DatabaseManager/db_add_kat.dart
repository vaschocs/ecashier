import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager{
  final CollectionReference kategoriList =
  Firestore.instance.collection('kategoriInfo');

  Future<void> createKategoriData(
      String namaKategori, String uid) async{
    return await kategoriList.document(uid).setData({
      'Nama Kategori' : namaKategori,

    });
  }

  Future getKategoriList() async{
    List itemLists = [];

    try{
      await kategoriList.getDocuments().then((querySnapshot){
        querySnapshot.documents.forEach((element) {
          itemLists.add(element.data);
        });
      });
    } catch (e){
      print(e.toString());
      return null;
    }
  }
}
