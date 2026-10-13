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
      'زبانی را که می‌خواهید یاد بگیرید، زبانی را که بلدید و سطح خود را انتخاب کنید. بعداً در تنظیمات می‌توانید پروفایل‌های دیگری بسازید که هرکدام پیشرفت جدای خود را دارند.';

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
  String get levelAllHint => 'کارت‌های تازه اول از A1 می‌آیند، بعد از A2 و همین‌طور تا C2.';

  @override
  String get dueNow => 'آماده‌ی مرور';

  @override
  String get newLeft => 'واژه‌های تازه‌ی باقی‌مانده';

  @override
  String get newTodayLabel => 'واژه‌ی تازه‌ی امروز';

  @override
  String get reviewedToday => 'پاسخ‌های امروز';

  @override
  String get streak => 'روزهای پشت سر هم';

  @override
  String get studyNow => 'شروع مرور';

  @override
  String get allDone =>
      'فعلاً چیزی برای مطالعه نیست: هیچ مروری سر نرسیده و همه‌ی واژه‌ها خوانده شده‌اند. مرورها سر وقتشان برمی‌گردند.';

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
  String dueInSession(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرور مانده',
      zero: 'مروری نمانده',
    );
    return '$_temp0';
  }

  @override
  String goalProgress(int done, int goal) {
    return 'هدف امروز: $done از $goal واژه‌ی تازه';
  }

  @override
  String newTodayCount(int count) {
    return 'واژه‌ی تازه‌ی امروز: $count';
  }

  @override
  String get goalReached => 'به هدف امروز رسیدید. هر قدر بخواهید می‌توانید ادامه دهید.';

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
  String get noVoice => 'روی این دستگاه صدایی برای این زبان نصب نیست';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count واژه');
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
  String get settingsMenuLanguage => 'زبان منو';

  @override
  String get settingsStudy => 'مرور';

  @override
  String get settingsDailyGoal => 'هدف روزانه (واژه‌ی تازه)';

  @override
  String get settingsDailyGoalHint => 'فقط برای پیگیری است. همیشه می‌توانید بیشتر بخوانید.';

  @override
  String get noGoal => 'ندارد';

  @override
  String get settingsReversed => 'کارت برعکس';

  @override
  String get settingsReversedHint =>
      'اول معنی نشان داده می‌شود و باید واژه را به یاد بیاورید. پیشرفتش جدا نگه داشته می‌شود.';

  @override
  String get settingsAppearance => 'ظاهر';

  @override
  String get themeSystem => 'مثل سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get settingsAbout =>
      'هر پروفایل پیشرفت جدای خود را دارد. برای یادگرفتن جفت‌زبانی دیگر، پروفایل تازه‌ای بسازید.';

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

  @override
  String get profiles => 'پروفایل‌ها';

  @override
  String get profileName => 'نام پروفایل';

  @override
  String get profileNameHint =>
      'اختیاری است. اگر خالی بماند، نام پروفایل از دو زبانش ساخته می‌شود.';

  @override
  String profileDefaultName(String native, String target) {
    return '$native ← $target';
  }

  @override
  String get newProfile => 'پروفایل تازه';

  @override
  String get createProfile => 'ساختن پروفایل';

  @override
  String get switchProfile => 'رفتن به پروفایل دیگر';

  @override
  String get renameProfile => 'تغییر نام';

  @override
  String deleteProfileTitle(String name) {
    return '«$name» پاک شود؟';
  }

  @override
  String get deleteProfileBody => 'همهٔ پیشرفت این پروفایل پاک می‌شود و برگرداندنش ممکن نیست.';

  @override
  String get delete => 'پاک کردن';

  @override
  String get cancel => 'انصراف';

  @override
  String get save => 'ذخیره';

  @override
  String settingsStudyIn(String profile) {
    return 'یادگیری: $profile';
  }

  @override
  String get settingsShowForms => 'نمایش شکل‌های واژه';

  @override
  String get settingsShowFormsHint => 'جمع، شکل‌های فعل و صفت تفضیلی پشت کارت نشان داده شود.';

  @override
  String get conjugation => 'صرف فعل';

  @override
  String get formInfinitive => 'مصدر';

  @override
  String get formPast => 'گذشته';

  @override
  String get formPerfect => 'ماضی نقلی';

  @override
  String get formPastParticiple => 'اسم مفعول';

  @override
  String get formPastStem => 'بن ماضی';

  @override
  String get formPresentStem => 'بن مضارع';

  @override
  String get formComparative => 'صفت برتر';

  @override
  String get formSuperlative => 'صفت برترین';

  @override
  String get tensePresent => 'مضارع';

  @override
  String get tensePresentProgressive => 'مضارع مستمر';

  @override
  String get tenseSimplePast => 'ماضی ساده';

  @override
  String get tensePastImperfect => 'ماضی استمراری';

  @override
  String get tensePastProgressive => 'ماضی مستمر';

  @override
  String get tensePresentPerfect => 'ماضی نقلی';

  @override
  String get tensePastPerfect => 'ماضی بعید';

  @override
  String get tenseFuture => 'آینده';

  @override
  String get about => 'درباره';

  @override
  String get aboutBody =>
      'واژه‌ها را با فلش‌کارت و مرور فاصله‌دار یاد بگیرید. این برنامه رایگان و متن‌باز است، بدون اینترنت کار می‌کند و پیشرفت شما فقط روی همین دستگاه می‌ماند.';

  @override
  String aboutVersion(String version) {
    return 'نسخهٔ $version';
  }

  @override
  String get aboutFeedback => 'گزارش مشکل یا پیشنهاد';

  @override
  String get privacyPolicy => 'حریم خصوصی';

  @override
  String get aboutSource => 'کد منبع';

  @override
  String get aboutLicenses => 'مجوزها';
}
