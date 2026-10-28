import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/button/chateo_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class WalkthroughScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              55.heightBox,
              Center(
                child: Image(
                  image: AssetImage(
                    isLight
                        ? 'assets/images/chateo_onboarding_light.png'
                        : 'assets/images/chateo_onboarding_dark.png',
                  ),
                ),
              ),
              42.heightBox,
              Text(
                textAlign: TextAlign.center,
                'Connect easily with\nyour family and friends\nover countries',
                style: AppTextStyles.heading2,
              ),
              Spacer(),
              Text(
                'Terms & Privacy Policy',
                style: AppTextStyles.bodyTextSmall,
              ),
              18.heightBox,
              ChateoButton(
                text: 'Start Messaging',
                onPressed: () {
                  context.pushNamed(RouteNames.phoneNumberInput);
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
