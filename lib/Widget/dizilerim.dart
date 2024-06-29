import 'package:untitled4/Models/dizi.dart';
import 'package:untitled4/Widget/grafik.dart';
import 'package:untitled4/Widget/Yeni_dizi.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/Models/dosya_islemi.dart';
import 'package:untitled4/Widget/dizi_listesi/dizi_listesi.dart';
import 'dart:convert';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class Dizilerim extends StatefulWidget {
  const Dizilerim({super.key});

  @override
  State<Dizilerim> createState() {
    return _DizilerimState();
  }
}

class _DizilerimState extends State<Dizilerim> {
  List<Dizi> _diziler = [];

  final DosyaIslemi _dosyaIslemi = const DosyaIslemi();

  SiralamaKriteri _siralamaKriteri = SiralamaKriteri.isim;
  bool _artan = true;
  IconData _icon = Icons.arrow_downward;

  int kategoriDegeri(Kategori kategori) {
    return _diziler.where((element) => element.kategori == kategori).length;
  }

  double get maxKategori {
    double max = 0;
    for (Kategori kategori in Kategori.values) {
      double k = kategoriDegeri(kategori).toDouble();
      if (k > max) max = k;
    }
    return max;
  }

  List<VBarChartModel> get grafikVerisi {
    List<VBarChartModel> grafikModel = [];
    int idx = 0;
    for (Kategori kategori in Kategori.values) {
      grafikModel.add(VBarChartModel(
        index: idx,
        label: '${kategori.name.toUpperCase()} (${kategoriDegeri(kategori)})',
        colors: [Colors.deepOrange, Colors.blueAccent],
        jumlah: kategoriDegeri(kategori).toDouble(),
      ));
      idx++;
    }
    return grafikModel;
  }

  void _modalGoster() {
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: double.infinity),
        isScrollControlled: true,
        builder: (context) => YeniDizi(diziEkle: _diziEkle),
        useSafeArea: true);
  }

  void _diziEkle(Dizi dizi) {
    setState(() {
      _diziler.add(dizi);
    });
    _dosyaIslemi.dizileriYaz(jsonEncode(_diziler));
  }

  void _diziSil(Dizi dizi) {
    final index = _diziler.indexOf(dizi);
    setState(() {
      _diziler.remove(dizi);
    });
    _dosyaIslemi.dizileriYaz(jsonEncode(_diziler));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 60),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Row(children: [
            Text('${dizi.isim} silindi.'),
            const Spacer(),
            TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Text(
                  'Kapat',
                  style: TextStyle(color: Colors.white),
                )),
          ]),
          action: SnackBarAction(
              label: 'Geri Al',
              textColor: Colors.limeAccent,
              onPressed: () {
                setState(() {
                  _diziler.insert(index, dizi);
                });
                _dosyaIslemi.dizileriYaz(jsonEncode(_diziler));
              })),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      _dosyaIslemi.dizileriOku().then((value) => setState(() {
        _diziler = value;
      }))
    ]);
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dizilerim'),
        actions: [
          const Icon(Icons.sort),
          DropdownButton(
              value: _siralamaKriteri,
              dropdownColor: Theme.of(context).colorScheme.onBackground,
              items: SiralamaKriteri.values
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.name.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _siralamaKriteri = value);
              }),
          IconButton(
              onPressed: () {
                setState(() {
                  _artan = !_artan;
                  if (_artan) {
                    _icon = Icons.arrow_downward;
                  } else {
                    _icon = Icons.arrow_upward;
                  }
                });
              },
              icon: Icon(_icon)),
          IconButton(onPressed: _modalGoster, icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 640
          ? Column(
        children: [
          _diziler.isEmpty
              ? const SizedBox(
            height: 0.1,
          )
              : Grafik(
            grafikVerisi: grafikVerisi,
            maxKategori: maxKategori,
          ),
          Expanded(
              child: DiziListesi.sirala(
                diziler: _diziler,
                kriter: _siralamaKriteri,
                artan: _artan,
                diziSil: _diziSil,
              )),
        ],
      )
          : Row(
        children: [
          _diziler.isEmpty
              ? const SizedBox(
            height: 0.1,
          )
              : Expanded(
            child: Grafik(
              grafikVerisi: grafikVerisi,
              maxKategori: maxKategori,
            ),
          ),
          Expanded(
              child: DiziListesi.sirala(
                diziler: _diziler,
                kriter: _siralamaKriteri,
                artan: _artan,
                diziSil: _diziSil,
              )),
        ],
      ),
    );
  }
}
