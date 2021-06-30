import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../utils/abi.dart';
import '../models/token_details.dart';

const String RPC_URL = 'https://rpc.fuse.io';
const int NETWORK_ID = 122;

abstract class TokenTransport {
  Future<BigInt> fetchTokenBalance(String accountAddress, String tokenAddress);
  Future<TokenDetails> fetchTokenDetails(String tokenAddress);
}


class Web3TokenTransport extends TokenTransport {
  Web3Client _client = new Web3Client(RPC_URL, new Client());

  @override
  Future<BigInt> fetchTokenBalance(String accountAddress, String tokenAddress) async {
    List<dynamic> params = [EthereumAddress.fromHex(accountAddress)];
    var value = (await _readFromContract(
            'BasicToken', tokenAddress, 'balanceOf', params))
        .first;
    return value;
  }

  @override
  Future<TokenDetails> fetchTokenDetails(String tokenAddress) async {
    var name = (await _readFromContract('BasicToken', tokenAddress, 'name', [])).first;
    var symbol = (await _readFromContract('BasicToken', tokenAddress, 'symbol', [])).first;
    var decimals = (await _readFromContract('BasicToken', tokenAddress, 'decimals', [])).first;
    return new TokenDetails(tokenAddress, name, symbol, decimals.toInt());
  }

    Future<DeployedContract> _contract(
      String contractName, String contractAddress) async {
    String abi = ABI.get(contractName);
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> _readFromContract(String contractName,
      String contractAddress, String functionName, List<dynamic> params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    return await _client.call(
        contract: contract,
        function: contract.function(functionName),
        params: params);
  }

}