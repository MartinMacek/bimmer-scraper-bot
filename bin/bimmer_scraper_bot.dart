import 'dart:async';

import 'package:dotenv/dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:web_scraper/web_scraper.dart';

void main(List<String> arguments) async {
  print("bot started...");
  load();
  final searchQueries = [
    '/inzerce/osobni/bmw?cena-do=500000&km-do=150000&typ=kombi&prevodovka=automaticka&pohon=4x4',
    '/inzerce/osobni/bmw/rada-4?cena-do=500000&km-do=150000&prevodovka=automaticka&pohon=4x4',
  ];
  List<Map<String, dynamic>> results = [];

  final tray = [];
  final telegram = Telegram(env['botToken'] as String);
  final event = Event((await telegram.getMe()).username!);
  const period = Duration(minutes: 1);
  final webScraper = WebScraper('https://www.sauto.cz');
  var isInitialRun = true;

  TeleDart(telegram, event).start();

  Future<void> loadQueries() async {
    for (dynamic query in searchQueries) {
      if (await webScraper.loadWebPage(query)) {
        List<Map<String, dynamic>> elements = webScraper.getElement(
            'div.c-layout__wrapper > div.p-uw-item-list > div.c-layout__content > div > div.p-uw-item-list__list-wrapper > div.c-item-list > ul > li.c-item > div > div > div.c-item__data-wrap > a',
            ['href']);
        results = results + elements;
      }
    }
  }

  Timer.periodic(period, (Timer t) async {
    await loadQueries();
    for (dynamic element in results) {
      final href = element["attributes"]["href"];
      if (!tray.contains(href)) {
        tray.add(href);
        if (!isInitialRun) telegram.sendMessage(env['chatId'], href);
      }
    }

    isInitialRun = false;
  });
}
