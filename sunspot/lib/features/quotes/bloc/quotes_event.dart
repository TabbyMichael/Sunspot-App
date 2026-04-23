import 'package:equatable/equatable.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object?> get props => [];
}

class FetchQuotes extends QuotesEvent {}

class FetchQuoteDetails extends QuotesEvent {
  final String quoteId;

  const FetchQuoteDetails(this.quoteId);

  @override
  List<Object?> get props => [quoteId];
}

class UpdateQuoteStatus extends QuotesEvent {
  final String quoteId;
  final String status;

  const UpdateQuoteStatus(this.quoteId, this.status);

  @override
  List<Object?> get props => [quoteId, status];
}
