import 'package:flutter/material.dart';

const Color _primaryGreen = Color(0xFF0AA06E);
const Color _kLightBgColor = Color(0xFFE8FFF6);

class AvailableBudgetCard extends StatelessWidget {
  final double balance;

  // Receives calculated balance from Dashboard
  const AvailableBudgetCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    // Using the same design container (Radius 15)
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Wallet Icon
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: _kLightBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined, 
              color: _primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Balance Display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Budget',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Edit button removed as requested
        ],
      ),
    );
  }
}