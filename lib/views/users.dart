import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notz/classes/User.dart';
import 'package:notz/services/db.dart';
import 'package:notz/services/auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';



class AccountService {
  static  List<String> areas = [

  ];


  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(areas);


    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}


class Users extends StatefulWidget {

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  final AuthService _auth=AuthService();
  User user;
  Map permissions = new Map();
  Map data = new Map();
 // bool isOwner = false;
  int maxLevel=0;
  double opaque = .3;
  bool loaded=false;
  int superuser=0;
  List<String>areas;
  final _formKey = GlobalKey<FormState>();
  Map<String,int>viewsPermissions=new Map<String,int>();



  //Color buttonColor=Colors.grey;
  String buttonText = "Agregar";
/*  int gAduanal = 0;
  int gCaracteristicas = 0;
  int gClientes = 0;
  int gContenido = 0;
  int gCBarras = 0;
  int gTecnicas = 0;
  int gFabricante = 0;
  int gManual = 0;
  int gMedidas = 0;*/
  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController area = new TextEditingController();
  TextEditingController suser = new TextEditingController();

  void reset(){
    buttonText = "Agregar";
    for(var x in viewsPermissions.keys){
      viewsPermissions[x]=0;
    }
    // gAduanal = 0;
    // gCaracteristicas = 0;
    // gClientes = 0;
    // gContenido = 0;
    // gCBarras = 0;
    // gTecnicas = 0;
    // gFabricante = 0;
    // gManual = 0;
    // gMedidas = 0;
    name.text = "";
    lastname.text = "";
    if(superuser==null||superuser>=2){
      area.text = "";
    }
    else{
      area.text=user.area;
    }
    //superuser<2?:area.text = "";
    suser.text="";
  }

  @override
  void initState() {
    super.initState();



    init();



  }

  Future init()async{

    downloadViewsPermissions().whenComplete((){
      setState(() {
      });
    });
    downloadAreas().whenComplete((){
      setState(() {
        AccountService.areas=areas;
      });
    });

  }

  Future downloadViewsPermissions()async{
    List l= await DatabaseService().getViewsPermissions();

    for(var x in l){
      viewsPermissions[x]=0;
    }
    //DatabaseService().getAreas().then((value) => areas=value);
  }
  Future downloadAreas()async{
    areas= await DatabaseService().getAreas();
    return areas;
    //DatabaseService().getAreas().then((value) => areas=value);
  }

  Future addArea()async{
    await DatabaseService().addArea(areas);
  }
  
 

 Future getOtherUserData()async{
    DatabaseService().getUser(_auth.userInfo().email).then((value) => user=value);


    permissions=user.permissions;
    superuser=user.superuser;
     for(var x in permissions.keys){
       if(permissions[x]>maxLevel){
         maxLevel=permissions[x];
       }

      /* if(permissions[x]>=4){
           isOwner=true;
         }*/

       }
     if(superuser<2){
       area.text=user.area;
     }
       setState(() {
        // loaded=true;
       });

     //userManagement=await _auth.userManagement();
  }

  Future<String> createNewUser(String email)async{
    String uid;
    HttpsCallableOptions options=new HttpsCallableOptions(timeout: Duration(seconds: 10));
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createUser',options: options);
    Map m=new Map();
    m['email']=email;
    m['password']='password';
    HttpsCallableResult res= await callable.call(m);
    uid=res.data;
    return uid;
  }
  bool isEmail(String email) {
    bool res = false;
    //bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    //if(emailValid&&(email.endsWith("@lloydselectronica.com")))

    if (email.endsWith("@lloydselectronica.com") ||
        email.endsWith("@noveltia.com") ||
        email.endsWith("@zuttotechnologies.com")) {
      res = true;
    }

    setState(() {
      if (res) {
        opaque = 1;
      }
      else {
        opaque = .3;
        reset();
      }
    });

    // print(res);
    return res;
  }

  bool bounce(User u){
    bool res=false;

    if(superuser<3) {
      if (u.superuser > superuser) {
        res = true;
      }
      if(u.email==user.email){
        res=true;
      }
      if(u.area!=user.area&&user.area!="Gerencia"){
        res=true;
      }
    }


    return res;
  }

  Future<User> getUserPermissions(String email) async {
    DatabaseService db = new DatabaseService();
    User u = await db.getUser(email);
    setState(() {
      if (u == null) {
       reset();
       suser.text='0';
      }

      else {
        bool reject=bounce(u);
        if (reject) {
          setState(() {
            opaque=0.3;
          });

        }
        else {

          Map m = u.permissions;
          buttonText = "Editar";
          for(var x in viewsPermissions.keys){
            viewsPermissions[x]=m[x]??0;
          }
         /* gAduanal = m['Aduanales'];
          gCaracteristicas = m['Características'];
          gClientes = m['Clientes'];
          gContenido = m['Contenido'];
          gCBarras = m['Código de Barras'];
          gTecnicas = m['Especificaciones Técnicas'];
          gFabricante = m['Fabricante'];
          gManual = m['Manual'];
          gMedidas = m['Medidas'];*/
          name.text = u.name;
          lastname.text = u.lastname;
          area.text = u.area;
          suser.text='${u.superuser}';
        }
      }
    });

    return u;
  }

  Future updateUser(
      {String email, String name, String lastname, String area, String uid, Map permissions,int superuser}) async {
    DatabaseService db = new DatabaseService();
    await db.updateUser(email, name: name,
        lastname: lastname,
        area: area,
        permissions: permissions,superuser: superuser);
  }

  Future addUser(
      {String email, String name, String lastname, String area, String uid, Map permissions,int superuser}) async {
    DatabaseService db = new DatabaseService();
    await db.addUser(email, name: name,
        lastname: lastname,
        area: area,
        permissions: permissions,
        uid: uid,
    superuser: superuser
    );
  }
  


  Widget build(BuildContext context) {

    //if(!loaded) {
      data =
          ModalRoute
          .of(context)
          .settings
          .arguments;
      if (data != null) {
        user = data['user'];
        permissions = user.permissions;
        maxLevel=data['maxLevel'];
       // isOwner = data['isOwner'];
        superuser = user.superuser;
        if (superuser < 2) {
          area.text = user.area;
        }
        loaded = true;
      }
      else {
        if (user == null) {
          getOtherUserData().whenComplete(() => loaded = true);
        }
      }
      //if(!loaded){
       // AccountService.areas=areas;
      //  loaded=true;
    //  }

   // }




    return
      !loaded?Container():Scaffold(
          appBar: AppBar(title: Text("Manejo de Usuarios"),),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container( //width: 1000,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 20, 10),
                        child: Row(
                          children: [
                            Expanded(flex: 10,
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                    hintText: "email"),
                                onChanged: (val) async {
                                  bool isMail = isEmail(val);
                                  if (isMail) {
                                    User u = await getUserPermissions(val);
                                    if (u != null) {


                                    }
                                    else {
                                      //print("No hay");
                                    }
                                  }
                                },),
                            ),
                            superuser>=3?Expanded(flex: 1, child: Container(),):Container(),
                            superuser>=3?Expanded(flex: 3, child: TextField(decoration: InputDecoration(hintText:"Superuser" ),
                              controller: suser,),):Container(),
                            Expanded(flex: 1, child: Container(),),
                            Expanded(flex: 3, child: Opacity(opacity: opaque,
                              //child: FlatButton(child: Text(buttonText,style: TextStyle(color: Colors.blue,fontSize: 24),),onPressed:opaque==0?null: (){},),),
                              child: RaisedButton(child: Text(buttonText,
                                style: TextStyle(color: Colors.white),),
                                onPressed:

                                opaque == 1 ? () async {
                    if(_formKey.currentState.validate()) {
                                  if(area.text!=null&&!areas.contains(area.text)){
                                     areas.add(area.text);
                                    await addArea();
                                  }
                                  Map<String, int> m = new Map<String, int>();
                                  for(var x in viewsPermissions.keys){
                                    m[x]=viewsPermissions[x];
                                  }
                                 /* m['Aduanales'] = gAduanal;
                                  m['Características'] = gCaracteristicas;
                                  m['Clientes'] = gClientes;
                                  m['Contenido'] = gContenido;
                                  m['Código de Barras'] = gCBarras;
                                  m['Especificaciones Técnicas'] = gTecnicas;
                                  m['Fabricante'] = gFabricante;
                                  m['Manual'] = gManual;
                                  m['Medidas'] = gMedidas;*/
                                  if (buttonText == "Editar") {
                                    await updateUser(email: email.text,
                                        name: name.text,
                                        lastname: lastname.text,
                                        area: area.text,
                                        permissions: m,superuser: suser.text==null?0:int.parse(suser.text));
                                  }
                                  else {
                                    int sus;
                                    suser.text==null?sus=0:sus=int.parse(suser.text);

                                  /*  AuthService _auth = new AuthService();
                                    dynamic res = await _auth.signUp(
                                        email.text, "password");
                                    String uid = res.uid;*/
                                    String uid=await createNewUser(email.text);
                                    await _auth.resetPassword(email.text);
                                    await addUser(email: email.text,
                                        name: name.text,
                                        lastname: lastname.text,
                                        area: area.text,
                                        permissions: m,
                                        uid: uid,
                                        superuser:sus);
                                  }
                                  setState(() {
                                    email.text="";
                                    reset();
                                  });
                                }} : null,
                                color: Colors.blue,),)
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 20, 10),
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(flex: 6,
                                child: TextFormField(validator:(val)=>val.length==0?"Ingresa un nombre":null,
                                  controller: name, decoration: InputDecoration(
                                    hintText: "\t\t\tNombre",),),
                              ),
                              Expanded(flex: 1, child: Container(),),
                              Expanded(flex: 6,
                                child: TextFormField(validator:(val)=>val.length==0?"Ingresa un apellido":null,controller: lastname,
                                  decoration: InputDecoration(
                                      hintText: "\t\t\tApellido",),),
                              ),
                              Expanded(flex: 1, child: Container(),),
                              Expanded(flex: 6,
                                child:
                                superuser>=2?
                                TypeAheadFormField(textFieldConfiguration:TextFieldConfiguration(decoration:InputDecoration(labelText: "Area",hintText: "\t\t\tArea",),controller: area),suggestionsCallback:(pattern)  {
                                  return  AccountService().getSuggestions(pattern);
                                }, itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    // leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion),
                                    // subtitle: Text('\$${suggestion['price']}'),
                                  );
                                },
                                  onSuggestionSelected: (suggestion) {
                                    setState(() {
                                      area.text=suggestion;
                                    });

                                  },validator: (val)=>area.text.isEmpty?"Ingresa Area":null,):Text("\t\t\t${area.text}"),
                              /*  superuser>=2?TextFormField(validator:(val)=>val.length==0?"Ingresa departamento":null,
                                  controller: area, decoration: InputDecoration(
                                    hintText: "\t\t\tArea"),):Text("\t\t\t${area.text}"),*/
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                     buildTable(),

                      SizedBox(height: 40,),
                    ],
                  )


              ),
            ),
          ));
  }

  Widget buildTable() {

    List<DataColumn>columns = [];
    List<DataRow>rows = [];
    List<String> head = [
      'Permiso',
      "   Ninguno",
      "   Lectura",
      "    Lectura/Escritura"
    ];
 /*   if (isOwner) {
      head.add("    Administrador");
      head.add("  Dueño");
    }*/
    if(maxLevel==4){
      head.add("    Administrador");
    }
    if(maxLevel==5){
      head.add("    Administrador");
      head.add("Super Administrador");
      head.add(" Dueño");
    }


    for (var x in head) {
      columns.add(DataColumn(label: Center(child: Text(x))));
    }


    //List<String> body = [];
    int n = 3;
   /* if (isOwner) {
      n = 5;
    }*/
    if(maxLevel==4){
      n=4;
    }
    if(maxLevel==5){
      n=6;
    }

   List h=viewsPermissions.keys.toList();
    h.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

    for(var x in h){

      if(permissions[x]==null){
        if(superuser==2){
          permissions[x]=4;
        }
        if(superuser==3){
          permissions[x]=5;
        }
        if(superuser<2){
          permissions[x]=0;
        }
      }

      if (permissions[x] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text(x)));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity:permissions[x]<=i&&permissions[x]<5&&superuser<3?0.3:1,
              child: Radio(value: i, groupValue: viewsPermissions[x], onChanged:permissions[x]<=i&&permissions[x]<5&&superuser<3?null: (val) {
                setState(() {
                  viewsPermissions[x] = val;
                });
              },),
            ),),));
        }

        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
    }


    /*if (permissions['Aduanales'] >= 3) {
      List<DataCell>cells=[];
     cells.add(DataCell(Text("Aduanales")));
      for (int i = 0; i < n; i++) {
        cells.add(DataCell(Align(alignment: Alignment.center,
          child: Opacity(opacity:permissions["Aduanales"]<=i&&permissions["Aduanales"]<5&&superuser<3?0.3:1,
            child: Radio(value: i, groupValue: gAduanal, onChanged:permissions["Aduanales"]<=i&&permissions["Aduanales"]<5&&superuser<3?null: (val) {
              setState(() {
                gAduanal = val;
              });
            },),
          ),),));
      }

      DataRow dr = new DataRow(cells:cells);
      rows.add(dr);
    }


    if (permissions["Características"] >= 3) {
      List<DataCell>cells=[];

      cells.add(DataCell(Text("Características")));
      for (int i = 0; i < n; i++) {
        cells.add(DataCell(Align(alignment: Alignment.center,
          child: Opacity(opacity:permissions["Características"]<=i&&permissions["Características"]<5&&superuser<3?0.3:1,
            child: Radio( value: i, groupValue: gCaracteristicas, onChanged:permissions["Características"]<=i&&permissions["Características"]<5&&superuser<3?null: (val) {
              setState(() {
                gCaracteristicas = val;
              });
            },),
          ),),));
      }
      DataRow dr = new DataRow(cells:cells);
      rows.add(dr);
    }


    if (permissions["Clientes"] >= 3) {
      List<DataCell>cells=[];
      cells.add(DataCell(Text("Clientes")));
      for (int i = 0; i < n; i++) {
        cells.add(DataCell(Align(alignment: Alignment.center,
          child: Opacity(opacity: permissions["Clientes"]<=i&&permissions["Clientes"]<5&&superuser<3
              ? 0.3
              : 1,
            child: Radio(value: i, groupValue: gClientes, onChanged: permissions["Clientes"]<=i&&permissions["Clientes"]<5&&superuser<3
                ? null:(val) {
              setState(() {
                gClientes = val;
              });
            },),
          ),),));
      }
      DataRow dr = new DataRow(cells:cells);
      rows.add(dr);
    }
      if (permissions["Contenido"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Contenido")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Contenido"]<=i&&permissions["Contenido"]<5&&superuser<3?0.3:1,
              child: Radio(value: i, groupValue: gContenido, onChanged:permissions["Contenido"]<=i&&permissions["Contenido"]<5&&superuser<3?null: (val) {
                setState(() {
                  gContenido = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
      if (permissions["Código de Barras"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Código de Barras")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Código de Barras"]<=i&&permissions["Código de Barras"]<5&&superuser<3?0.3:1,
              child: Radio(  value: i, groupValue: gCBarras, onChanged:permissions["Código de Barras"]<=i&&permissions["Código de Barras"]<5&&superuser<3?null: (val) {
                setState(() {
                  gCBarras = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
      if (permissions["Especificaciones Técnicas"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Especificaciones Técnicas")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Especificaciones Técnicas"]<=i&&permissions["Especificaciones Técnicas"]<5&&superuser<3?0.3:1,
              child: Radio(  value: i, groupValue: gTecnicas, onChanged:permissions["Especificaciones Técnicas"]<=i&&permissions["Especificaciones Técnicas"]<5&&superuser<3?null:(val) {
                setState(() {
                  gTecnicas = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
      if (permissions["Fabricante"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Fabricante")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Fabricante"]<=i&&permissions["Fabricante"]<5&&superuser<3?0.3:1,
              child: Radio(
                value: i, groupValue: gFabricante, onChanged: permissions["Fabricante"]<=i&&permissions["Fabricante"]<5&&superuser<3?null:(val) {
                setState(() {
                  gFabricante = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
      if (permissions["Manual"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Manual")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Manual"]<=i&&permissions["Manual"]<5&&superuser<3?0.3:1,
              child: Radio(value: i, groupValue: gManual, onChanged:permissions["Manual"]<=i&&permissions["Manual"]<5&&superuser<3?null: (val) {
                setState(() {
                  gManual = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }
      if (permissions["Medidas"] >= 3) {
        List<DataCell>cells=[];
        cells.add(DataCell(Text("Medidas")));
        for (int i = 0; i < n; i++) {
          cells.add(DataCell(Align(alignment: Alignment.center,
            child: Opacity(opacity: permissions["Medidas"]<=i&&permissions["Medidas"]<5&&superuser<3?0.3:1,
              child: Radio(
                value: i, groupValue: gMedidas, onChanged:permissions["Medidas"]<=i&&permissions["Medidas"]<5&&superuser<3?null: (val) {
                setState(() {
                  gMedidas = val;
                });
              },),
            ),),));
        }
        DataRow dr = new DataRow(cells:cells);
        rows.add(dr);
      }*/

    return DataTable(columns: columns,rows: rows,);
  }


}
