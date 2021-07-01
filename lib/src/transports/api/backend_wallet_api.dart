
import 'package:http/src/client.dart';
import 'package:wallet_sdk/src/models/wallet.dart';
import 'package:wallet_sdk/src/transports/api/backend_api.dart';


class BackendWalletApi extends BackendApi {

  BackendWalletApi(String baseUrl, String jwtToken, Client client) : super(baseUrl, jwtToken, client);
  
  Future<WalletDetails> fetchWallet() async {
    Map<String, dynamic> resp = await get('v2/wallets', auth: true);
    WalletModules walletModules = WalletModules.fromJson(resp['data']['walletModules']);
    String phoneNumber = resp["data"]["phoneNumber"];
    String walletAddress = resp["data"]["walletAddress"];

    return new WalletDetails(walletAddress, phoneNumber, walletModules);
  }
}