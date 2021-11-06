import 'package:flutter/material.dart';
import 'package:sqlite_app/db/databaseProvider.dart';
import 'package:sqlite_app/main.dart';

class StudentForm extends StatefulWidget {
  final User? student;
  final int? studentIndex;

  StudentForm({this.student, this.studentIndex});

  @override
  State<StatefulWidget> createState() {
    return StudentFormState();
  }
}

class StudentFormState extends State<StudentForm> {
  String? _name;
  String? _age;
  String? _place;
  String? _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 15),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _name = value;
      },
    );
  }

  Widget _buildAge() {
    return TextFormField(
      initialValue: _age,
      decoration: InputDecoration(labelText: 'Age'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 15),
      validator: (String? value) {
        int? age = int.tryParse(value!);

        if (age == null || age <= 5) {
          return 'Age must be greater than 5';
        }

        return null;
      },
      onSaved: (String? value) {
        _age = value;
      },
    );
  }

  Widget _buildPlace() {
    return TextFormField(
      initialValue: _place,
      decoration: InputDecoration(labelText: 'Place'),
      maxLength: 15,
      style: TextStyle(fontSize: 15),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Place is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _place = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      initialValue: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email'),
      maxLength: 35,
      style: TextStyle(fontSize: 15),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _email = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _name = widget.student!.name;
      _age = widget.student!.age.toString();
      _place = widget.student!.place;
      _email = widget.student!.email;
    }
  }

  @override
  @deprecated
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey[800], title: Text("Student Data")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildAge(),
              SizedBox(height: 20),
              _buildPlace(),
              SizedBox(height: 20),
              _buildEmail(),
              SizedBox(height: 20),
              widget.student == null
                  ? RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      color: Colors.grey,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        _formKey.currentState!.save();

                        User student = User(
                            name: _name,
                            age: _age,
                            place: _place,
                            email: _email);

                        List<User> listOfUser = [student];

                        DatabaseHandler db = DatabaseHandler();

                        await db.insertUser(listOfUser);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState!.save();

                            // User student = User(
                            //   name: _name,
                            //   age: _age,
                            //   place: _place,
                            //   email: _email,
                            // );
                            //
                            // List<User> listOfUser = [student];

                            DatabaseHandler db = DatabaseHandler();
                            // listOfUser
                            await db.updateUser(widget.student!.id!, _name!, _age!, _place!, _email!);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          },
                        ),
                        RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                ),
                              );
                            }),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
