

import 'package:wallet_sdk/src/models/wallet.dart';

import 'api.dart';

abstract class WalletTransport {
  Future<WalletDetails> fetchWallet(String accountAddress);
}

class ApiWalletTransport extends WalletTransport with ApiTransport {

  WalletTransport() {

  }

  Future<WalletDetails> fetchWallet(String accountAddress) async {
    Map<String, dynamic> resp = await get('v2/wallets', auth: true);
    WalletModules walletModules = WalletModules.fromMap(resp['data']['walletModules']);
    String phoneNumber = resp["data"]["phoneNumber"];
    String walletAddress = resp["data"]["walletAddress"];

    return new WalletDetails(phoneNumber, walletAddress, walletModules);
    
  }
}