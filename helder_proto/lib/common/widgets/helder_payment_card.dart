import 'package:flutter/material.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';

class HelderPaymentCard extends StatelessWidget {
  final HelderInvoice helderData;

  const HelderPaymentCard({super.key, required this.helderData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: THelperFunctions.screenHeight() * 0.18,
      width: THelperFunctions.screenWidth() * 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: HelderColors.lightGrey,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: HelderColors.orange,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // '- €${helderData.amount.toStringAsFixed(2)}',
                      helderData.letter.kind.kindName,
                      style: const TextStyle(
                        color: HelderColors.darkGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'betalen aan:',
                      style: TextStyle(
                        color: HelderColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      helderData.letter.sender,
                      style: const TextStyle(
                        color: HelderColors.darkGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: HelderColors.lightGrey,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'betalen voor:',
                      style: TextStyle(
                        color: HelderColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('yyyy-MM-dd').format(helderData.paymentDeadline),
                      style: const TextStyle(
                        color: HelderColors.darkGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'nog ',
                            style: TextStyle(
                              color: HelderColors.darkGrey,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '17 dagen',
                            style: TextStyle(
                              color: HelderColors.darkGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' om te betalen.',
                            style: TextStyle(
                              color: HelderColors.darkGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
