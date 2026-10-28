import 'dart:typed_data';

import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/core/widgets/button/chateo_button.dart';
import 'package:chateo/core/widgets/input/chateo_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:chateo/features/users/presentation/providers/profile_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRegistrationScreen extends ConsumerStatefulWidget {
  const ProfileRegistrationScreen({super.key});

  @override
  ConsumerState<ProfileRegistrationScreen> createState() =>
      _ProfileRegistrationScreenState();
}

class _ProfileRegistrationScreenState
    extends ConsumerState<ProfileRegistrationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Uint8List? _imageBytes;
  String _initials = '';

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateInitials);
    _lastNameController.addListener(_updateInitials);
  }

  void _updateInitials() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    setState(() {
      if (first.isEmpty) {
        _initials = '';
      } else {
        _initials = '${first[0]}${last.isNotEmpty ? last[0] : ''}';
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 85,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    if (!mounted) return;
    setState(() => _imageBytes = bytes);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(profileRegistrationProvider);

    ref.listen(profileRegistrationProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Your Profile', style: AppTextStyles.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              40.heightBox,
              Center(
                child: ChateoAvatar(
                  radius: 50,
                  initials: _initials,
                  imageBytes: _imageBytes,
                  onTap: _pickImage,
                ),
              ),
              31.heightBox,
              ChateoTextField(
                controller: _firstNameController,
                hintText: 'First Name (Required)',
              ),
              12.heightBox,
              ChateoTextField(
                controller: _lastNameController,
                hintText: 'Last Name (Optional)',
              ),
              const Spacer(),
              ChateoButton(
                text: registrationState.isLoading ? 'Saving...' : 'Save',
                onPressed: registrationState.isLoading
                    ? null
                    : () async {
                        if (_firstNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('First Name is required'),
                            ),
                          );
                          return;
                        }

                        final success = await ref
                            .read(profileRegistrationProvider.notifier)
                            .registerUser(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              imageBytes: _imageBytes,
                            );
                        if (success && context.mounted) {
                          context.goNamed(RouteNames.home);
                        }
                      },
              ),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
