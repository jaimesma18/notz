import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notz/classes/Product.dart';
import 'package:notz/classes/User.dart';
import 'package:notz/classes/category.dart';
import 'package:notz/services/auth.dart';
import 'package:notz/views/categories.dart';
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
      category: m['category'],
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

}