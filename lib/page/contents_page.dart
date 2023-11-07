import 'package:booking_app/page/your_products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/provider/auth_provider.dart';

class AppPage extends ConsumerStatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  int _selectedIndex = 0; // Variabel untuk melacak indeks yang terpilih
  PageController _pageController = PageController(); // Deklarasi PageController

  @override
  void dispose() {
    _pageController.dispose(); // Pastikan untuk membebaskan sumber daya PageController saat widget di-dispose.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final auth = ref.watch(authNotifierProvider);
      if (auth.status == AuthStatus.unauthenticated) {
        print('kamu logout');
        // Jika belum terotentikasi, arahkan ke halaman login
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat halaman berubah
          });
        },
        children: <Widget>[
          Center(
            child: Text('Belum Dibuat'),
          ),
          Center(
            child: Text('Belum dibuat 2'),
          ),
          Center(
            child: Text('belum dibuat 3'),
          ),
          Center(
            child: Text('belum dibuat 4'),
          ),
          MyProductPage()
          // Tambahkan halaman lain sesuai kebutuhan
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Gunakan selectedIndex di sini
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat ikon di bottom navigation bar dipilih
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: _selectedIndex == 1 ? Colors.blue : Colors.grey,),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _selectedIndex == 2 ? Colors.blue : Colors.grey,),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _selectedIndex == 3 ? Colors.blue : Colors.grey,),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _selectedIndex == 4 ? Colors.blue : Colors.grey,),
            label: 'My Store',
          ),
        ],
        selectedItemColor: Colors.blue, // Warna teks label untuk item yang aktif
        unselectedItemColor: Colors.grey, // Warna teks label untuk item yang tidak aktif
      ),
    );
  }
}