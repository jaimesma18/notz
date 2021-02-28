import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notz/classes/Product.dart';
import 'package:notz/classes/User.dart';
import 'package:notz/services/auth.dart';
class DatabaseService{
String model;

  DatabaseService({this.model});
  final CollectionReference productos=FirebaseFirestore.instance.collection('products');


 Future log({String model,String type,String field,dynamic before,dynamic after}){
   CollectionReference log = FirebaseFirestore.instance.collection('log');

   Map <String,dynamic> m=new Map<String,dynamic>();


   m['user']=AuthService().userInfo().email;
   m['timestamp']=DateTime.now();
   m['model']=model;
   m['type']=type;
   m['field']=field;
   m['before']=before;
   m['after']=after;


   return log
       .doc()
       .set(m)
       .then((value) => print("Log added"))
       .catchError((error) => print("Failed to add log: $error"));

 }

Product productFromDoc(Map<String,dynamic> m){
  Product p;

  List photos=[];
  Map photosNames=new Map();

  List tempPhotos=m['fotos'];
  for(var x in tempPhotos){
    photos.add(x.keys.toList()[0]);
    photosNames[x.keys.toList()[0]]=x.values.toList()[0];
  }

  p= new Product(
      title: m['titulo'],
      model:m['modelo'],
      brand: m['marca'],
      upc: m['upc'],
      photos: photos,
      photosName: photosNames,
      //photos: m['fotos'],
      dimensions: m['medidas'],
      customs: m['aduana'],
      bullets: m['bullets'],
      technicals: m['tecnicas'],
    manufacturer: m['fabricante'],
    keywords: m['keywords'],

  );

  return p;
}

Future<Product> getProducto(String model)async{
  Product p=null;
  await FirebaseFirestore.instance
      .collection('products')
      .doc(model)
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      p=productFromDoc(doc.data());
      /*new Product(
        title: doc.data()['titulo'],
        model:doc.data()['modelo'],
        brand: doc.data()['marca'],
        upc: doc.data()['upc'],
        dimensions: doc.data()['medidas'],
        customs: doc.data()['aduana'],
        bullets: doc.data()['bullets'],
        technicals: doc.data()['tecnicas']

      );*/
    }
  });
  return p;
}

Future<List<Product>> queryProducts(String query)async{
  List<Product> ps=[];
  await  FirebaseFirestore.instance
      .collection('products')
      .where('keywords', arrayContains: query.toLowerCase())
      .get()
      .then((QuerySnapshot snapshot){
        for (var x in snapshot.docs){
          Product p=productFromDoc(x.data());
          ps.add(p);
        }

   });

  return ps;
}

Future<List<String>> getAreas()async{

 List download=[];
 List<String>areas=[];
  await
  FirebaseFirestore.instance
      .collection('lists')
      .doc('areas')
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      download=doc.data()['areas'];
     for(var x in download){
     //  print(x);
       areas.add(x.toString());
     }

    }
    else{
     areas=null;
    }
  });

  return areas;
}

Future<List<String>> getViewsPermissions()async{

  List download=[];
  List<String>areas=[];
  await
  FirebaseFirestore.instance
      .collection('lists')
      .doc('permissions')
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      download=doc.data()['views'];
      for(var x in download){
        //  print(x);
        areas.add(x.toString());
      }

    }
    else{
      areas=null;
    }
  });

  return areas;
}

Future<User> getUser(String email)async{
  User u=new User();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      u.name= doc.data()['name'];
      u.lastname=doc.data()['lastname'];
      u.area=doc.data()['area'];
      u.email=doc.data()['email'];
     // u.userManagement=doc.data()['userManagement'];
      u.uid=doc.data()['uid'];
      u.permissions=doc.data()['permissions'];
      u.superuser=doc.data()['superuser'];

    }
    else{
      u=null;
    }
  });
  return u;
}
Future<void> addArea(List array) {
  CollectionReference area = FirebaseFirestore.instance.collection('lists');
  Map <String,dynamic> m=new Map<String,dynamic>();


    m['areas']=array;


  return area
      .doc("areas")
      .update(m)
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<void> addUser(String email,{String name,String lastname,String area,Map permissions,String uid,int superuser}) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Map <String,dynamic> m=new Map<String,dynamic>();
  if(email!=null){
    m['email']=email;
  }
  if(name!=null){
    m['name']=name;
  }
  if(lastname!=null){
    m['lastname']=lastname;
  }
  if(area!=null){
    m['area']=area;
  }
  if(permissions!=null){
    m['permissions']=permissions;
  }
  if(uid!=null){
    m['uid']=uid;
  }
  if(superuser==null){
    superuser=0;
  }
  m['superuser']=superuser;

  print("su");
  print(superuser);
  return users
      .doc(email)
      .set(m)
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<void> updateUser(String email,{String name,String lastname,String area,Map permissions,String uid,int superuser}) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Map <String,dynamic> m=new Map<String,dynamic>();
  if(name!=null){
    m['name']=name;
  }
  if(lastname!=null){
    m['lastname']=lastname;
  }
  if(area!=null){
    m['area']=area;
  }
  if(permissions!=null){
    m['permissions']=permissions;
  }
  if(uid!=null){
    m['uid']=uid;
  }
  if(superuser==null){
    superuser=0;
  }
  m['superuser']=superuser;

  return users
      .doc(email)
      .update(m)
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}


Future<void> updateProduct(String model,{String brand,String title,String upc,List photos,List bullets,Map technicals,Map customs,Map dimensions,Map manufacturer,List keywords,Map photosNames,dynamic before}) {
  CollectionReference products = FirebaseFirestore.instance.collection('products');




  Map <String,dynamic> m=new Map<String,dynamic>();
  if(brand!=null){
    m['marca']=brand;
  }
  if(title!=null){
    m['titulo']=title;
  }
  if(upc!=null){
    m['upc']=upc;
  }
  if(photos!=null && photosNames!=null){
    List<Map> l=[];
    for(var x in photos){
      Map m=new Map();
      m[x]=photosNames[x];
      l.add(m);
    }

    m['fotos']=l;//photos;
  }
  if(bullets!=null){
    m['bullets']=bullets;
    if(before!=null) {
      log(model:model,field: "Caracteristicas",before: before,after: bullets,type: "Update");
    }
  }
  if(technicals!=null){
    m['tecnicas']=technicals;
  }
  if(customs!=null){
    m['aduana']=customs;
  }
  if(dimensions!=null){
    m['medidas']=dimensions;
  }
  if(manufacturer!=null){
    m['fabricante']=manufacturer;
  }
  if(keywords!=null){
    m['keywords']=keywords;
  }


  return products
      .doc(model)
      .update(m)
      .then((value) => print("Product Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}
/*

Future<Product> getUser(String email)async{

  await FirebaseFirestore.instance
      .collection('users')
      .doc(model)
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      p= new Product(
          title: doc.data()['titulo'],
          model:doc.data()['modelo'],
          brand: doc.data()['marca'],
          upc: doc.data()['upc'],
          dimensions: doc.data()['medidas'],
          customs: doc.data()['aduana'],
          bullets: doc.data()['bullets'],
          technicals: doc.data()['tecnicas']

      );
    }
  });
  return p;
}
*/


/*
  String nombreProyecto;
  String nombreModulo;

  DatabaseService({this.nombreProyecto,this.nombreModulo});
//collection reference
final CollectionReference catalogoCol=FirebaseFirestore.instance.collection('Catalogo');
final CollectionReference proyectosCol=FirebaseFirestore.instance.collection('Proyectos');



/// Check If Document Exists
Future<bool> checkIfDocExists(String coleccion,String docId) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection(coleccion);

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}
  Future<bool> checkIfSubDocExists(String colP,String docP,String colH,String docH) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection(colP).doc(docP).collection(colH);

      var doc = await collectionRef.doc(docH).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

Future insertaCatalogo(int id,String tipo,String descripcion, String proveedor, double precio,String unidades) async{
  print("Insertando...");
return await catalogoCol.doc('$id').set(
  {
    'id':id,
    'tipo':tipo,
    'descripcion':descripcion,
    'proveedor':proveedor,
    'precio':precio,
    'unidades':unidades
  }

);



}

  Future<bool> eliminaProyecto({String nombre})async{
  bool res=false;
  await proyectosCol.doc(nombre).collection("modulos").get().then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs){
      ds.reference.delete();
    };
  });
   await proyectosCol.doc(nombre).delete();
    res= await checkIfDocExists("Proyectos", nombre);
    return !res;

  }

  Future<bool> eliminaModulo({String proyecto,String nombre})async{
    bool res=false;
    await proyectosCol.doc(proyecto).collection("modulos").doc(nombre).delete();

    res= await checkIfSubDocExists("Proyectos", proyecto,"modulos",nombre);
    updateProyecto(nombre: proyecto);
    return !res;

  }

Future updateProyecto({String nombre,String notas,bool completado,DateTime fechaCreacion,double costoMateriales,double costoTotal,double tiempo})async{


  Proyecto proy=await getProyecto(nombre);

  Map<String,dynamic> map=new Map<String,dynamic>();
  map['ultimaActualizacion']=DateTime.now();

  if(notas!=null){
    map['notas']=notas;
  }
  //if(ultimaActualizacion!=null){
  //map['ultimaActualizacion']=DateTime.now();
  //}
  if(fechaCreacion!=null){
    map['fechaCreacion']=fechaCreacion;
  }
  if(completado!=null){
    map['completado']=completado;
  }
  if(tiempo!=null){

    map['tiempo']=tiempo;
  }
  if(costoMateriales!=null){
    map['costoMateriales']=costoMateriales;//+proy.costoMateriales;
  }
  if(costoTotal!=null){
    map['costoTotal']=costoTotal;//+proy.costoTotal;
  }

  print("Actualizacion en BD: ${map}");

  return await proyectosCol.doc(nombre).update(map);
}

  Future updateModulo({String nombre,String notas,DateTime fechaCreacion,double costoMateriales,double costoTotal,double tiempo,String proyecto,Map<String,dynamic>materiales})async{


    Map<String,dynamic> map=new Map<String,dynamic>();

    map['ultimaActualizacion']=DateTime.now();


    if(notas!=null){
      map['notas']=notas;
    }
    if(fechaCreacion!=null){
      map['fechaCreacion']=fechaCreacion;
    }

    if(tiempo!=null){
      map['tiempo']=tiempo;


    }
    if(costoMateriales!=null){
      map['costoMateriales']=costoMateriales;
    }
    if(costoTotal!=null){
      map['costoTotal']=costoTotal;

    }
    if(materiales!=null){
      map['materiales']=materiales;
    }

    print("Actualizacion en BD: ${map}");

    return await proyectosCol.doc(proyecto).collection("modulos").doc(nombre).update(map);

  }

Future<Proyecto> getProyecto(String nombre)async{
Proyecto p=null;
  await FirebaseFirestore.instance
      .collection('Proyectos')
      .doc(nombre)
      .get()
      .then((DocumentSnapshot doc) {

    if (doc.exists) {

      p= new Proyecto(
        nombre:doc.data()['nombre']??"",
        notas: doc.data()['notas']??'',
        completado: doc.data()['completado']??false,
        costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
        costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
        tiempo: (doc.data()['tiempo']??0.0).toDouble(),
        ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
        fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),

      );
    }
  });
  return p;
}

  Future<Modulo> getModulo(String proyecto,String nombre)async{
    Modulo m=null;
    await FirebaseFirestore.instance
        .collection('Proyectos').doc(proyecto).collection("modulos")
        .doc(nombre)
        .get()
        .then((DocumentSnapshot doc) {

      if (doc.exists) {

        m= new Modulo(
          proyecto: doc.data()['proyecto']??"",
          nombre:doc.data()['nombre']??"",
          notas: doc.data()['notas']??'',
          materiales: doc.data()['materiales']??new Map(),
          //completado: doc.data()['completado']??false,
          costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
          costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
          tiempo: (doc.data()['tiempo']??0.0).toDouble(),
          ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
          fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),

        );
      }
    });
    return m;
  }

Future<bool> insertaProyecto(String nombre,bool sobreescribir) async{
  print("Insertando...");
  bool docExists = await checkIfDocExists('Proyectos',nombre);
  print('existe $docExists');

  if(!docExists||sobreescribir){
    if(docExists){
      await proyectosCol.doc(nombre).collection("modulos").get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs){
          ds.reference.delete();
        };
      });
    }
    await proyectosCol.doc(nombre).set(
        {
          'nombre':nombre,
          'notas':"",
          'completado':false,
          'costoTotal':0,
          'costoMateriales':0,
          'tiempo':0,
          'ultimaActualizacion':DateTime.now(),
          'fechaCreacion':DateTime.now(),

        });
    insertaModulo(nombre, "general", true);
    *//*
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection("Proyectos").doc(nombre).collection('modulos').doc("general").set({
      'tiempo':0,

      'nombre':"general",
      'notas': '',
      'materiales':new Map<String,dynamic>(),
      //completado: doc.data()['completado']??false,
      'costoTotal': 0,
      'costoMateriales':0,

      'ultimaActualizacion':  DateTime.now(),
      'fechaCreacion': DateTime.now(),
    }); // your answer missing **.document()**  before setData
    final CollectionReference col=FirebaseFirestore.instance.collection(nombre);
    col.doc("mod0").set({
      'tiempo':0,
    });*//*
    return true;
  }
  else{
    return false;
  }



}

  Future<bool> insertaModulo(String proyecto,String nombre,bool sobreescribir) async{
    print("Insertando...");
    bool docExists = await checkIfSubDocExists('Proyectos',proyecto,"modulos",nombre);
    print('existe $docExists');

    if(!docExists||sobreescribir){
      await proyectosCol.doc(proyecto).collection("modulos").doc(nombre).set(
          {
            'tiempo':0,

            'nombre':nombre,
            'notas': '',
            'materiales':new Map<String,dynamic>(),
            //completado: doc.data()['completado']??false,
            'costoTotal': 0,
            'costoMateriales':0,

            'ultimaActualizacion':  DateTime.now(),
            'fechaCreacion': DateTime.now(),
            'proyecto':proyecto

          });
      await updateProyecto(nombre: proyecto);
      return true;
    }
    else{
      return false;
    }



  }

List<Insumo>_listaInsumosDesdeSnapshot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc){
    return Insumo(
      id:doc.data()['id']??-1,
      proveedor: doc.data()['proveedor']??'',
      tipo: doc.data()['tipo']??'',
      descripcion: doc.data()['descripcion']??'',
      precio: doc.data()['precio']??0,
      unidades: doc.data()['unidades']??'',

    );
  }).toList();
}

List<Proyecto>_listaProyectosDesdeSnapshot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc){
    return Proyecto(
      nombre:doc.data()['nombre']??"",
      notas: doc.data()['notas']??'',
      completado: doc.data()['completado']??false,
      costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
      costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
      tiempo: (doc.data()['tiempo']??0.0).toDouble(),
      ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
      fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),

    );
  }).toList();
}

  List<Modulo>_listaModulosDesdeSnapshot(QuerySnapshot snapshot){


    return snapshot.docs.map((doc){
      return Modulo(
        proyecto: doc.data()['proyecto']??"",
        nombre:doc.data()['nombre']??"",
        notas: doc.data()['notas']??'',
        materiales: doc.data()['materiales']??new Map(),
        //completado: doc.data()['completado']??false,
        costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
        costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
        tiempo: (doc.data()['tiempo']??0.0).toDouble(),
        ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
        fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),

      );
    }).toList();
  }

  Proyecto _proyectosDesdeSnapshot(DocumentSnapshot doc){


      return Proyecto(
        nombre:doc.data()['nombre']??"",
        notas: doc.data()['notas']??'',
        completado: doc.data()['completado']??false,
        costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
        costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
        tiempo: (doc.data()['tiempo']??0.0).toDouble(),
        ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
        fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),

      );

  }

  Modulo _modulosDesdeSnapshot(DocumentSnapshot doc){


    return Modulo(
      proyecto: doc.data()['proyecto']??"",
      nombre:doc.data()['nombre']??"",
      notas: doc.data()['notas']??'',
      materiales: doc.data()['materiales']??new Map(),
      //completado: doc.data()['completado']??false,
      costoTotal: (doc.data()['costoTotal']??0.0).toDouble(),
      costoMateriales: (doc.data()['costoMateriales']??0.0).toDouble(),
      tiempo: (doc.data()['tiempo']??0.0).toDouble(),
      ultimaActualizacion: DateTime.parse((doc.data()['ultimaActualizacion']).toDate().toString())??new DateTime.now(),
      fechaCreacion: DateTime.parse((doc.data()['fechaCreacion']).toDate().toString())??new DateTime.now(),


    );

  }

Stream<List<Insumo>> get catalogo{
  return catalogoCol.orderBy("tipo").orderBy("proveedor").orderBy("descripcion").snapshots().map(_listaInsumosDesdeSnapshot);
}

Stream<List<Proyecto>> get proyectos{
  return proyectosCol.orderBy("ultimaActualizacion",descending: true).snapshots().map(_listaProyectosDesdeSnapshot);
}

  Stream<Proyecto> get proyecto{
    return proyectosCol.doc(nombreProyecto).snapshots().map(_proyectosDesdeSnapshot);

  }

  Stream<List<Modulo>> get modulos{
    return proyectosCol.doc(nombreProyecto).collection('modulos').orderBy("ultimaActualizacion",descending: true).snapshots().map(_listaModulosDesdeSnapshot);
  }


  Stream<Modulo> get modulo{
    return proyectosCol.doc(nombreProyecto).collection("modulos").doc(nombreModulo).snapshots().map(_modulosDesdeSnapshot);

  }*/


}