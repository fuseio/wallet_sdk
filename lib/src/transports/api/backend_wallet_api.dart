import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_sdk/src/models/wallet.dart';
import 'package:wallet_sdk/src/transports/api/backend_api.dart';

@injectable
class BackendWalletApi extends BackendApi {
  BackendWalletApi(
    Dio dio,
    @factoryParam String? baseUrl,
  ) : super(
          dio,
          baseUrl!,
        );

  Future<WalletDetails> fetchWallet() async {
    Map<String, dynamic> resp = await get(
      'v2/wallets',
      auth: true,
    );
    WalletModules walletModules = WalletModules.fromJson(
      resp['data']['walletModules'],
    );
    String phoneNumber = resp["data"]["phoneNumber"];
    String walletAddress = resp["data"]["walletAddress"];

    return new WalletDetails(
      walletAddress,
      phoneNumber,
      walletModules,
    );
  }
}
