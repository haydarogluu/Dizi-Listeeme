import 'package:untitled4/Models/dizi.dart';
import 'package:untitled4/Widget/dizi_listesi/dizi_ogesi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DiziListesi extends StatefulWidget {
  const DiziListesi({
    Key? key,
    required this.diziler,
    required this.diziSil,
    this.kriter = SiralamaKriteri.isim,
    this.artan = true,
  }) : super(key: key);

  final List<Dizi> diziler;
  final SiralamaKriteri kriter;
  final bool artan;
  final void Function(Dizi dizi) diziSil;

  factory DiziListesi.sirala({
    required List<Dizi> diziler,
    required SiralamaKriteri kriter,
    required bool artan,
    required void Function(Dizi dizi) diziSil,
  }) {
    List<Dizi> sortedDiziler = List.from(diziler);
    switch (kriter) {
      case SiralamaKriteri.isim:
        sortedDiziler.sort((a, b) => a.isim.compareTo(b.isim));
        break;
      case SiralamaKriteri.kategori:
        sortedDiziler.sort((a, b) => a.kategori.toString().compareTo(b.kategori.toString()));
        break;
      case SiralamaKriteri.puan:
        sortedDiziler.sort((a, b) => a.puan.compareTo(b.puan));
        break;
      case SiralamaKriteri.tarih:
        sortedDiziler.sort((a, b) => a.izlemeTarihi.compareTo(b.izlemeTarihi));
        break;
      default:
        break;
    }
    if (!artan) {
      sortedDiziler = sortedDiziler.reversed.toList();
    }
    return DiziListesi(
      diziler: sortedDiziler,
      diziSil: diziSil,
      kriter: kriter,
      artan: artan,
    );
  }

  @override
  _DiziListesiState createState() => _DiziListesiState();
}

class _DiziListesiState extends State<DiziListesi> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.diziler.length,
      itemBuilder: (context, index) {
        final dizi = widget.diziler[index];
        return Slidable(
          key: ValueKey(dizi.isim),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    widget.diziSil(dizi);
                  });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Sil',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    dizi.isFavourite = !dizi.isFavourite;
                  });
                },
                backgroundColor: dizi.isFavourite ? Colors.grey : Colors.yellow,
                foregroundColor: Colors.white,
                icon: dizi.isFavourite ? Icons.favorite : Icons.favorite_border,
                label: 'Favorilere Ekle',
              ),
            ],
          ),
          child: DiziOgesi(dizi),
        );
      },
    );
  }
}
