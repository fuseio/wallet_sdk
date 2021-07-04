library explorer_api;

import 'dart:async';

import 'package:http/http.dart';
import 'package:wallet_sdk/wallet_sdk.dart';

import 'api.dart';

class ExplorerApi extends Api {
  final String _base;
  final String _apiKey;
  final Client _client;

  ExplorerApi(this._base, this._apiKey, this._client);

  Future<Map<String, dynamic>> _get(String endpoint) async {
    Response response;
    print('$_base$endpoint');
    print(_client);
    if ([null, ''].contains(_apiKey)) {
      response = await _client.get(Uri.parse('$_base$endpoint'));
    } else {
      response = await _client.get(Uri.parse('$_base$endpoint&apikey=$_apiKey'));
    }
    return responseHandler(response);
  }


  Future<BigInt> fetchTokenBalance(
    String tokenAddress,
    String accountAddress,
  ) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokenbalance&contractaddress=$tokenAddress&address=$accountAddress');
      return BigInt.from(num.parse(resp['result']));
    } catch (e) {
      throw 'Error! Get token balance failed for - accountAddress: $accountAddress --- $e';
    }
  }

  Future<TokenDetails> fetchTokenDetails(String tokenAddress) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=token&action=getToken&contractaddress=$tokenAddress');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        Map<String, dynamic> json = Map.from({
          ...resp['result'],
          'tokenAddress': tokenAddress,
          'decimals': int.parse(resp['result']['decimals'])
        });
        return TokenDetails.fromJson(json);
      }
      throw 'Error! Get token failed $tokenAddress - ${resp['message']}';
    } catch (e) {
      throw 'Error! Get token failed $tokenAddress - $e';
    }
  }

  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(String address) async {
    try {
      Map<TokenDetails, TokenAmount> balances = new Map<TokenDetails, TokenAmount>();
      Map<String, dynamic> resp =
          await _get('?module=account&action=tokenlist&address=$address');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        for (dynamic json in resp['result']) {
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
