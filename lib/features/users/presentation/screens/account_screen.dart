import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/features/users/data/repositories/account_repository.dart';
import 'package:chateo/features/users/presentation/providers/current_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _busy = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              action,
              style: destructive ? const TextStyle(color: AppColors.danger) : null,
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _logout() async {
    final ok = await _confirm(
      title: 'Log out?',
      body: 'You can log back in any time with your phone number.',
      action: 'Log out',
    );
    if (!ok) return;

    setState(() => _busy = true);
    try {
      await ref.read(accountRepositoryProvider).signOut();
    } catch (e) {
      _snack('Couldn’t log out: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await _confirm(
      title: 'Delete account?',
      body: 'This permanently deletes your profile. We’ll text a code to '
          'your number to confirm it’s you.',
      action: 'Continue',
      destructive: true,
    );
    if (!ok) return;

    final repo = ref.read(accountRepositoryProvider);
    setState(() => _busy = true);
    try {
      final verificationId = await repo.sendReauthCode();

      String? code;
      if (verificationId != AccountRepository.alreadyVerified) {
        if (!mounted) return;
        setState(() => _busy = false);
        code = await showDialog<String>(
          context: context,
          builder: (_) => const _CodeDialog(),
        );
        if (code == null) return; 
        if (!mounted) return;
        setState(() => _busy = true);
      }

      await repo.deleteAccount(verificationId: verificationId, smsCode: code);
      
    } on FirebaseAuthException catch (e) {
      _snack(e.code == 'invalid-verification-code'
          ? 'That code is wrong. Try again.'
          : (e.message ?? e.code));
    } catch (e) {
      _snack('Couldn’t delete account: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(currentUserProvider).value;
    final phone = ref.watch(firebaseAuthProvider).currentUser?.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Account'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/icons/chevron_left.svg',
            colorFilter: ColorFilter.mode(
              theme.colorScheme.inverseSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
        bottom: _busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ChateoAvatar(
                  radius: 24,
                  imageBytes: profile?.imageBytes,
                  initials: profile?.initials,
                ),
                title: Text(profile?.fullName ?? ''),
                subtitle: Text(phone ?? ''),
              ),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                enabled: !_busy,
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: _logout,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                enabled: !_busy,
                leading: const Icon(Icons.delete_outline, color: AppColors.danger),
                title: const Text(
                  'Delete account',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: _deleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _CodeDialog extends StatefulWidget {
  const _CodeDialog();

  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter the code'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: const InputDecoration(counterText: '', hintText: '6-digit code'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text(
            'Delete account',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ],
    );
  }
}