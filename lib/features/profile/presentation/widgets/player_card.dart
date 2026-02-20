import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/user_model.dart';

class PlayerCard extends StatelessWidget {
  final UserModel user;

  const PlayerCard({super.key, required this.user});

  bool get _isOwner => user.role == 'owner';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isOwner
              ? [const Color(0xFF1A237E), const Color(0xFF283593)]
              : [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isOwner ? const Color(0xFF283593) : AppColors.primaryLight)
                .withAlpha(60),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withAlpha(50),
            child: Icon(
              _isOwner ? Icons.stadium : Icons.person,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isOwner ? 'Pitch Owner' : (user.position ?? 'Player'),
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180)),
          ),
          const SizedBox(height: 16),
          if (_isOwner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withAlpha(100), width: 2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Verified Owner',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _levelColor(user.level).withAlpha(60),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _levelColor(user.level), width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_levelIcon(user.level),
                      color: _levelColor(user.level), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    user.level,
                    style: TextStyle(
                      color: _levelColor(user.level),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'Gold':
        return AppColors.gold;
      case 'Silver':
        return AppColors.silver;
      default:
        return AppColors.bronze;
    }
  }

  IconData _levelIcon(String level) {
    switch (level) {
      case 'Gold':
        return Icons.workspace_premium;
      case 'Silver':
        return Icons.military_tech;
      default:
        return Icons.shield;
    }
  }
}
