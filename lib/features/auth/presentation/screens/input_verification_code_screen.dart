import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/providers/selected_country_provider.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/button/chateo_button.dart';
import 'package:chateo/features/auth/presentation/providers/phone_auth_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class InputVerificationCodeScreen extends ConsumerStatefulWidget {
  const InputVerificationCodeScreen({super.key});
  @override
  ConsumerState<InputVerificationCodeScreen> createState() =>
      _InputPhoneNumberScreenState();
}

class _InputPhoneNumberScreenState
    extends ConsumerState<InputVerificationCodeScreen> {
  final TextEditingController verificationController = TextEditingController();

  @override
  void dispose() {
    verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(phoneAuthProvider);
    ref.listen<PhoneAuthState>(phoneAuthProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });
    final defaultPinTheme = PinTheme(
      width: 32,
      height: 40,

      textStyle: AppTextStyles.heading1,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,

        borderRadius: BorderRadius.circular(24),
      ),
    );
    void verifyCode(String code) {
      if (code.length == 6) {
        ref.read(phoneAuthProvider.notifier).verifyCode(code);
      }
    }

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    40.heightBox,
                    Text('Enter Code', style: AppTextStyles.heading2),
                    8.heightBox,
                    Text(
                      textAlign: TextAlign.center,
                      ' We have sent you an SMS with the code\nto ${authState.phoneNumber}',
                      style: AppTextStyles.bodyTextMedium,
                    ),
                    48.heightBox,
                    Center(
                      child: Pinput(
                        separatorBuilder: (index) => 20.widthBox,
                        controller: verificationController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyDecorationWith(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => verifyCode(pin),
                      ),
                    ),
                    Spacer(),
                    ChateoButton(
                      isLoading: authState.isLoading,
                      text: 'Verify Code',
                      onPressed: authState.isLoading
                          ? null
                          : () =>
                                verifyCode(verificationController.text.trim()),
                    ),
                    12.heightBox,
                    ChateoButton(
                      isLoading: authState.isLoading,
                      text: 'Resend Code',
                      onPressed: authState.isLoading
                          ? null
                          : () => ref
                                .read(phoneAuthProvider.notifier)
                                .sendCode(
                                  ref.read(selectedCountryProvider),
                                  '',
                                  resend: true,
                                ),
                      variant: ChateoButtonVariant.secondary,
                    ),
                    20.heightBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
