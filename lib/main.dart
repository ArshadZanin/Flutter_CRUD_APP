import 'package:flutter/material.dart';
import 'package:sqlite_app/db/databaseProvider.dart';
import 'package:sqlite_app/student_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sqlite App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Students Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      // await this.addUsers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StudentForm()),
              );
              setState(() {});
            },
            icon: Icon(Icons.person_add_alt_1_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MyApp()),
              );
              setState(() {});
            },
            icon: Icon(Icons.replay_outlined,),
          ),
        ],
      ),
      body: FutureBuilder(
        future: this.handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text("Name: ${snapshot.data![index].name!}"),
                      subtitle: Text(
                          "Age: ${snapshot.data![index].age.toString()}\nPlace: ${snapshot.data![index].place!}\nEmail: ${snapshot.data![index].email!}"),
                      onLongPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentForm(student: snapshot.data![index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Future<int> addUsers() async {
  //   User firstUser = User(
  //       name: 'Arshad',
  //       age: '20',
  //       place: 'Kadampuzha',
  //       email: 'arshad@gmail.com');
  //   User secondUser =
  //       User(name: 'Ashik', age: '25', place: 'Kottoor', email: 'sss@g.com');
  //   List<User> listOfUser = [firstUser, secondUser];
  //   return await this.handler.insertUser(listOfUser);
  // }
}
