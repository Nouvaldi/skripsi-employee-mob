import 'package:employee_mobile/models/transaction.dart';
import 'package:employee_mobile/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Transaction History'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ChangeNotifierProvider<TransactionViewModel>(
        create: (_) => TransactionViewModel()..fetchTransactions(),
        child: Consumer<TransactionViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchTransactions();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = viewModel.transactions[index];

                  // if (viewModel.transactions.isEmpty) {
                  //   return Center(
                  //     child: Text(
                  //       'There are no transactions today.',
                  //       style: TextStyle(
                  //         color: Theme.of(context).colorScheme.inversePrimary,
                  //       ),
                  //     ),
                  //   );
                  // }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaction ${transaction.id}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy')
                                  .format(transaction.timestamp),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => _showTransactionDetailDialog(
                            context,
                            transaction,
                          ),
                          icon: Icon(
                            Icons.info_rounded,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTransactionDetailDialog(
    BuildContext context,
    Transaction transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        var idx = 0;
        return AlertDialog(
          title: Text(
            'Transaction ${transaction.id} Details',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: \n${DateFormat('EEEE, d MMMM yyyy').format(transaction.timestamp)}\n\n'
                'Total Price: \n${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(transaction.totalPrice)}\n\n'
                'Items:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              ...transaction.transDetail.map(
                (detail) {
                  idx += 1;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$idx. ${detail.itemName} // Size (${detail.sizeDisplayName})',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        '${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(detail.itemPrice)} x ${detail.itemQuantity} pcs\n',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
