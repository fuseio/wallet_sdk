

import 'package:get_it/get_it.dart';
import 'package:wallet_sdk/src/models/token.dart';
import 'package:wallet_sdk/src/models/token_details.dart';
import 'package:wallet_sdk/src/models/wallet.dart';
import 'package:wallet_sdk/src/transports/api/backend_wallet_api.dart';
import 'package:wallet_sdk/src/transports/api/explorer_api.dart';

abstract class WalletTransport {
  Future<WalletDetails> fetchWallet();
  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(String walletAddress);
}

class ApiWalletTransport extends WalletTransport {
  BackendWalletApi _backendApi = GetIt.I.get<BackendWalletApi>();
  ExplorerApi _explorerApi = GetIt.I.get<ExplorerApi>();

  @override
  Future<WalletDetails> fetchWallet() async {
    return _backendApi.fetchWallet();
  }

  @override
  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(String walletAddress) {
    return _explorerApi.fetchTokenBalances(walletAddress);
  }
}