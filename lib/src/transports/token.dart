// import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_sdk/src/di.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/abi.dart';
import '../models/token_details.dart';

abstract class TokenTransport {
  Future<BigInt> fetchTokenBalance(String accountAddress, String tokenAddress);
  Future<TokenDetails> fetchTokenDetails(String tokenAddress);
}

@LazySingleton(as: TokenTransport)
class Web3TokenTransport implements TokenTransport {
  Web3Client _client = getIt<Web3Client>();

  @override
  Future<BigInt> fetchTokenBalance(
    String accountAddress,
    String tokenAddress,
  ) async {
    List<dynamic> params = [
      EthereumAddress.fromHex(accountAddress),
    ];
    var value = (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'balanceOf',
      params,
    ))
        .first;
    return value;
  }

  @override
  Future<TokenDetails> fetchTokenDetails(String tokenAddress) async {
    var name = (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'name',
      [],
    ))
        .first;
    var symbol = (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'symbol',
      [],
    ))
        .first;
    var decimals = (await _readFromContract(
      'BasicToken',
      tokenAddress,
      'decimals',
      [],
    ))
        .first;
    return new TokenDetails(
      tokenAddress,
      name,
      symbol,
      decimals.toInt(),
    );
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
    return await _client.call(
      contract: contract,
      function: contract.function(functionName),
      params: params,
    );
  }
}
