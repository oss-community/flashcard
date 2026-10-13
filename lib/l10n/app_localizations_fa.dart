// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'فلش‌کارت';

  @override
  String get navStudy => 'مرور';

  @override
  String get navWords => 'واژه‌ها';

  @override
  String get navStats => 'آمار';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get welcomeTitle => 'خوش آمدید';

  @override
  String get welcomeBody =>
      'زبانی که می‌خواهید یاد بگیرید، زبانی که بلدید و سطح خود را انتخاب کنید. همه‌ی این‌ها را بعداً در تنظیمات می‌توانید عوض کنید.';

  @override
  String get languageToLearn => 'زبانی که یاد می‌گیرید';

  @override
  String get languageYouKnow => 'زبانی که بلدید';

  @override
  String get level => 'سطح';

  @override
  String get start => 'شروع';

  @override
  String get sameLanguageError => 'دو زبان متفاوت انتخاب کنید.';

  @override
  String get levelAllInOrder => 'همه، به ترتیب';

  @override
  String get levelAllHint =>
      'کارت‌های تازه اول از A1 می‌آیند، بعد از A2 و همین‌طور تا C2.';

  @override
  String get dueNow => 'آماده‌ی مرور';

  @override
  String get newToday => 'کارت تازه‌ی باقی‌مانده‌ی امروز';

  @override
  String get reviewedToday => 'پاسخ‌های امروز';

  @override
  String get streak => 'روزهای پشت سر هم';

  @override
  String get studyNow => 'شروع مرور';

  @override
  String get allDone =>
      'فعلاً کاری نمانده است. بعداً برگردید، یا در تنظیمات تعداد کارت تازه در روز را بیشتر کنید.';

  @override
  String learningPair(String target, String native) {
    return '$target از $native';
  }

  @override
  String levelLabel(String level) {
    return 'سطح $level';
  }

  @override
  String get showAnswer => 'نمایش پاسخ';

  @override
  String get forgot => 'یادم نبود';

  @override
  String get remembered => 'یادم بود';

  @override
  String get difficulty => 'درجه‌ی سختی';

  @override
  String get diffEasy => 'آسان';

  @override
  String get diffMedium => 'متوسط';

  @override
  String get diffAdvanced => 'پیشرفته';

  @override
  String get changeDifficulty => 'تغییر درجه‌ی سختی';

  @override
  String cardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کارت مانده',
    );
    return '$_temp0';
  }

  @override
  String get endSession => 'پایان مرور';

  @override
  String get sessionFinished => 'مرور تمام شد';

  @override
  String sessionSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'به $count کارت پاسخ دادید.',
    );
    return '$_temp0';
  }

  @override
  String get backHome => 'بازگشت';

  @override
  String get keyboardHint => 'فاصله: نمایش پاسخ   ۱: یادم نبود   ۲: یادم بود';

  @override
  String get pluralLabel => 'جمع:';

  @override
  String get noPlural => 'بدون جمع';

  @override
  String get pronounce => 'تلفظ';

  @override
  String get noVoice => 'صدایی برای این زبان در ویندوز نصب نیست';

  @override
  String get newCardBadge => 'تازه';

  @override
  String minutes(int n) {
    return '$n دقیقه';
  }

  @override
  String hours(int n) {
    return '$n ساعت';
  }

  @override
  String days(int n) {
    return '$n روز';
  }

  @override
  String months(int n) {
    return '$n ماه';
  }

  @override
  String years(int n) {
    return '$n سال';
  }

  @override
  String get searchHint => 'جستجو در هر دو زبان';

  @override
  String get allLevels => 'همه';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count واژه',
    );
    return '$_temp0';
  }

  @override
  String get statusNew => 'مرورنشده';

  @override
  String get statusLearning => 'در حال یادگیری';

  @override
  String statusLearned(String date) {
    return 'مرور بعدی $date';
  }

  @override
  String get noResults => 'واژه‌ای پیدا نشد.';

  @override
  String get statsToday => 'امروز';

  @override
  String get statsLast30 => '۳۰ روز گذشته';

  @override
  String get statsByLevel => 'یادگرفته در هر سطح';

  @override
  String learnedOf(int learned, int total) {
    return '$learned از $total';
  }

  @override
  String get statsAllPairs => 'همه‌ی جفت‌زبان‌ها';

  @override
  String get statsThisPair => 'جفت‌زبان فعلی';

  @override
  String get settingsMenuLanguage => 'زبان منو';

  @override
  String get settingsLanguages => 'زبان‌ها';

  @override
  String get settingsStudy => 'مرور';

  @override
  String get settingsNewPerDay => 'کارت تازه در روز';

  @override
  String get settingsReversed => 'کارت برعکس';

  @override
  String get settingsReversedHint =>
      'اول معنی نشان داده می‌شود و باید واژه را به یاد بیاورید. پیشرفتش جدا نگه داشته می‌شود.';

  @override
  String get settingsAppearance => 'ظاهر';

  @override
  String get themeSystem => 'مثل ویندوز';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get settingsAbout => 'پیشرفت برای هر جفت‌زبان جدا نگه داشته می‌شود.';

  @override
  String get typeNoun => 'اسم';

  @override
  String get typeVerb => 'فعل';

  @override
  String get typeAdj => 'صفت';

  @override
  String get typeAdv => 'قید';

  @override
  String get typePrep => 'حرف اضافه';

  @override
  String get typePron => 'ضمیر';

  @override
  String get typeConj => 'حرف ربط';

  @override
  String get typeDet => 'وابسته‌ی اسم';

  @override
  String get typeParticle => 'ادات';

  @override
  String get typeInterj => 'صوت';

  @override
  String get typeNum => 'عدد';

  @override
  String get typePhrasalVerb => 'فعل عبارتی';

  @override
  String get typePhrase => 'عبارت';

  @override
  String get typeIdiom => 'اصطلاح';
}
