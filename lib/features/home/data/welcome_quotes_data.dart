import 'dart:math';

const quotes = ['Are You Sonic?', 'Need For Speed', 'I Am Fast', 'I am kid flash'];

String getRandomQuote(){
  var random = Random();
  int quoteLen = quotes.length;
  int randomNumber = random.nextInt(quoteLen);
  return quotes[randomNumber];

}

