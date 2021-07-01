import 'package:http/http.dart';

import 'package:get_it/get_it.dart';
import 'package:wallet_sdk/src/transports/api/backend_wallet_api.dart';
import 'package:wallet_sdk/src/transports/api/explorer_api.dart';
import 'package:wallet_sdk/src/transports/token.dart';
import 'package:wallet_sdk/src/transports/wallet.dart';
import 'package:web3dart/web3dart.dart';

// final getIt = GetIt.instance;

const String RPC_URL = 'https://rpc.fuse.io';
const String API_BASE_URL = 'https://studio.fuse.io/api';
const String EXPLORER_URL = 'https://explorer.fuse.io/api';

var createClientDefault = () => new Client();

void setup({ rpc = RPC_URL, apiUrl = API_BASE_URL, jwtToken = '', createClient = null }) {
  createClient = createClient != null ? createClient : createClientDefault;
  GetIt.I.registerSingleton<BackendWalletApi>(new BackendWalletApi(apiUrl, jwtToken, createClient()));
  GetIt.I.registerSingleton<ExplorerApi>(new ExplorerApi(EXPLORER_URL, '', createClient()));
  GetIt.I.registerSingleton<Web3Client>(new Web3Client(RPC_URL, createClient()));
  GetIt.I.registerSingleton<TokenTransport>(new Web3TokenTransport());
  GetIt.I.registerSingleton<WalletTransport>(new ApiWalletTransport());
}