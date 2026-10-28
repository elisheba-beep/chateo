import 'dart:ui';

import 'package:chateo/core/constants/modes/country.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_country_provider.g.dart';


@riverpod
class SelectedCountry extends _$SelectedCountry {
  @override
  Country build() {
    final locale = PlatformDispatcher.instance.locale.countryCode;
    return CountryData.byAlpha2(locale) ?? CountryData.byAlpha2('NG')!;
  }
  void select(Country c) => state = c;
}