
import 'package:test/test.dart';
import 'package:wallet_sdk/src/constants/addresses.dart';
import 'package:wallet_sdk/src/models/token.dart';

const FUSD_TOKEN_ADDRESS = '0x249BE57637D8B013Ad64785404b24aeBaE9B098B';
const WALLET_ADDRESS = '0xD8E4e3cAa4929487cca3622952e4CF6c37d983ce';

void main() {
  test('fetch token', () async {
    Token token = await Token.fetchToken(FUSD_TOKEN_ADDRESS);
    expect(token.address, FUSD_TOKEN_ADDRESS);
    expect(token.name, 'Fuse Dollar');
    expect(token.symbol, 'fUSD');
    expect(token.decimals, 18);
  });

  test('fetch native token', () async {
    Token token = await Token.fetchToken(Addresses.ZERO_ADDRESS);
    expect(token.address, Addresses.ZERO_ADDRESS);
    expect(token.name, 'Fuse');
    expect(token.symbol, 'FUSE');
    expect(token.decimals, 18);
  });

  test('fetch balance', () async {
    Token token = await Token.fetchToken(FUSD_TOKEN_ADDRESS);
    TokenAmount tokenAmount = await token.fetchBalance(WALLET_ADDRESS);
    expect(tokenAmount.getAmount(), 0.1);
  });
}
