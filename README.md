# BimmerBot

This bot periodicaly (every minute) web scrapes car listings under specified query and sends telegram message with new listing link

## Features

- Web scrape sauto.cz web
- Update search query params (manufacturer, model, year, price, specs...)
- Send message to specific chat ID
- Change query period

## Run

You can run this project in terminal by running:
```sh
cd bimmer-scraper-bot
dart run
```

## Compile

You can also compile binary with following commands
#### Executable
```sh
dart compile exe bin/bimmer_scraper_bot.dart 
```

#### AOT

```sh
dart compile aot-snapshot bin/bimmer_scraper_bot.dart 
```
then run
```sh
dartaotruntime bin/bimmer_scraper_bot.aot 
```
#### More
for more compile options check https://dart.dev/tools/dart-compile
