import 'package:web_scraper/web_scraper.dart';

void main(List<String> arguments) async {
  final webScraper = WebScraper('https://webscraper.io');
  if (await webScraper.loadWebPage('/test-sites/e-commerce/allinone')) {
    List<Map<String, dynamic>> elements =
        webScraper.getElement('h3.title > a.caption', ['href']);
    print(elements);
  }
}
