library explorer_api;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_sdk/wallet_sdk.dart';

@injectable
class ExplorerApi {
  Dio dio;

  ExplorerApi(
    this.dio,
    @factoryParam String? base,
    @factoryParam String? apiKey,
  ) {
    if (apiKey != null) {
      dio.options.queryParameters = Map.from({'apiKey': apiKey});
    }
    dio.options.baseUrl = base!;
    dio.options.headers = Map.from({"Content-Type": 'application/json'});
  }

  Future<BigInt> fetchTokenBalance(
    String tokenAddress,
    String accountAddress,
  ) async {
    try {
      Response response = await dio.get(
        '?module=account&action=tokenbalance&contractaddress=$tokenAddress&address=$accountAddress',
      );
      return BigInt.from(num.parse(response.data['result']));
    } catch (e) {
      throw 'Error! Get token balance failed for - accountAddress: $accountAddress --- $e';
    }
  }

  Future<TokenDetails> fetchTokenDetails(String tokenAddress) async {
    try {
      Response response = await dio.get(
        '?module=token&action=getToken&contractaddress=$tokenAddress',
      );
      if (response.data['message'] == 'OK' && response.data['status'] == '1') {
        Map<String, dynamic> json = Map.from({
          ...response.data['result'],
          'tokenAddress': tokenAddress,
          'decimals': int.parse(response.data['result']['decimals'])
        });
        return TokenDetails.fromJson(json);
      }
      throw 'Error! Get token failed $tokenAddress - ${response.data['message']}';
    } catch (e) {
      throw 'Error! Get token failed $tokenAddress - $e';
    }
  }

  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(
      String address) async {
    try {
      Map<TokenDetails, TokenAmount> balances =
          new Map<TokenDetails, TokenAmount>();
      Response response =
          await dio.get('?module=account&action=tokenlist&address=$address');
      if (response.data['message'] == 'OK' && response.data['status'] == '1') {
        for (dynamic json in response.data['result']) {
          TokenDetails token = TokenDetails.fromJson({
            ...json,
            "tokenAddress": json['contractAddress'].toLowerCase(),
            "decimals": int.parse(json['decimals'])
          });
          TokenAmount amount = TokenAmount.fromToken(json['balance'], token);
          balances[token] = amount;
        }
        return balances;
      } else {
        throw 'Error! Get token list failed for - address: $address';
      }
    } catch (e) {
      throw 'Error! Get token list failed for - address: $address --- $e';
    }
  }
}
