import 'package:expense_tracker_3_0/widgets/branding.dart'; 
import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final VoidCallback onSignOut;
  final String userName; // 🔥 NEW PARAMETER

  const HeaderTitle({
    super.key,
    required this.onSignOut,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🔥 Replaced simple branding with Welcome Message
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Small branding line
             const Branding(
              iconSize: 20, 
              fontSize: 14, 
              color: Colors.white70,
              vertical: false
            ),
            const SizedBox(height: 4),
            // Welcome Text
            Text(
              "Welcome, $userName",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const Spacer(),

        // Sign Out Button
        InkWell(
          onTap: onSignOut,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
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