import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

class ReplyQuote extends StatelessWidget {
  const ReplyQuote({super.key, 
    required this.author,
    required this.text,
    required this.isMine,
    required this.isLight,
    
  });
  final String author;
  final String text;
  final bool isMine;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final accent = isMine
        ? Colors.white
        : (isLight ? AppColors.primaryBrand : AppColors.primaryDark);
    final background = isMine
        ? Colors.white.withValues(alpha: 0.16)
        : (isLight
            ? Colors.black.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.07));
    final textColor = isMine
        ? Colors.white.withValues(alpha: 0.85)
        : (isLight ? AppColors.bodyLight : AppColors.bodyDark);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      author,
                      style: AppTextStyles.bodyTextSmall.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyTextSmall
                          .copyWith(color: textColor, fontSize: 12),
                    ),
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