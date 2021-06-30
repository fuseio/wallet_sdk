

import 'package:wallet_sdk/src/transports/wallet.dart';

class WalletModules {
  final String transferManager;
  final String communityManager;

  WalletModules(this.transferManager, this.communityManager);

  factory WalletModules.fromMap(Map<String, dynamic> walletModules) => new WalletModules(walletModules['TransferManager'], walletModules['CommunityManager']); 
}


class WalletDetails {
  final String walletAddress;
  final String phoneNumnber;
  final WalletModules walletModules;

  WalletDetails(this.walletAddress, this.phoneNumnber, this.walletModules);
}

class Wallet extends WalletDetails {
  static WalletTransport _walletTransport = new ApiWalletTransport();
  Wallet(String walletAddress, String phoneNumnber, WalletModules walletModules) : super(walletAddress, phoneNumnber, walletModules);

  static Future<Wallet> fetchWallet(String walletAddress) async {
    WalletDetails walletDetails = await _walletTransport.fetchWallet(walletAddress);
    return Wallet.fromWalletDetails(walletDetails);
  }

  factory Wallet.fromWalletDetails(WalletDetails walletDetails) => new Wallet(walletDetails.walletAddress, walletDetails.phoneNumnber, walletDetails.walletModules);

}