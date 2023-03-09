part of 'internet_cubit.dart';

abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}

class InternetDisconnected extends InternetState {}

class InternetConnected extends InternetState {
  const InternetConnected(this.connectionType);

  final ConnectionType connectionType;

  @override
  List<Object> get props => [connectionType];
}
