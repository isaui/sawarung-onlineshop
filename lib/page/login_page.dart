import 'package:booking_app/auth/authentication.dart';
import 'package:booking_app/component/normal_textinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/provider/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget{
  const LoginPage({super.key});
  ConsumerState<LoginPage> createState()=> _LoginPageState();
}
class _LoginPageState extends ConsumerState<LoginPage>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setLoginState(ref, token)  {
    ref.read(authNotifierProvider.notifier).login(token);
  }

  @override
  Widget build(BuildContext context) {
    var auth = ref.watch(authNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                  Colors.blue.shade800
                ],
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50,),
              Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 40),),
                          Text('Selamat datang kembali di Sawarung', style:TextStyle(
                              color:Colors.grey.shade400, fontSize: 16)),
                        ]
                    ),
                  ),
              Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 40,),
                          Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      child: CstInput(
                                        text: 'Username',
                                        type: 'Username',
                                        hinText: 'Masukkan username',
                                        fontSize: 12,
                                        controller: usernameController,
                                      )
                                  ),
                                  Container(
                                      child: CstInput(
                                        text: 'Password',
                                        type: 'Password',
                                        hinText: 'Masukkan password',
                                        fontSize: 12,
                                        controller: passwordController,
                                      )
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Belum punya akun?', style: TextStyle(fontSize: 12),),
                                        TextButton(onPressed: (){
                                        Navigator.pushNamed(context, '/register');
                                        },child: Text('Register', style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),)
                                      ],
                                    ),
                                  ),

                                ],
                              )
                          ),
                          Expanded(child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      String username = usernameController.text;
                                      String password = passwordController.text;
                                      if(username.trim().isEmpty || password.trim().isEmpty){
                                        final snackBar = SnackBar(
                                          content: Text('Tolong isi semua bidang'),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                      else{
                                        String? res  = await login(username, password, context);
                                        if(res != null){
                                          setLoginState(ref,res);
                                          Navigator.pushReplacementNamed(context, '/app');
                                        }
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[400], // Warna latar belakang biru
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0), // Membuat tombol berbentuk rounded
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity, // Membuat tombol mengambil lebar penuh
                                      alignment: Alignment.center, // Membuat konten tombol berada di tengah
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks putih
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ))
            ],
          ) ,
        ),
      ),
    );
  }
}