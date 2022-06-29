import 'package:wallet_sdk/src/constants/token_details.dart';
import 'package:wallet_sdk/src/di.dart';

import '../transports/token.dart';
import './token_details.dart';

class Token extends TokenDetails {
  TokenTransport _tokenTransport = getIt<TokenTransport>();

  Token(
    String address,
    String name,
    String symbol,
    int decimals,
  ) : super(
          address,
          name,
          symbol,
          decimals,
        );

  Token.fromTokenDetails(
    TokenDetails tokenDetails,
  ) : super(
          tokenDetails.address,
          tokenDetails.name,
          tokenDetails.symbol,
          tokenDetails.decimals,
        );

  Future<TokenAmount> fetchBalance(
    String accountAddress,
  ) async {
    var value = await _tokenTransport.fetchTokenBalance(
      accountAddress,
      this.address,
    );
    return new TokenAmount.fromToken(
      value,
      this,
    );
  }

  static Future<Token> fetchToken(String tokenAddress) async {
    if (TokenDetails.isNativeToken(
      tokenAddress,
    )) {
      return Token.fromTokenDetails(
        nativeTokenDetails,
      );
    }

    TokenTransport tokenTransport = getIt<TokenTransport>();
    TokenDetails tokenDetails = await tokenTransport.fetchTokenDetails(
      tokenAddress,
    );
    return Token.fromTokenDetails(
      tokenDetails,
    );
  }

  bool isNative() {
    return TokenDetails.isNativeToken(
      this.address,
    );
  }
}

class TokenAmount {
  late final BigInt value;
  late final TokenDetails token;

  TokenAmount.fromToken(dynamic amount, TokenDetails token) {
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
