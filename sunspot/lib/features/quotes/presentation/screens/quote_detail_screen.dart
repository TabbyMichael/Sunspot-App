import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/features/quotes/bloc/quotes_bloc.dart';
import 'package:sunspot/features/quotes/bloc/quotes_event.dart';
import 'package:sunspot/features/quotes/bloc/quotes_state.dart';

class QuoteDetailScreen extends StatefulWidget {
  final String quoteId;

  const QuoteDetailScreen({super.key, required this.quoteId});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuotesBloc>().add(FetchQuoteDetails(widget.quoteId));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Quote Details',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.push('/dashboard/quotes');
        },
      ),
      child: BlocBuilder<QuotesBloc, QuotesState>(
        builder: (context, state) {
          if (state is QuotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuotesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          if (state is QuoteDetailsLoaded) {
            final quote = state.quote;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              quote.customerName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            StatusBadge(status: quote.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Email', quote.customerEmail),
                        const SizedBox(height: 8),
                        _buildInfoRow('Address', quote.address),
                        const SizedBox(height: 8),
                        _buildInfoRow('Created', _formatDate(quote.createdAt)),
                        if (quote.expiresAt != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Expires',
                            _formatDate(quote.expiresAt!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quote Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${quote.currency} ${quote.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (quote.notes != null && quote.notes!.isNotEmpty) ...[
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppCard(
                      child: Text(
                        quote.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
