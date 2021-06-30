import 'package:http/http.dart';

import 'package:get_it/get_it.dart';
import 'package:wallet_sdk/src/transports/token.dart';
import 'package:web3dart/web3dart.dart';

// final getIt = GetIt.instance;

const String RPC_URL = 'https://rpc.fuse.io';

void setup() {

  GetIt.I.registerSingleton<Web3Client>(new Web3Client(RPC_URL, new Client()));
  GetIt.I.registerSingleton<TokenTransport>(new Web3TokenTransport());
}