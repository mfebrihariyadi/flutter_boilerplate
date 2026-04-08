import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boilerplate/core/services/session_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = Get.find<SessionService>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F8FF), Color(0xFFFFF8F1)],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final user = sessionService.currentUser.value;

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF132238),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user == null
                      ? 'Sesi aktif terdeteksi.'
                      : 'Selamat datang kembali, ${user.firstName} ${user.lastName}'
                            .trim(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF4E5D6C),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 30,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: colorScheme.primaryContainer,
                            backgroundImage:
                                user != null && user.image.isNotEmpty
                                ? NetworkImage(user.image)
                                : null,
                            child: user == null || user.image.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 32,
                                    color: colorScheme.primary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user == null
                                      ? 'Pengguna'
                                      : '${user.firstName} ${user.lastName}'
                                            .trim(),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF132238),
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.username ?? '-',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFF4E5D6C),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _ProfileRow(label: 'Email', value: user?.email ?? '-'),
                      _ProfileRow(label: 'Gender', value: user?.gender ?? '-'),
                      _ProfileRow(
                        label: 'Status',
                        value: sessionService.hasStoredSession()
                            ? 'Login tersimpan'
                            : 'Tidak ada sesi',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: sessionService.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF132238),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6E7B88),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF132238),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
