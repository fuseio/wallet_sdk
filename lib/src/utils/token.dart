import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../models/token.dart';
import './abi.dart';


const String RPC_URL = 'https://rpc.fuse.io';
const int NETWORK_ID = 122;

final client = new Web3Client(RPC_URL, new Client());

Future<TokenAmount> getTokenBalance(String accountAddress, Token token) async {
  List<dynamic> params = [EthereumAddress.fromHex(accountAddress)];

  var value = (await _readFromContract(
          'BasicToken', token.address, 'balanceOf', params))
      .first;
  return TokenAmount.fromToken(value, token);
}

Future<EtherAmount> getBalance(String accountAddress) async {
  EthereumAddress ethereumAddress = EthereumAddress.fromHex(accountAddress);
  return client.getBalance(ethereumAddress);
}

Future<Token> fetchToken(String tokenAddress) async {
  var map = await getTokenDetails(tokenAddress);
  return new Token(tokenAddress, map['name'], map['symbol'], map['decimals'].toInt());
}


Future<dynamic> getTokenDetails(String tokenAddress) async {
  return {
    "name": (await _readFromContract('BasicToken', tokenAddress, 'name', []))
        .first,
    "symbol":
        (await _readFromContract('BasicToken', tokenAddress, 'symbol', []))
            .first,
    "decimals":
        (await _readFromContract('BasicToken', tokenAddress, 'decimals', []))
            .first
  };
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
  return await client.call(
      contract: contract,
      function: contract.function(functionName),
      params: params);
}


void main() async {
  const address = "0x249BE57637D8B013Ad64785404b24aeBaE9B098B";
  Token t = await fetchToken(address);
  var a = await getTokenBalance("0xD418c5d0c4a3D87a6c555B7aA41f13EF87485Ec6", t);
  var b = await getTokenDetails("0x249BE57637D8B013Ad64785404b24aeBaE9B098B");
  print(await getBalance("0xD418c5d0c4a3D87a6c555B7aA41f13EF87485Ec6"));
}