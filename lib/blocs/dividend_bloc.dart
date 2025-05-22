import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/dividend_record.dart';
import '../repositories/dividend_repository.dart';

// Events
abstract class DividendEvent extends Equatable {
  const DividendEvent();

  @override
  List<Object> get props => [];
}

class LoadDividends extends DividendEvent {
  final String symbol;

  const LoadDividends(this.symbol);

  @override
  List<Object> get props => [symbol];
}

class LoadDividendsPanphor extends DividendEvent {
  final String symbol;
  final int force;

  const LoadDividendsPanphor(this.symbol, {this.force = 0});

  @override
  List<Object> get props => [symbol, force];
}

class LoadDividendsSummary extends DividendEvent {
  final String? year;

  const LoadDividendsSummary({this.year});

  @override
  List<Object> get props => [year ?? ''];
}

class LoadUpcomingDividends extends DividendEvent {
  const LoadUpcomingDividends();

  @override
  List<Object> get props => [];
}

// States
abstract class DividendState extends Equatable {
  const DividendState();

  @override
  List<Object> get props => [];
}

class DividendInitial extends DividendState {}

class DividendLoading extends DividendState {}

class DividendLoaded extends DividendState {
  final List<DividendRecord> dividends;

  const DividendLoaded(this.dividends);

  @override
  List<Object> get props => [dividends];
}

class DividendError extends DividendState {
  final String message;

  const DividendError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class DividendBloc extends Bloc<DividendEvent, DividendState> {
  final DividendRepository dividendRepository;

  DividendBloc({required this.dividendRepository}) : super(DividendInitial()) {
    on<LoadDividends>(_onLoadDividends);
    on<LoadDividendsPanphor>(_onLoadDividendsPanphor);
    on<LoadDividendsSummary>(_onLoadDividendsSummary);
    on<LoadUpcomingDividends>(_onLoadUpcomingDividends);
  }

  Future<void> _onLoadDividends(
    LoadDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(DividendLoading());
    try {
      final dividends = await dividendRepository.getDividends(event.symbol);
      emit(DividendLoaded(dividends));
    } catch (e) {
      emit(DividendError(e.toString()));
    }
  }

  Future<void> _onLoadDividendsPanphor(
    LoadDividendsPanphor event,
    Emitter<DividendState> emit,
  ) async {
    emit(DividendLoading());
    try {
      final dividends = await dividendRepository.getDividendsPanphor(
        event.symbol,
        force: event.force,
      );
      emit(DividendLoaded(dividends));
    } catch (e) {
      emit(DividendError(e.toString()));
    }
  }

  Future<void> _onLoadDividendsSummary(
    LoadDividendsSummary event,
    Emitter<DividendState> emit,
  ) async {
    emit(DividendLoading());
    try {
      final summary = await dividendRepository.getDividendsSummary(
        year: event.year,
      );
      // Convert summary to list of DividendRecord
      final List<DividendRecord> dividends = (summary['summary'] as List)
          .map((item) => DividendRecord.fromJson(item['latest_dividend']))
          .toList();
      emit(DividendLoaded(dividends));
    } catch (e) {
      emit(DividendError(e.toString()));
    }
  }

  Future<void> _onLoadUpcomingDividends(
    LoadUpcomingDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(DividendLoading());
    try {
      final dividends = await dividendRepository.getUpcomingDividends();
      emit(DividendLoaded(dividends));
    } catch (e) {
      emit(DividendError(e.toString()));
    }
  }
} 