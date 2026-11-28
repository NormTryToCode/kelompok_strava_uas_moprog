import 'dart:math';

const quotes = ['Are You Sonic?', 'Need for speed', 'I am fast'];

String getRandomQuote(){
  var random = Random();
  int quoteLen = quotes.length;
  int randomNumber = random.nextInt(quoteLen);
  return quotes[randomNumber];

}

void main(List<String> args) {
  print(getRandomQuote());
}
