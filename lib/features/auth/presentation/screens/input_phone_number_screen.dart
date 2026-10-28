import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/providers/selected_country_provider.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/button/chateo_button.dart';
import 'package:chateo/features/auth/presentation/providers/phone_auth_provider.dart';
import 'package:chateo/features/auth/presentation/widgets/chateo_registration_phone_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InputPhoneNumberScreen extends ConsumerStatefulWidget {
  const InputPhoneNumberScreen({super.key});

  @override
  ConsumerState<InputPhoneNumberScreen> createState() =>
      _InputPhoneNumberScreenState();
}

class _InputPhoneNumberScreenState
    extends ConsumerState<InputPhoneNumberScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen(phoneAuthProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error!)));
      }
      if (prev?.status != PhoneAuthStatus.codeSent &&
          next.status == PhoneAuthStatus.codeSent) {
        context.pushNamed(RouteNames.verificationCodeInput);
      }
    });

    final country = ref.watch(selectedCountryProvider);
    final auth = ref.watch(phoneAuthProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          iconSize: 24,
          icon: SvgPicture.asset(
            'assets/icons/chevron_left.svg',
            colorFilter: ColorFilter.mode(
              theme.colorScheme.inverseSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    40.heightBox,
                    Text(
                      'Enter Your Phone Number',
                      style: AppTextStyles.heading2,
                    ),
                    8.heightBox,
                    Text(
                      textAlign: TextAlign.center,
                      'Please confirm your country code and enter\nyour phone number',
                      style: AppTextStyles.bodyTextMedium,
                    ),
                    48.heightBox,
                    ChateoRegistrationPhonePicker(
                      country: country,
                      controller: _phone,
                      onCountryTap: () async {
                        final picked = await showCountryPicker(
                          context,
                          country,
                        );
                        if (!mounted || picked == null) {
                          return;
                        }
                        ref
                            .read(selectedCountryProvider.notifier)
                            .select(picked);
                      },
                    ),
                    const Spacer(),
                    ChateoButton(
                      text: 'Continue',
                      isLoading: auth.isLoading,
                      onPressed: auth.isLoading
                          ? null
                          : () => ref
                                .read(phoneAuthProvider.notifier)
                                .sendCode(country, _phone.text),
                    ),
                    20.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
