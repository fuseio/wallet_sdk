import 'package:injectable/injectable.dart';
import 'package:wallet_sdk/src/di.dart';
import 'package:wallet_sdk/src/models/token.dart';
import 'package:wallet_sdk/src/models/token_details.dart';
import 'package:wallet_sdk/src/models/wallet.dart';
import 'package:wallet_sdk/src/transports/api/backend_wallet_api.dart';
import 'package:wallet_sdk/src/transports/api/explorer_api.dart';

abstract class WalletTransport {
  Future<WalletDetails> fetchWallet();
  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(
    String walletAddress,
  );
}

@Injectable(as: WalletTransport)
class ApiWalletTransport implements WalletTransport {
  BackendWalletApi _backendApi = getIt<BackendWalletApi>(
    param1: 'https://studio.fuse.io/api',
  );
  ExplorerApi _explorerApi = getIt<ExplorerApi>(
    param1: 'https://explorer.fuse.io/api',
  );

  @override
  Future<WalletDetails> fetchWallet() async {
    return _backendApi.fetchWallet();
  }

  @override
  Future<Map<TokenDetails, TokenAmount>> fetchTokenBalances(
    String walletAddress,
  ) {
    return _explorerApi.fetchTokenBalances(walletAddress);
  }
}
