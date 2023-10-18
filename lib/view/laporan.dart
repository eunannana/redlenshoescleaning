import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/controller/datalaporan.dart';
import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';
import 'package:redlenshoescleaning/view/pengeluaran/pengeluaran.dart';
import 'package:redlenshoescleaning/view/treatment/treatment.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}



class _LaporanState extends State<Laporan> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  final List<Widget> _pages = [
    const DataLaporan(),
    const Pendapatan(),
    const Pengeluaran(),
    const Treatment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateSearchQuery(String query){
    setState(() {
      _searchQuery = query;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SafeArea(
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color(0xFFD9D9D9),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_sharp),
                label: 'Pendapatan',
                backgroundColor: Color(0xFFD9D9D9),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_down_sharp),
                label: 'Pengeluaran',
                backgroundColor: Color(0xFFD9D9D9),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_sharp),
                label: 'Treatment',
                backgroundColor: Color(0xFFD9D9D9),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
