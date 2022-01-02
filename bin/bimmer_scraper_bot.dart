import 'dart:async';

import 'package:dotenv/dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:web_scraper/web_scraper.dart';

void main(List<String> arguments) async {
  print("bot started...");
  load();
  final searchParams =
      '/inzerce/osobni/bmw?cena-do=500000&km-do=150000&typ=kombi&prevodovka=automaticka&pohon=4x4';
  final tray = [];
  final telegram = Telegram(env['botToken'] as String);
  final event = Event((await telegram.getMe()).username!);
  const period = Duration(minutes: 1);
  final webScraper = WebScraper('https://www.sauto.cz');
  var isInitialRun = true;

  TeleDart(telegram, event).start();

  Timer.periodic(period, (Timer t) async {
    if (await webScraper.loadWebPage(searchParams)) {
      List<Map<String, dynamic>> elements =
          webScraper.getElement('a.sds-surface', ['href']);

      for (dynamic element in elements) {
        final href = element["attributes"]["href"];
        if (!tray.contains(href)) {
          tray.add(href);
          if (!isInitialRun) telegram.sendMessage(env['chatId'], href);
        }
      }
    }
    isInitialRun = false;
  });
}
