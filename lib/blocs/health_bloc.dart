import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/health_repository.dart';

// Events
abstract class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

class CheckHealth extends HealthEvent {
  const CheckHealth();
}

// States
abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

class HealthInitial extends HealthState {}

class HealthChecking extends HealthState {}

class HealthChecked extends HealthState {
  final Map<String, dynamic> healthData;

  const HealthChecked(this.healthData);

  @override
  List<Object> get props => [healthData];
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final HealthRepository healthRepository;

  HealthBloc({required this.healthRepository}) : super(HealthInitial()) {
    on<CheckHealth>(_onCheckHealth);
  }

  Future<void> _onCheckHealth(
    CheckHealth event,
    Emitter<HealthState> emit,
  ) async {
    emit(HealthChecking());
    try {
      final healthData = await healthRepository.checkHealth();
      emit(HealthChecked(healthData));
    } catch (e) {
      emit(HealthError(e.toString()));
    }
  }
} 