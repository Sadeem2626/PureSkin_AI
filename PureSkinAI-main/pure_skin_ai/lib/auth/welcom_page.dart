import 'package:flutter/material.dart';
import 'package:pure_skin_ai/auth/login_page.dart';
import 'package:pure_skin_ai/auth/register_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bac1.jpeg',),fit: BoxFit.cover)
        ),
       //image
        child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
               width: 385,
                height: 422,
                 child: Image(image: AssetImage('assets/ff1.png'))
             ),
              //taxt
              Container(
                width: 343,
                height: 171,
                child: Column(children: 
                [Text(textAlign: TextAlign.center,'PureSkin AI',
                style: TextStyle(fontSize: 35 ,fontWeight: FontWeight.w900,color: Color(0xFF5F8063),fontFamily: 'Poppins',),),
                SizedBox(height: 20),
                Text(textAlign: TextAlign.center,'Your AI-Powered Skincare Assistant',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color.fromARGB(255, 72, 86, 72),fontFamily: 'Poppins' ,))],
                )
              )
               ,SizedBox(height: 88),
              //button
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                //Login button
              
                children: [
                   InkWell(
                     splashColor:Colors.transparent,
                     highlightColor:Colors.transparent,
                     hoverColor:Colors.transparent,
            
                    onTap: () {
                     Navigator.of(context,).push(MaterialPageRoute(builder:(context) => LogIn(),));
                    },
                    child: Container(
                      //Login button
                      width: 160,
                      height: 60,
                      decoration: BoxDecoration(color: Color(0xFF5F8063),
                      boxShadow:[BoxShadow(color:  Color(0xFF5F8063),offset: Offset(0, 5),blurRadius: 10)],
                      borderRadius: BorderRadius.circular(10)), 
                      child: Center(child: Text('Login',
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Poppins')) ,) ,),
                  ),
                  //regster butten
                    InkWell(
                      splashColor:Colors.transparent,
                     highlightColor:Colors.transparent,
                     hoverColor:Colors.transparent, 
                    onTap: 
                    () {
                      Navigator.of(context,).push(MaterialPageRoute(builder:(context) =>   Register(),));
                      
                    }, 
                     child: Container(
                      //Login button
                      width: 160,
                      height: 60,
                      child: Center(child: Text('Register',
                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Poppins') ,),) ,),
                   ),
                ],
              )
                ],
              
            ),
      ),
    );
  }
}