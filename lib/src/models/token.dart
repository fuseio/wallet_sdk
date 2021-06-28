
class Token {
  final String address;
  final String name;
  final  String symbol;
  final int decimals;

  Token(this.address, this.name, this.symbol, this.decimals);
}

class TokenAmount {
  
  BigInt value;
  Token token;

  TokenAmount.fromToken(dynamic amount, Token token) {
    BigInt parsedAmount;
    if (amount is BigInt) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = BigInt.from(amount);
    } else if (amount is String) {
      parsedAmount = BigInt.parse(amount);
    } else {
      throw ArgumentError('Invalid type, must be BigInt, string or int');
    }

    this.value = parsedAmount;
    this.token = token;
  }

  num getAmount() {
    return value / new BigInt.from(10).pow(token.decimals);
  }

  @override
  String toString() {
    return getAmount().toString();
  }



}