import 'package:wallet_sdk/src/di.dart';
import 'package:web3dart/web3dart.dart';

import '../models/token.dart';
import './abi.dart';

Future<TokenAmount> getTokenBalance(
  String accountAddress,
  Token token,
) async {
  List<dynamic> params = [EthereumAddress.fromHex(accountAddress)];

  var value = (await _readFromContract(
    'BasicToken',
    token.address,
    'balanceOf',
    params,
  ))
      .first;
  return TokenAmount.fromToken(
    value,
    token,
  );
}

Future<EtherAmount> getBalance(String accountAddress) async {
  EthereumAddress ethereumAddress = EthereumAddress.fromHex(accountAddress);
  return getIt<Web3Client>().getBalance(ethereumAddress);
}

Future<Token> fetchToken(String tokenAddress) async {
  var map = await getTokenDetails(tokenAddress);
  return new Token(
    tokenAddress,
    map['name'],
    map['symbol'],
    map['decimals'].toInt(),
  );
}

Future<dynamic> getTokenDetails(String tokenAddress) async {
  return {
    "name": (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'name',
      [],
    ))
        .first,
    "symbol": (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'symbol',
      [],
    ))
        .first,
    "decimals": (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'decimals',
      [],
    ))
        .first
  };
}

Future<DeployedContract> _contract(
  String contractName,
  String contractAddress,
) async {
  String abi = ABI.get(contractName);
  DeployedContract contract = DeployedContract(
    ContractAbi.fromJson(abi, contractName),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}

Future<List<dynamic>> _readFromContract(
  String contractName,
  String contractAddress,
  String functionName,
  List<dynamic> params,
) async {
  DeployedContract contract = await _contract(
    contractName,
    contractAddress,
  );
  return await getIt<Web3Client>().call(
    contract: contract,
    function: contract.function(functionName),
    params: params,
  );
}
