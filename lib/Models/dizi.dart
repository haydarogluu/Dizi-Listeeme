import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

const uuid = Uuid();
final bicimlendirici = DateFormat.yMd(Platform.localeName);

enum Kategori { bilimKurgu, dram, korku, macera, polisiye }

enum SiralamaKriteri { isim, puan, tarih, kategori }

const ikonlar = {
  Kategori.bilimKurgu: Icons.rocket_launch,
  Kategori.dram: Icons.theater_comedy,
  Kategori.korku: Icons.bug_report,
  Kategori.macera: Icons.directions_run,
  Kategori.polisiye: Icons.local_police,
};

class Dizi {
  Dizi({
    required this.isim,
    this.not = '',
    required this.puan,
    required this.izlemeTarihi,
    required this.kategori,
    this.isFavourite = false,
  }) : id = uuid.v4();

  Dizi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isim = json['isim'];
    not = json['not'];
    puan = json['puan'];
    izlemeTarihi = DateTime.parse(json['izlemeTarihi']);
    kategori = Kategori.values
        .firstWhere((element) => element.name == json['kategori']);
    isFavourite = json['isFavourite'] ?? false;
  }

  late String id, isim, not;
  late double puan;
  late DateTime izlemeTarihi;
  late Kategori kategori;
  late bool isFavourite;

  String get bicimliTarih {
    initializeDateFormatting(Platform.localeName);
    return bicimlendirici.format(izlemeTarihi);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'isim': isim,
    'not': not,
    'puan': puan,
    'izlemeTarihi': izlemeTarihi.toString(),
    'kategori': kategori.name,
    'isFavourite': isFavourite,
  };


}