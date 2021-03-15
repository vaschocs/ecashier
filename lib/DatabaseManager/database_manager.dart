import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager{
  final CollectionReference barangList =
  Firestore.instance.collection('barangInfo');

  Future<void> createBarangData(
      String namaBarang, String merkBarang, String katBarang,
      int hjBarang, int hbBarang, int jmlStok, int minStok, String uid) async{
    return await barangList.document(uid).setData({
      'Nama Barang' : namaBarang,
      'Merk Barang' : merkBarang,
      'Kategori Barang' : katBarang,
      'Harga Jual' : hjBarang,
      'Harga Beli' : hbBarang,
      'Jumlah Stok' : jmlStok,
      'Minimum Stok' : minStok
    });
  }

  Future getBarangList() async{
    List itemLists = [];

    try{
      await barangList.getDocuments().then((querySnapshot){
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
