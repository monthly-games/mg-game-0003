import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';


class GuildScreen extends StatefulWidget {
  const GuildScreen({super.key});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen> {
  bool checkedIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Mercenary Guild',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),

          // Check-in
          Card(
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Daily Attendance',
                    style: TextStyle(color: MGColors.textHighEmphasis, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get free gold every day!',
                    style: TextStyle(color: MGColors.common),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkedIn ? null : _handleCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGColors.info,
                    ),
                    child: Text(checkedIn ? 'Checked In' : 'Check In (+500G)'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Raid Boss (Placeholder)
          Card(
            color: Colors.red[900]!.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Guild Raid',
                    style: TextStyle(
                      color: MGColors.textHighEmphasis,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.warning, color: MGColors.error, size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'Coming Soon in v1.1',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckIn() {
    setState(() {
      checkedIn = true;
    });
    GetIt.I<GoldManager>().addGold(500);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Received 500 gold!')));
  }
}
