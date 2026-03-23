import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileHeader(),
            const SizedBox(height: 16),
            buildSection('Account', [
              buildTile(Icons.account_circle_outlined, 'Personal Details'),
              buildTile(Icons.food_bank, 'Bank Accounts'),
              buildTile(Icons.verified_outlined, 'KYC Status', trailing: buildBadge('Verified', Colors.green)),
              buildTile(Icons.segment_outlined, 'Segments'),
            ]),
            const SizedBox(height: 16),
            buildSection('Settings', [
              buildTile(Icons.notifications_outlined, 'Notifications'),
              buildTile(Icons.fingerprint, 'Biometric Login'),
              buildTile(Icons.lock_outline, 'Change PIN'),
              buildTile(Icons.language_outlined, 'Language'),
            ]),
            const SizedBox(height: 16),
            buildSection('Support', [
              buildTile(Icons.help_outline, 'Help & Support'),
              buildTile(Icons.description_outlined, 'Terms & Conditions'),
              buildTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
            ]),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.shade50,
                  ),
                  child: Text('Logout', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('021Trade v1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: const Text('RA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black54)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rahul Agarwal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('RA1234  |  rahul@email.com', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget buildTile(IconData icon, String label, {Widget? trailing}) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: Icon(icon, size: 20, color: Colors.grey.shade700),
          title: Text(label, style: const TextStyle(fontSize: 14)),
          trailing: trailing ?? Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          onTap: () {},
        ),
        Divider(height: 1, color: Colors.grey.shade100, indent: 52),
      ],
    );
  }

  Widget buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
