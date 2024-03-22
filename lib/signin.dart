import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key});

  @override
  State<StatefulWidget> createState() => _Signin();
}

class _Signin extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 230, 81, 0),
          Color.fromARGB(255, 239, 108, 0),
          Color.fromARGB(255, 239, 167, 38)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 88,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Welcome Back!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Form(
                        child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(240, 144, 104, 0.988),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)),
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 238, 238, 238)))),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 238, 238, 238)))),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Text("Forget Password?", style: TextStyle(color: Colors.grey), ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: (){},
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child:
                                  Text("Sign up", style: TextStyle(color: Color.fromARGB(255, 230, 81, 0), decoration: TextDecoration.underline),),
                                
                              ),
                            )
                          ],),
                          SizedBox(height: 10,),
                          MaterialButton(onPressed: (){},
                          color: Color.fromARGB(255, 230, 81, 0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          minWidth: 200,
                          height: 50,
                          child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),)
                        ],
                      ),
                    ))))
          ],
        ),
      ),
    ));
  }
}
