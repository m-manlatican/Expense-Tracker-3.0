import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  // 1. Add the required callback function
  final VoidCallback onSignOut;

  const HeaderTitle({
    super.key,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Get current date dynamically
    final now = DateTime.now();
    
    // Simple list to map month numbers to names
    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    // Format: "Month Year" (e.g., December 2025)
    final String dateDisplay = '${months[now.month - 1]} ${now.year}';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateDisplay, // 🔥 Updated to show dynamic date
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        // 2. Wrap the icon container in an InkWell and attach the function
        InkWell(
          onTap: onSignOut, // <-- Calls the sign-out function
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}