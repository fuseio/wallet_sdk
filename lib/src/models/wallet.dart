

import 'package:get_it/get_it.dart';
import 'package:wallet_sdk/src/models/token.dart';
import 'package:wallet_sdk/src/models/token_details.dart';
import 'package:wallet_sdk/src/transports/wallet.dart';

class WalletModules {
  final String transferManager;
  final String communityManager;

  WalletModules(this.transferManager, this.communityManager);

  factory WalletModules.fromJson(Map<String, dynamic> walletModules) => new WalletModules(walletModules['TransferManager'], walletModules['CommunityManager']); 
}


class WalletDetails {
  final String walletAddress;
  final String phoneNumnber;
  final WalletModules walletModules;
  Map<TokenDetails, TokenAmount> balances = new Map<TokenDetails, TokenAmount>();

  WalletDetails(this.walletAddress, this.phoneNumnber, this.walletModules);
}

class Wallet extends WalletDetails {
  static WalletTransport _walletTransport =  GetIt.I.get<WalletTransport>();
  Wallet(String walletAddress, String phoneNumnber, WalletModules walletModules) : super(walletAddress, phoneNumnber, walletModules);

  static Future<Wallet> fetchWallet(String walletAddress) async {
    WalletDetails walletDetails = await _walletTransport.fetchWallet();
    return Wallet.fromWalletDetails(walletDetails);
  }


  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances() async {
    balances = await _walletTransport.fetchTokenBalances(this.walletAddress);
    return balances;
  }

  factory Wallet.fromWalletDetails(WalletDetails walletDetails) => new Wallet(walletDetails.walletAddress, walletDetails.phoneNumnber, walletDetails.walletModules);

}