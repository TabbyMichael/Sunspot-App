import 'package:equatable/equatable.dart';
import 'package:sunspot/features/quotes/data/models/quote.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object?> get props => [];
}

class QuotesInitial extends QuotesState {}

class QuotesLoading extends QuotesState {}

class QuotesLoaded extends QuotesState {
  final List<Quote> quotes;

  const QuotesLoaded(this.quotes);

  @override
  List<Object?> get props => [quotes];
}

class QuoteDetailsLoaded extends QuotesState {
  final Quote quote;

  const QuoteDetailsLoaded(this.quote);

  @override
  List<Object?> get props => [quote];
}

class QuotesError extends QuotesState {
  final String message;

  const QuotesError(this.message);

  @override
  List<Object?> get props => [message];
}
