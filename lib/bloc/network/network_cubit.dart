import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:task_video_filter/utils/data_connection_checker/data_connection_checker.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit._() : super(NetworkState.initial);
  static late NetworkCubit _instence;

  static Future init() async{
    _instence = NetworkCubit._();
    _instence.initialize();
  }

  static get instence => _instence;

  bool hasConnection = false;
  StreamController connectionChangeController = StreamController();

  Stream get connectionChange => connectionChangeController.stream;

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  void _connectionChange(ConnectivityResult result) {
    hasInternetInternetConnection();
  }

  Future<bool> hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Check if device is just connect with mobile network or wifi
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //Check there is actual internet connection with a mobile network or wifi
      if (await DataConnectionChecker().hasConnection) {
        // Network data detected & internet connection confirmed.
        hasConnection = true;
        emit(NetworkState.gained);
      } else {
        // Network data detected but no internet connection found.
        hasConnection = false;
        emit(NetworkState.lost);
      }
    }
    // device has no mobile network and wifi connection at all
    else {
      hasConnection = false;
      emit(NetworkState.lost);
    }
    // The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }

  @override
  Future<void> close() {
    // _streamSubscription?.cancel();
    // connectionChangeController?.close();
    return super.close();
  }
}
