import 'package:booking_app/auth/authentication.dart';
import 'package:booking_app/provider/register_provider.dart';
import 'package:booking_app/api/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';



class AddPhotoProfilePage extends ConsumerStatefulWidget{

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _AddPhotoProfilePageState();
  }
}

class _AddPhotoProfilePageState extends ConsumerState<AddPhotoProfilePage>{
  String? uploadImageUrl;
  bool isLoading = false;
  Future<void >uploadPhotoProfile() async {


    String? res;
    if (! kIsWeb){
      final imagePicker = ImagePicker();

      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        // Batal memilih gambar
        return;
      }
      setState(() {
        isLoading = true;
      });
      final file = File(pickedFile.path);
      res = await uploadImageToFirebase(file);
    }
    else{
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if(result == null){
        return;
      }
      setState(() {
        isLoading = true;
      });
      final uint8Lst = result.files.single.bytes!;
      res = await uploadImageToFirebaseWeb(uint8Lst);
    }

    if(res != null){
      setState(() {
        uploadImageUrl = res;
      });
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    RegisterData? registerData = ref.watch(registerDataNotifier);
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        color: Colors.blue.shade400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Column(
                  children: [ Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180, // Atur lebar gambar sesuai kebutuhan
                        height: 180, // Atur tinggi gambar sesuai kebutuhan
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey, // Warna latar belakang gambar
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 120,
                            backgroundColor: Colors.white, // Warna latar belakang lingkaran
                            backgroundImage: NetworkImage(
                                uploadImageUrl??'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'), // Gambar profil
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5, // Atur posisi tombol plus di atas gambar
                        right: 5,
                        child: GestureDetector(
                          child: Container(
                            width: 50, // Atur lebar tombol plus sesuai kebutuhan
                            height: 50, // Atur tinggi tombol plus sesuai kebutuhan
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue, // Warna latar belakang tombol plus
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white, // Warna ikon tombol plus
                              ),
                            ),
                          ),
                          onTap: (){
                            uploadPhotoProfile();
                          },
                        ),
                      ),
                    ],),
                    SizedBox(height: 20,),
                    Text('Tambahkan Foto Profil', style: TextStyle(
                        fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold
                    ),),],
                )),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                          onPressed: () async {
                            if(uploadImageUrl == null){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum menambahkan foto profil'), backgroundColor: Colors.red,));
                              return;
                            }
                            ref.read(registerDataNotifier.notifier).addProfilePicture(uploadImageUrl!);

                            String res = await register(registerData!.username, registerData!.fullName,
                                registerData!.email, registerData!.password, registerData!.confirmPassword,
                                uploadImageUrl, context);
                            if(res == 'SUCCESS'){
                              ref.read(registerDataNotifier.notifier).clearRegisterData();
                              Navigator.pushReplacementNamed(context, '/');
                            }
                            // Aksi saat tombol "Lanjutkan" ditekan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800, // Warna latar belakang tombol "Lanjutkan"
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Padding tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                            ),
                          ),
                          child: Text(
                            'Lanjutkan',
                            style: TextStyle(
                              fontSize: 18, // Ukuran teks
                              color: Colors.white, // Warna teks
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,), // Jarak antara tombol "Lanjutkan" dan "Lewati"
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: OutlinedButton(
                          onPressed: () async {
                            ref.read(registerDataNotifier.notifier).addProfilePicture(uploadImageUrl!);
                            String res = await register(registerData!.username, registerData!.fullName,
                                registerData!.email, registerData!.password, registerData!.confirmPassword,
                                null, context);
                            if(res == 'SUCCESS'){
                              ref.read(registerDataNotifier.notifier).clearRegisterData();
                              Navigator.pushReplacementNamed(context, '/');
                            }
                            // Aksi saat tombol "Lanjutkan" ditekan
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Padding tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                            ),
                            side: BorderSide(
                              color: Colors.white, // Warna garis tepi (outline)
                              width: 2, // Lebar garis tepi
                            ),
                          ),
                          child: Text(
                            'Lewati',
                            style: TextStyle(
                              fontSize: 18, // Ukuran teks
                              color: Colors.white, // Warna teks
                            ),
                          ),
                        )
                        ,
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),

                )

              ],
            ),
            if(isLoading) const Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                ),
              ),
          ],
        )
      )
    );
  }
}