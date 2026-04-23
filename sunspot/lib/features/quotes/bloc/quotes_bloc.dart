import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/features/quotes/bloc/quotes_event.dart';
import 'package:sunspot/features/quotes/bloc/quotes_state.dart';
import 'package:sunspot/features/quotes/data/quotes_repository.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  final QuotesRepository _repository;

  QuotesBloc(this._repository) : super(QuotesInitial()) {
    on<FetchQuotes>(_onFetchQuotes);
    on<FetchQuoteDetails>(_onFetchQuoteDetails);
    on<UpdateQuoteStatus>(_onUpdateQuoteStatus);
  }

  Future<void> _onFetchQuotes(
    FetchQuotes event,
    Emitter<QuotesState> emit,
  ) async {
    emit(QuotesLoading());
    try {
      final quotes = await _repository.fetchQuotes();
      emit(QuotesLoaded(quotes));
    } catch (e) {
      emit(QuotesError(e.toString()));
    }
  }

  Future<void> _onFetchQuoteDetails(
    FetchQuoteDetails event,
    Emitter<QuotesState> emit,
  ) async {
    emit(QuotesLoading());
    try {
      final quote = await _repository.getQuoteById(event.quoteId);
      emit(QuoteDetailsLoaded(quote));
    } catch (e) {
      emit(QuotesError(e.toString()));
    }
  }

  Future<void> _onUpdateQuoteStatus(
    UpdateQuoteStatus event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      await _repository.updateQuoteStatus(event.quoteId, event.status);
      add(FetchQuotes());
    } catch (e) {
      emit(QuotesError(e.toString()));
    }
  }
}
