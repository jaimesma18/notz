import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notz/classes/Product.dart';
import 'package:notz/classes/User.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/classes/change.dart';
import 'package:notz/services/auth.dart';
import 'package:notz/views/categories.dart';
class DatabaseService{
String model;

  DatabaseService({this.model});
  final CollectionReference productos=FirebaseFirestore.instance.collection('products');


 /*Future log({String id,String collection,String type,String field,dynamic before,dynamic after}){
   CollectionReference log = FirebaseFirestore.instance.collection('log');

   Map <String,dynamic> m=new Map<String,dynamic>();


   m['user']=AuthService().userInfo().email;
   m['timestamp']=DateTime.now();
   m['collection']=collection;
   m['id']=id;
   m['type']=type;
   m['field']=field;
   m['before']=before;
   m['after']=after;


   return log
       .doc()
       .set(m)
       .then((value) => print("Log added"))
       .catchError((error) => print("Failed to add log: $error"));

 }*/
Future logMultiple(List<Change> changes)async{
  for(var x in changes){
    log(x);
  }
}

Future log(Change change){
  
  bool logEnabled=true;
  
  if(logEnabled) {
    CollectionReference log = FirebaseFirestore.instance.collection('log');

    Map <String, dynamic> m = new Map<String, dynamic>();


    m['user'] = change.username??AuthService().userInfo().email;
    m['timestamp'] = change.timestamp??DateTime.now();
    m['collection'] = change.collection;
    m['id'] = change.id;
    m['type'] = change.type;
    m['field'] = change.field;
    m['before'] = change.before;
    m['after'] = change.after;
    m['snapshotBefore']=change.snapshotBefore;
    m['snapshotAfter']=change.snapshotAfter;
    m['notes']=change.notes;


    return  log
        .doc()
        .set(m)
        .then((value) => print("Log added"))
        .catchError((error) => print("Failed to add log: $error"));
  }
}

Product productFromDoc(Map<String,dynamic> m){
  Product p;

  //List photos=[];
  //Map photosNames=new Map();

  /*List tempPhotos=m['fotos'];
  for(var x in tempPhotos){
    photos.add(x.keys.toList()[0]);
    photosNames[x.keys.toList()[0]]=x.values.toList()[0];
  }*/

  p= new Product(
      category: m['category'],
      title: m['titulo'],
      model:m['modelo'],
      brand: m['marca'],
      upc: m['upc'],
      photos: m['photos'],
     // photosName: photosNames,
      //photos: m['fotos'],
      dimensions: m['medidas'],
      customs: m['aduana'],
      bullets: m['bullets'],
      technicals: m['tecnicas']??new Map(),
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

Future<Product> productFromUPC(String upc)async{
  List<Product> ps=[];
  Product pr=null;
  await  FirebaseFirestore.instance
      .collection('products')
      .where('upc', isEqualTo: upc)
      .get()
      .then((QuerySnapshot snapshot){
    for (var x in snapshot.docs){
      Product p=productFromDoc(x.data());
      ps.add(p);
    }

  });


  if(ps.isNotEmpty){
    pr=ps[0];
  }

  return pr;
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
      u.disabled=doc.data()['disabled'];
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


Future<void> updateProduct(String model,{String brand,String title,String upc,List photos,List bullets,Map technicals,Map customs,Map dimensions,Map manufacturer,List keywords,Map photosNames,dynamic change}){//dynamic before,String updateReason}) {
  CollectionReference products = FirebaseFirestore.instance.collection('products');

if(change!=null) {
  if (change is List<Change>) {
    logMultiple(change);
  }
  else {
    log(change);
  }
}


  Map <String,dynamic> m=new Map<String,dynamic>();
  if(brand!=null){
    m['marca']=brand;
  }
  if(title!=null){
    m['titulo']=title;
  }
  if(upc!=null){
    m['upc']=upc;
    /*if(before!=null) {
      log(collection:"Productos",id:model,field: "UPC",before: before,after: upc,type: "Update");
    }*/
  }
  if(photos!=null){
    m['photos']=photos;
  }

/*  if(photos!=null && photosNames!=null){
    List<Map> l=[];
    for(var x in photos){
      Map m=new Map();
      m[x]=photosNames[x];
      l.add(m);
    }

    m['fotos']=l;//photos;
  }*/
  if(bullets!=null){
    m['bullets']=bullets;
    /*if(before!=null) {
      log(collection:"Productos",id:model,field: "Caracteristicas",before: before,after: bullets,type: "Update");
    }*/
  }
  if(technicals!=null){
    m['tecnicas']=technicals;
   /* if(before!=null) {
      String reason="Update";
      if(updateReason!=null){
        reason=updateReason;
      }
      log(collection:"Productos",id:model,field: "Tecnicas",before: before,after: technicals,type: reason);
    }*/
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

Future<Map<String,Category>> getCategories({String parent})async{
   Map<String,Category> m=new Map<String,Category>();



   if(parent==null) {
     await FirebaseFirestore.instance
         .collection('categories').where(
         "parent", isNull: true)
         .get()
         .then((QuerySnapshot snapshot) {
       for (var x in snapshot.docs) {
         Category c = categoryFromDoc(x.data(), x.id);
         m[c.name] = c;
       }
     });
   }
   else{
     await FirebaseFirestore.instance
         .collection('categories').where(
         "parent", isEqualTo: parent)
         .get()
         .then((QuerySnapshot snapshot) {
       for (var x in snapshot.docs) {
         Category c = categoryFromDoc(x.data(), x.id);
         m[c.name] = c;
       }
     });
   }

  return m;
}

Future<Category> getCategory(String id)async{
  Category c =null;

  await FirebaseFirestore.instance
        .collection('categories')
      .doc(id)
      .get()
      .then((DocumentSnapshot doc) {

      if (doc.exists) {
   c=categoryFromDoc(doc.data(), doc.id);
      }});


  return c;
}

Category categoryFromDoc(Map<String,dynamic> m,String id){
  Category c = new Category(
      name: m['name'],
      id: id,
      template: m['template'],
      parent: m['parent']);

  return c;
}

Future<void> updateCategory(String id,{String name,String parent,Map template,dynamic before}) {
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');


  Map <String,dynamic> m=new Map<String,dynamic>();
  if(name!=null){
    m['name']=name;
  }
  if(parent!=null){
    m['parent']=parent;
  }
  if(template!=null){
    m['template']=template;
    /*if(before!=null) {
      log(collection:"Categorias",id:id,field: "Template",before: before,after: template,type: "Update");
    }*/
  }



  return categories
      .doc(id)
      .update(m)
      .then((value) => print("Categories Updated"))
      .catchError((error) => print("Failed to update categories: $error"));
}

Future updateProductsTechnical(String category,int action,String field,{String type,String newField})async{

   //action: [0: delete, 1:update, 2:rename, 3:add]

  if(action>0&&type.startsWith("*")) {

    await  FirebaseFirestore.instance
        .collection('products')
        .where('category',isEqualTo: category)
        .get()
        .then((QuerySnapshot snapshot)async{
      for (var x in snapshot.docs){
        Product p=productFromDoc(x.data());

        Map technicals=new Map();
        for(var x in p.technicals.keys){
          technicals[x]=p.technicals[x];
        }
        if(action==1) {
          if (p.technicals[field] == null) {
            p.technicals[field] = new Map();
            p.technicals[field]['value'] = null;
            p.technicals[field]['type'] = type;
            p.technicals[field]['exists'] = true;
          }
          else {
            p.technicals[field]['type'] = type;
          }
        }

        if(action==2){

          if(p.technicals[field]==null){
            p.technicals.remove(field);
          }

          Map m=p.technicals.remove(field);
          m['type']=type;
          p.technicals[newField]=m;
        }

        if(action==3){

          print(p.model);
          if(p.technicals[field]==null){
            p.technicals[field]=new Map();
            p.technicals[field]['value'] = null;
            p.technicals[field]['type'] = type;
            p.technicals[field]['exists'] = true;
          }
          else{
            p.technicals[field]['type'] = type;
          }


        }

        //await updateProduct(p.model,technicals: p.technicals,before: technicals,updateReason: "Triggered");
      }

    });

  }
  else{
  await  FirebaseFirestore.instance
      .collection('products')
      .where('category',isEqualTo: category).where('tecnicas.$field.exists',isEqualTo: true)
      .get()
      .then((QuerySnapshot snapshot)async{
    for (var x in snapshot.docs){
      Product p=productFromDoc(x.data());
      Map technicals=new Map();
      for(var x in p.technicals.keys){
        technicals[x]=p.technicals[x];
      }
      if(action==0){
        if(p.technicals[field]['value']==null){
          p.technicals.remove(field);
        }
        else {
          String t = p.technicals[field]['type'];
          if (t.startsWith("*")) {
            t = t.substring(1);
          }
          p.technicals[field]['type'] = t;
        }
      }
      if(action==1){
        if(p.technicals[field]['value']==null){
          p.technicals.remove(field);
        }
        else {
          p.technicals[field]['type'] = type;
        }
      }
      if(action==2){
        Map m=p.technicals.remove(field);
        m['type']=type;
        if(m['value']!=null) {
          p.technicals[newField] = m;
        }


      }

      if(action==3){
        p.technicals[field]['type'] = type;
      }


     // await updateProduct(p.model,technicals: p.technicals,before: technicals,updateReason: "Triggered");
    }
  });}

  //return ps;
}


}