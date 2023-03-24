import 'dart:convert';
import 'dart:io';
import 'package:attendanceapp/face_recognition/attendenceServices.dart';
import 'package:attendanceapp/model/Attendence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attendanceapp/model/user.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class AttendenceService extends ChangeNotifier {
  List<Attendence> attendence = [];
  final String _rpcUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:8545';
  final String _wsUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:8545';
  bool isLoading = true;

  final String _privatekey =
      'e9f6ad7637445a1fe6ba373921d3d11d741baddddfc0a68f2567fe8206fa0b88';
  late Web3Client _web3cient;

  AttendenceService() {
    init();
  }

  Future<void> init() async {
    _web3cient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
    await rootBundle.loadString('build/contracts/NotesContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'AttendenceContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createAttendence');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('attendenceCounter');
    await fetchAttendence();
  }

  Future<void> fetchAttendence() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    attendence.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3cient.call(
          contract: _deployedContract,
          function: _notes,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        attendence.add(
          Attendence(
            id: (temp[0] as BigInt).toInt(),
            name: temp[1],
            checkIn: temp[2],
            checkInLocation: temp[3],
            date: temp[4]
          ),
        );
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addAttendence(String name, String checkIn, String checkInLocation, String date) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [name, checkIn, checkInLocation, date],
      ),
    );
    isLoading = true;
    fetchAttendence();
  }

  Future<void> deleteAttendence(int id) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
    );
    isLoading = true;
    notifyListeners();
    fetchAttendence();
  }
}