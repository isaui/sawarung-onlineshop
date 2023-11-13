import 'package:booking_app/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/component/normal_textinput.dart';
import 'package:booking_app/auth/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget{
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() {
    // TODO: implementRe createState
    return _RegisterpageState();
  }
}
class _RegisterpageState extends ConsumerState<RegisterPage>{

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  @override
  void dispose() {
    // Menonaktifkan TextEditingController saat widget dihapus
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  double remToPixels(double rem) {
    // Get the root font size in dp
    final double  rootFontSize = 16;


    // Convert rem to dp
    final fontSizeInDp = rem * rootFontSize;

    return fontSizeInDp;
  }
  @override
  Widget build(BuildContext context) {
    var currWidth = (context)=> MediaQuery.of(context).size.width <= 768 ? 'SMALL' :
    MediaQuery.of(context).size.width <= 1024 ? 'MEDIUM' : 'LARGE';
    var isLandscape = (context) => MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    final registerData = ref.watch(registerDataNotifier);

    double determineRegisterFormHeight(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;

      if (currWidth(context) == 'SMALL') {
        // Jika layar kecil, misalnya, tinggi formulir login adalah 40% dari tinggi layar dalam portrait, dan 60% dalam landscape
        return isLandscape(context) ? screenHeight * 0.8 : screenHeight * 0.4;
      } else if (currWidth(context) == 'MEDIUM') {
        // Jika layar sedang, misalnya, tinggi formulir login adalah 30% dari tinggi layar dalam portrait, dan 50% dalam landscape
        return isLandscape(context) ? screenHeight * 0.5 : screenHeight * 0.3;
      } else {
        // Jika layar besar, misalnya, tinggi formulir login adalah 25% dari tinggi layar dalam portrait, dan 40% dalam landscape
        return isLandscape(context) ? screenHeight * 0.6 : screenHeight * 0.8;
      }
    }

    // TODO: implement build
    return  Scaffold(
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
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height:50),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('Buat Akun', style: TextStyle(color: Colors.white, fontSize: 40),),
                          Text('Tumbuhkan ekonomi UMKM', style:TextStyle(
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
                                            hinText: 'Buat username',
                                            fontSize: 12,
                                            controller: usernameController,
                                          )
                                      ),
                                      Container(
                                          child: CstInput(
                                            text: 'Fullname',
                                            type: 'Username',
                                            hinText: 'Masukkan nama lengkap',
                                            fontSize: 12,
                                            controller:  fullnameController,
                                          )
                                      ),
                                      Container(
                                          child: CstInput(
                                            text: 'Email',
                                            type: 'Email',
                                            hinText: 'Masukkan email kamu',
                                            fontSize: 12,
                                            controller: emailController,
                                          )
                                      ),
                                      Container(
                                          child: CstInput(
                                            text: 'Password',
                                            type: 'Password',
                                            hinText: 'Buat password minimal 8 karakter',
                                            fontSize: 12,
                                            controller: passwordController,
                                          )
                                      ),
                                      Container(
                                          child: CstInput(
                                            text: 'Confirm Password',
                                            type: 'Password',
                                            hinText: 'Konfirmasi password',
                                            fontSize: 12,
                                            controller: passwordConfirmationController,
                                          )
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Sudah punya akun?', style: TextStyle(fontSize: 12),),
                                            TextButton(onPressed: (){Navigator.pushNamed(context, '/');},child: Text('Login', style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),)
                                          ],
                                        ),
                                      ),

                                    ],
                                  )
                              ),
                              Spacer(),
                              Flexible(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: ElevatedButton(
                                            onPressed: () async  {
                                              // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                              String username = usernameController.text.trim();
                                              String email = emailController.text.trim();
                                              String password = passwordController.text.trim();
                                              String passwordConfirmation = passwordConfirmationController.text.trim();
                                              String fullname = fullnameController.text.trim();


                                              if (username.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty || fullname.trim().isEmpty) {
                                                // Salah satu dari field input kosong, tampilkan Snackbar
                                                final snackBar = SnackBar(
                                                  content: Text('Harap isi semua field input'),
                                                  backgroundColor: Colors.red,
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                              } else if( password != passwordConfirmation){
                                                final snackBar = SnackBar(
                                                  content: Text('Password tidak sesuai'),
                                                  backgroundColor: Colors.red,
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              }else {
                                                // Semua field sudah diisi, panggil fungsi register

                                                if(context.mounted){
                                                  ref.read(registerDataNotifier.notifier).setRegisterData(
                                                    RegisterData(username: username, password: password,
                                                        confirmPassword: passwordConfirmation,
                                                        fullName: fullname,
                                                        profilePicture: '',
                                                        email: email)
                                                  );
                                                  Navigator.pushNamed(context, '/register/set-photo');
                                                }
                                                passwordConfirmationController.text = '';
                                                passwordController.text = '';
                                                usernameController.text = '';
                                                fullnameController.text = '';
                                                emailController.text = '';
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
                                                'Register',
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
            )
          )
          ),
      ),
    );
  }
}