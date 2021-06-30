import 'package:wallet_sdk/src/constants/addresses.dart';

class TokenDetails {
  final String address;
  final String name;
  final  String symbol;
  final int decimals;

  TokenDetails(this.address, this.name, this.symbol, this.decimals);


  static bool isNativeToken(String tokenAddress) {
    return tokenAddress == Addresses.ZERO_ADDRESS;
  }
}
