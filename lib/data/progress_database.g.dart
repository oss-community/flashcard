// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_database.dart';

// ignore_for_file: type=lint
class $ReviewStatesTable extends ReviewStates with TableInfo<$ReviewStatesTable, ReviewState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nativeMeta = const VerificationMeta('native');
  @override
  late final GeneratedColumn<String> native = GeneratedColumn<String>(
    'native',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reversedMeta = const VerificationMeta('reversed');
  @override
  late final GeneratedColumn<bool> reversed = GeneratedColumn<bool>(
    'reversed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("reversed" IN (0, 1))'),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta('stability');
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewMeta = const VerificationMeta('lastReview');
  @override
  late final GeneratedColumn<DateTime> lastReview = GeneratedColumn<DateTime>(
    'last_review',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    target,
    native,
    reversed,
    state,
    step,
    stability,
    difficulty,
    due,
    lastReview,
    reps,
    lapses,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta, cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta, target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('native')) {
      context.handle(_nativeMeta, native.isAcceptableOrUnknown(data['native']!, _nativeMeta));
    } else if (isInserting) {
      context.missing(_nativeMeta);
    }
    if (data.containsKey('reversed')) {
      context.handle(
        _reversedMeta,
        reversed.isAcceptableOrUnknown(data['reversed']!, _reversedMeta),
      );
    } else if (isInserting) {
      context.missing(_reversedMeta);
    }
    if (data.containsKey('state')) {
      context.handle(_stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('step')) {
      context.handle(_stepMeta, step.isAcceptableOrUnknown(data['step']!, _stepMeta));
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(_dueMeta, due.isAcceptableOrUnknown(data['due']!, _dueMeta));
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
        _lastReviewMeta,
        lastReview.isAcceptableOrUnknown(data['last_review']!, _lastReviewMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(_repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta, lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId, target, native, reversed};
  @override
  ReviewState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewState(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      native: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native'],
      )!,
      reversed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reversed'],
      )!,
      state: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}state'])!,
      step: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}step']),
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      ),
      due: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}due'])!,
      lastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review'],
      ),
      reps: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
    );
  }

  @override
  $ReviewStatesTable createAlias(String alias) {
    return $ReviewStatesTable(attachedDatabase, alias);
  }
}

class ReviewState extends DataClass implements Insertable<ReviewState> {
  final String cardId;
  final String target;
  final String native;
  final bool reversed;

  /// FSRS state: 1 learning, 2 review, 3 relearning.
  final int state;
  final int? step;
  final double? stability;
  final double? difficulty;
  final DateTime due;
  final DateTime? lastReview;
  final int reps;
  final int lapses;
  const ReviewState({
    required this.cardId,
    required this.target,
    required this.native,
    required this.reversed,
    required this.state,
    this.step,
    this.stability,
    this.difficulty,
    required this.due,
    this.lastReview,
    required this.reps,
    required this.lapses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['target'] = Variable<String>(target);
    map['native'] = Variable<String>(native);
    map['reversed'] = Variable<bool>(reversed);
    map['state'] = Variable<int>(state);
    if (!nullToAbsent || step != null) {
      map['step'] = Variable<int>(step);
    }
    if (!nullToAbsent || stability != null) {
      map['stability'] = Variable<double>(stability);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<double>(difficulty);
    }
    map['due'] = Variable<DateTime>(due);
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<DateTime>(lastReview);
    }
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    return map;
  }

  ReviewStatesCompanion toCompanion(bool nullToAbsent) {
    return ReviewStatesCompanion(
      cardId: Value(cardId),
      target: Value(target),
      native: Value(native),
      reversed: Value(reversed),
      state: Value(state),
      step: step == null && nullToAbsent ? const Value.absent() : Value(step),
      stability: stability == null && nullToAbsent ? const Value.absent() : Value(stability),
      difficulty: difficulty == null && nullToAbsent ? const Value.absent() : Value(difficulty),
      due: Value(due),
      lastReview: lastReview == null && nullToAbsent ? const Value.absent() : Value(lastReview),
      reps: Value(reps),
      lapses: Value(lapses),
    );
  }

  factory ReviewState.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewState(
      cardId: serializer.fromJson<String>(json['cardId']),
      target: serializer.fromJson<String>(json['target']),
      native: serializer.fromJson<String>(json['native']),
      reversed: serializer.fromJson<bool>(json['reversed']),
      state: serializer.fromJson<int>(json['state']),
      step: serializer.fromJson<int?>(json['step']),
      stability: serializer.fromJson<double?>(json['stability']),
      difficulty: serializer.fromJson<double?>(json['difficulty']),
      due: serializer.fromJson<DateTime>(json['due']),
      lastReview: serializer.fromJson<DateTime?>(json['lastReview']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'target': serializer.toJson<String>(target),
      'native': serializer.toJson<String>(native),
      'reversed': serializer.toJson<bool>(reversed),
      'state': serializer.toJson<int>(state),
      'step': serializer.toJson<int?>(step),
      'stability': serializer.toJson<double?>(stability),
      'difficulty': serializer.toJson<double?>(difficulty),
      'due': serializer.toJson<DateTime>(due),
      'lastReview': serializer.toJson<DateTime?>(lastReview),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
    };
  }

  ReviewState copyWith({
    String? cardId,
    String? target,
    String? native,
    bool? reversed,
    int? state,
    Value<int?> step = const Value.absent(),
    Value<double?> stability = const Value.absent(),
    Value<double?> difficulty = const Value.absent(),
    DateTime? due,
    Value<DateTime?> lastReview = const Value.absent(),
    int? reps,
    int? lapses,
  }) => ReviewState(
    cardId: cardId ?? this.cardId,
    target: target ?? this.target,
    native: native ?? this.native,
    reversed: reversed ?? this.reversed,
    state: state ?? this.state,
    step: step.present ? step.value : this.step,
    stability: stability.present ? stability.value : this.stability,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    due: due ?? this.due,
    lastReview: lastReview.present ? lastReview.value : this.lastReview,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
  );
  ReviewState copyWithCompanion(ReviewStatesCompanion data) {
    return ReviewState(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      target: data.target.present ? data.target.value : this.target,
      native: data.native.present ? data.native.value : this.native,
      reversed: data.reversed.present ? data.reversed.value : this.reversed,
      state: data.state.present ? data.state.value : this.state,
      step: data.step.present ? data.step.value : this.step,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present ? data.difficulty.value : this.difficulty,
      due: data.due.present ? data.due.value : this.due,
      lastReview: data.lastReview.present ? data.lastReview.value : this.lastReview,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewState(')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('native: $native, ')
          ..write('reversed: $reversed, ')
          ..write('state: $state, ')
          ..write('step: $step, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardId,
    target,
    native,
    reversed,
    state,
    step,
    stability,
    difficulty,
    due,
    lastReview,
    reps,
    lapses,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewState &&
          other.cardId == this.cardId &&
          other.target == this.target &&
          other.native == this.native &&
          other.reversed == this.reversed &&
          other.state == this.state &&
          other.step == this.step &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.due == this.due &&
          other.lastReview == this.lastReview &&
          other.reps == this.reps &&
          other.lapses == this.lapses);
}

class ReviewStatesCompanion extends UpdateCompanion<ReviewState> {
  final Value<String> cardId;
  final Value<String> target;
  final Value<String> native;
  final Value<bool> reversed;
  final Value<int> state;
  final Value<int?> step;
  final Value<double?> stability;
  final Value<double?> difficulty;
  final Value<DateTime> due;
  final Value<DateTime?> lastReview;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<int> rowid;
  const ReviewStatesCompanion({
    this.cardId = const Value.absent(),
    this.target = const Value.absent(),
    this.native = const Value.absent(),
    this.reversed = const Value.absent(),
    this.state = const Value.absent(),
    this.step = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.due = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewStatesCompanion.insert({
    required String cardId,
    required String target,
    required String native,
    required bool reversed,
    required int state,
    this.step = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    required DateTime due,
    this.lastReview = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       target = Value(target),
       native = Value(native),
       reversed = Value(reversed),
       state = Value(state),
       due = Value(due);
  static Insertable<ReviewState> custom({
    Expression<String>? cardId,
    Expression<String>? target,
    Expression<String>? native,
    Expression<bool>? reversed,
    Expression<int>? state,
    Expression<int>? step,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<DateTime>? due,
    Expression<DateTime>? lastReview,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (target != null) 'target': target,
      if (native != null) 'native': native,
      if (reversed != null) 'reversed': reversed,
      if (state != null) 'state': state,
      if (step != null) 'step': step,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (due != null) 'due': due,
      if (lastReview != null) 'last_review': lastReview,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewStatesCompanion copyWith({
    Value<String>? cardId,
    Value<String>? target,
    Value<String>? native,
    Value<bool>? reversed,
    Value<int>? state,
    Value<int?>? step,
    Value<double?>? stability,
    Value<double?>? difficulty,
    Value<DateTime>? due,
    Value<DateTime?>? lastReview,
    Value<int>? reps,
    Value<int>? lapses,
    Value<int>? rowid,
  }) {
    return ReviewStatesCompanion(
      cardId: cardId ?? this.cardId,
      target: target ?? this.target,
      native: native ?? this.native,
      reversed: reversed ?? this.reversed,
      state: state ?? this.state,
      step: step ?? this.step,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      due: due ?? this.due,
      lastReview: lastReview ?? this.lastReview,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (native.present) {
      map['native'] = Variable<String>(native.value);
    }
    if (reversed.present) {
      map['reversed'] = Variable<bool>(reversed.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<DateTime>(lastReview.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewStatesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('native: $native, ')
          ..write('reversed: $reversed, ')
          ..write('state: $state, ')
          ..write('step: $step, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nativeMeta = const VerificationMeta('native');
  @override
  late final GeneratedColumn<String> native = GeneratedColumn<String>(
    'native',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reversedMeta = const VerificationMeta('reversed');
  @override
  late final GeneratedColumn<bool> reversed = GeneratedColumn<bool>(
    'reversed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("reversed" IN (0, 1))'),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wasNewMeta = const VerificationMeta('wasNew');
  @override
  late final GeneratedColumn<bool> wasNew = GeneratedColumn<bool>(
    'was_new',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("was_new" IN (0, 1))'),
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    target,
    native,
    reversed,
    rating,
    wasNew,
    reviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta, cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta, target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('native')) {
      context.handle(_nativeMeta, native.isAcceptableOrUnknown(data['native']!, _nativeMeta));
    } else if (isInserting) {
      context.missing(_nativeMeta);
    }
    if (data.containsKey('reversed')) {
      context.handle(
        _reversedMeta,
        reversed.isAcceptableOrUnknown(data['reversed']!, _reversedMeta),
      );
    } else if (isInserting) {
      context.missing(_reversedMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta, rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('was_new')) {
      context.handle(_wasNewMeta, wasNew.isAcceptableOrUnknown(data['was_new']!, _wasNewMeta));
    } else if (isInserting) {
      context.missing(_wasNewMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      native: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native'],
      )!,
      reversed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reversed'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      wasNew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_new'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final String cardId;
  final String target;
  final String native;
  final bool reversed;

  /// 1 again, 2 hard, 3 good, 4 easy.
  final int rating;

  /// True when this was the first time the card was seen.
  final bool wasNew;
  final DateTime reviewedAt;
  const ReviewLog({
    required this.id,
    required this.cardId,
    required this.target,
    required this.native,
    required this.reversed,
    required this.rating,
    required this.wasNew,
    required this.reviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['target'] = Variable<String>(target);
    map['native'] = Variable<String>(native);
    map['reversed'] = Variable<bool>(reversed);
    map['rating'] = Variable<int>(rating);
    map['was_new'] = Variable<bool>(wasNew);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      target: Value(target),
      native: Value(native),
      reversed: Value(reversed),
      rating: Value(rating),
      wasNew: Value(wasNew),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory ReviewLog.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      target: serializer.fromJson<String>(json['target']),
      native: serializer.fromJson<String>(json['native']),
      reversed: serializer.fromJson<bool>(json['reversed']),
      rating: serializer.fromJson<int>(json['rating']),
      wasNew: serializer.fromJson<bool>(json['wasNew']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'target': serializer.toJson<String>(target),
      'native': serializer.toJson<String>(native),
      'reversed': serializer.toJson<bool>(reversed),
      'rating': serializer.toJson<int>(rating),
      'wasNew': serializer.toJson<bool>(wasNew),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  ReviewLog copyWith({
    int? id,
    String? cardId,
    String? target,
    String? native,
    bool? reversed,
    int? rating,
    bool? wasNew,
    DateTime? reviewedAt,
  }) => ReviewLog(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    target: target ?? this.target,
    native: native ?? this.native,
    reversed: reversed ?? this.reversed,
    rating: rating ?? this.rating,
    wasNew: wasNew ?? this.wasNew,
    reviewedAt: reviewedAt ?? this.reviewedAt,
  );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      target: data.target.present ? data.target.value : this.target,
      native: data.native.present ? data.native.value : this.native,
      reversed: data.reversed.present ? data.reversed.value : this.reversed,
      rating: data.rating.present ? data.rating.value : this.rating,
      wasNew: data.wasNew.present ? data.wasNew.value : this.wasNew,
      reviewedAt: data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('native: $native, ')
          ..write('reversed: $reversed, ')
          ..write('rating: $rating, ')
          ..write('wasNew: $wasNew, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, target, native, reversed, rating, wasNew, reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.target == this.target &&
          other.native == this.native &&
          other.reversed == this.reversed &&
          other.rating == this.rating &&
          other.wasNew == this.wasNew &&
          other.reviewedAt == this.reviewedAt);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<String> target;
  final Value<String> native;
  final Value<bool> reversed;
  final Value<int> rating;
  final Value<bool> wasNew;
  final Value<DateTime> reviewedAt;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.target = const Value.absent(),
    this.native = const Value.absent(),
    this.reversed = const Value.absent(),
    this.rating = const Value.absent(),
    this.wasNew = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required String target,
    required String native,
    required bool reversed,
    required int rating,
    required bool wasNew,
    required DateTime reviewedAt,
  }) : cardId = Value(cardId),
       target = Value(target),
       native = Value(native),
       reversed = Value(reversed),
       rating = Value(rating),
       wasNew = Value(wasNew),
       reviewedAt = Value(reviewedAt);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<String>? target,
    Expression<String>? native,
    Expression<bool>? reversed,
    Expression<int>? rating,
    Expression<bool>? wasNew,
    Expression<DateTime>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (target != null) 'target': target,
      if (native != null) 'native': native,
      if (reversed != null) 'reversed': reversed,
      if (rating != null) 'rating': rating,
      if (wasNew != null) 'was_new': wasNew,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardId,
    Value<String>? target,
    Value<String>? native,
    Value<bool>? reversed,
    Value<int>? rating,
    Value<bool>? wasNew,
    Value<DateTime>? reviewedAt,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      target: target ?? this.target,
      native: native ?? this.native,
      reversed: reversed ?? this.reversed,
      rating: rating ?? this.rating,
      wasNew: wasNew ?? this.wasNew,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (native.present) {
      map['native'] = Variable<String>(native.value);
    }
    if (reversed.present) {
      map['reversed'] = Variable<bool>(reversed.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (wasNew.present) {
      map['was_new'] = Variable<bool>(wasNew.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('native: $native, ')
          ..write('reversed: $reversed, ')
          ..write('rating: $rating, ')
          ..write('wasNew: $wasNew, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DifficultyOverridesTable extends DifficultyOverrides
    with TableInfo<$DifficultyOverridesTable, DifficultyOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DifficultyOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cardId, target, difficulty];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'difficulty_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<DifficultyOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta, cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta, target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId, target};
  @override
  DifficultyOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DifficultyOverride(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
    );
  }

  @override
  $DifficultyOverridesTable createAlias(String alias) {
    return $DifficultyOverridesTable(attachedDatabase, alias);
  }
}

class DifficultyOverride extends DataClass implements Insertable<DifficultyOverride> {
  final String cardId;
  final String target;

  /// `easy`, `medium` or `advanced`.
  final String difficulty;
  const DifficultyOverride({required this.cardId, required this.target, required this.difficulty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['target'] = Variable<String>(target);
    map['difficulty'] = Variable<String>(difficulty);
    return map;
  }

  DifficultyOverridesCompanion toCompanion(bool nullToAbsent) {
    return DifficultyOverridesCompanion(
      cardId: Value(cardId),
      target: Value(target),
      difficulty: Value(difficulty),
    );
  }

  factory DifficultyOverride.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DifficultyOverride(
      cardId: serializer.fromJson<String>(json['cardId']),
      target: serializer.fromJson<String>(json['target']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'target': serializer.toJson<String>(target),
      'difficulty': serializer.toJson<String>(difficulty),
    };
  }

  DifficultyOverride copyWith({String? cardId, String? target, String? difficulty}) =>
      DifficultyOverride(
        cardId: cardId ?? this.cardId,
        target: target ?? this.target,
        difficulty: difficulty ?? this.difficulty,
      );
  DifficultyOverride copyWithCompanion(DifficultyOverridesCompanion data) {
    return DifficultyOverride(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      target: data.target.present ? data.target.value : this.target,
      difficulty: data.difficulty.present ? data.difficulty.value : this.difficulty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DifficultyOverride(')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, target, difficulty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DifficultyOverride &&
          other.cardId == this.cardId &&
          other.target == this.target &&
          other.difficulty == this.difficulty);
}

class DifficultyOverridesCompanion extends UpdateCompanion<DifficultyOverride> {
  final Value<String> cardId;
  final Value<String> target;
  final Value<String> difficulty;
  final Value<int> rowid;
  const DifficultyOverridesCompanion({
    this.cardId = const Value.absent(),
    this.target = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DifficultyOverridesCompanion.insert({
    required String cardId,
    required String target,
    required String difficulty,
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       target = Value(target),
       difficulty = Value(difficulty);
  static Insertable<DifficultyOverride> custom({
    Expression<String>? cardId,
    Expression<String>? target,
    Expression<String>? difficulty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (target != null) 'target': target,
      if (difficulty != null) 'difficulty': difficulty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DifficultyOverridesCompanion copyWith({
    Value<String>? cardId,
    Value<String>? target,
    Value<String>? difficulty,
    Value<int>? rowid,
  }) {
    return DifficultyOverridesCompanion(
      cardId: cardId ?? this.cardId,
      target: target ?? this.target,
      difficulty: difficulty ?? this.difficulty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DifficultyOverridesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('target: $target, ')
          ..write('difficulty: $difficulty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProgressDatabase extends GeneratedDatabase {
  _$ProgressDatabase(QueryExecutor e) : super(e);
  $ProgressDatabaseManager get managers => $ProgressDatabaseManager(this);
  late final $ReviewStatesTable reviewStates = $ReviewStatesTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DifficultyOverridesTable difficultyOverrides = $DifficultyOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    reviewStates,
    reviewLogs,
    settings,
    difficultyOverrides,
  ];
}

typedef $$ReviewStatesTableCreateCompanionBuilder = ReviewStatesCompanion Function({
  required String cardId,
  required String target,
  required String native,
  required bool reversed,
  required int state,
  Value<int?> step,
  Value<double?> stability,
  Value<double?> difficulty,
  required DateTime due,
  Value<DateTime?> lastReview,
  Value<int> reps,
  Value<int> lapses,
  Value<int> rowid,
});
typedef $$ReviewStatesTableUpdateCompanionBuilder = ReviewStatesCompanion Function({
  Value<String> cardId,
  Value<String> target,
  Value<String> native,
  Value<bool> reversed,
  Value<int> state,
  Value<int?> step,
  Value<double?> stability,
  Value<double?> difficulty,
  Value<DateTime> due,
  Value<DateTime?> lastReview,
  Value<int> reps,
  Value<int> lapses,
  Value<int> rowid,
});

class $$ReviewStatesTableFilterComposer extends Composer<_$ProgressDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReview =>
      $composableBuilder(column: $table.lastReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => ColumnFilters(column));
}

class $$ReviewStatesTableOrderingComposer extends Composer<_$ProgressDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReview =>
      $composableBuilder(column: $table.lastReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => ColumnOrderings(column));
}

class $$ReviewStatesTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => column);

  GeneratedColumn<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReview =>
      $composableBuilder(column: $table.lastReview, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);
}

class $$ReviewStatesTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $ReviewStatesTable,
          ReviewState,
          $$ReviewStatesTableFilterComposer,
          $$ReviewStatesTableOrderingComposer,
          $$ReviewStatesTableAnnotationComposer,
          $$ReviewStatesTableCreateCompanionBuilder,
          $$ReviewStatesTableUpdateCompanionBuilder,
          (ReviewState, BaseReferences<_$ProgressDatabase, $ReviewStatesTable, ReviewState>),
          ReviewState,
          PrefetchHooks Function()
        > {
  $$ReviewStatesTableTableManager(_$ProgressDatabase db, $ReviewStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ReviewStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ReviewStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> native = const Value.absent(),
                Value<bool> reversed = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int?> step = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewStatesCompanion(
                cardId: cardId,
                target: target,
                native: native,
                reversed: reversed,
                state: state,
                step: step,
                stability: stability,
                difficulty: difficulty,
                due: due,
                lastReview: lastReview,
                reps: reps,
                lapses: lapses,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                required String target,
                required String native,
                required bool reversed,
                required int state,
                Value<int?> step = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                required DateTime due,
                Value<DateTime?> lastReview = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewStatesCompanion.insert(
                cardId: cardId,
                target: target,
                native: native,
                reversed: reversed,
                state: state,
                step: step,
                stability: stability,
                difficulty: difficulty,
                due: due,
                lastReview: lastReview,
                reps: reps,
                lapses: lapses,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewStatesTable, ReviewState>(table),
                  BaseReferences<_$ProgressDatabase, $ReviewStatesTable, ReviewState>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $ReviewStatesTable,
      ReviewState,
      $$ReviewStatesTableFilterComposer,
      $$ReviewStatesTableOrderingComposer,
      $$ReviewStatesTableAnnotationComposer,
      $$ReviewStatesTableCreateCompanionBuilder,
      $$ReviewStatesTableUpdateCompanionBuilder,
      (ReviewState, BaseReferences<_$ProgressDatabase, $ReviewStatesTable, ReviewState>),
      ReviewState,
      PrefetchHooks Function()
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  required String cardId,
  required String target,
  required String native,
  required bool reversed,
  required int rating,
  required bool wasNew,
  required DateTime reviewedAt,
});
typedef $$ReviewLogsTableUpdateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  Value<String> cardId,
  Value<String> target,
  Value<String> native,
  Value<bool> reversed,
  Value<int> rating,
  Value<bool> wasNew,
  Value<DateTime> reviewedAt,
});

class $$ReviewLogsTableFilterComposer extends Composer<_$ProgressDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasNew =>
      $composableBuilder(column: $table.wasNew, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt =>
      $composableBuilder(column: $table.reviewedAt, builder: (column) => ColumnFilters(column));
}

class $$ReviewLogsTableOrderingComposer extends Composer<_$ProgressDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasNew =>
      $composableBuilder(column: $table.wasNew, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt =>
      $composableBuilder(column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReviewLogsTableAnnotationComposer extends Composer<_$ProgressDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get native =>
      $composableBuilder(column: $table.native, builder: (column) => column);

  GeneratedColumn<bool> get reversed =>
      $composableBuilder(column: $table.reversed, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get wasNew =>
      $composableBuilder(column: $table.wasNew, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt =>
      $composableBuilder(column: $table.reviewedAt, builder: (column) => column);
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $ReviewLogsTable,
          ReviewLog,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (ReviewLog, BaseReferences<_$ProgressDatabase, $ReviewLogsTable, ReviewLog>),
          ReviewLog,
          PrefetchHooks Function()
        > {
  $$ReviewLogsTableTableManager(_$ProgressDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> native = const Value.absent(),
                Value<bool> reversed = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<bool> wasNew = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                cardId: cardId,
                target: target,
                native: native,
                reversed: reversed,
                rating: rating,
                wasNew: wasNew,
                reviewedAt: reviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardId,
                required String target,
                required String native,
                required bool reversed,
                required int rating,
                required bool wasNew,
                required DateTime reviewedAt,
              }) => ReviewLogsCompanion.insert(
                id: id,
                cardId: cardId,
                target: target,
                native: native,
                reversed: reversed,
                rating: rating,
                wasNew: wasNew,
                reviewedAt: reviewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewLogsTable, ReviewLog>(table),
                  BaseReferences<_$ProgressDatabase, $ReviewLogsTable, ReviewLog>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $ReviewLogsTable,
      ReviewLog,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLog, BaseReferences<_$ProgressDatabase, $ReviewLogsTable, ReviewLog>),
      ReviewLog,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer extends Composer<_$ProgressDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer extends Composer<_$ProgressDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer extends Composer<_$ProgressDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$ProgressDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$ProgressDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$ProgressDatabase, $SettingsTable, Setting>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$ProgressDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$DifficultyOverridesTableCreateCompanionBuilder = DifficultyOverridesCompanion Function({
  required String cardId,
  required String target,
  required String difficulty,
  Value<int> rowid,
});
typedef $$DifficultyOverridesTableUpdateCompanionBuilder = DifficultyOverridesCompanion Function({
  Value<String> cardId,
  Value<String> target,
  Value<String> difficulty,
  Value<int> rowid,
});

class $$DifficultyOverridesTableFilterComposer
    extends Composer<_$ProgressDatabase, $DifficultyOverridesTable> {
  $$DifficultyOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => ColumnFilters(column));
}

class $$DifficultyOverridesTableOrderingComposer
    extends Composer<_$ProgressDatabase, $DifficultyOverridesTable> {
  $$DifficultyOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => ColumnOrderings(column));
}

class $$DifficultyOverridesTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $DifficultyOverridesTable> {
  $$DifficultyOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get difficulty =>
      $composableBuilder(column: $table.difficulty, builder: (column) => column);
}

class $$DifficultyOverridesTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $DifficultyOverridesTable,
          DifficultyOverride,
          $$DifficultyOverridesTableFilterComposer,
          $$DifficultyOverridesTableOrderingComposer,
          $$DifficultyOverridesTableAnnotationComposer,
          $$DifficultyOverridesTableCreateCompanionBuilder,
          $$DifficultyOverridesTableUpdateCompanionBuilder,
          (
            DifficultyOverride,
            BaseReferences<_$ProgressDatabase, $DifficultyOverridesTable, DifficultyOverride>,
          ),
          DifficultyOverride,
          PrefetchHooks Function()
        > {
  $$DifficultyOverridesTableTableManager(_$ProgressDatabase db, $DifficultyOverridesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DifficultyOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DifficultyOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DifficultyOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DifficultyOverridesCompanion(
                cardId: cardId,
                target: target,
                difficulty: difficulty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                required String target,
                required String difficulty,
                Value<int> rowid = const Value.absent(),
              }) => DifficultyOverridesCompanion.insert(
                cardId: cardId,
                target: target,
                difficulty: difficulty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DifficultyOverridesTable, DifficultyOverride>(table),
                  BaseReferences<_$ProgressDatabase, $DifficultyOverridesTable, DifficultyOverride>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DifficultyOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $DifficultyOverridesTable,
      DifficultyOverride,
      $$DifficultyOverridesTableFilterComposer,
      $$DifficultyOverridesTableOrderingComposer,
      $$DifficultyOverridesTableAnnotationComposer,
      $$DifficultyOverridesTableCreateCompanionBuilder,
      $$DifficultyOverridesTableUpdateCompanionBuilder,
      (
        DifficultyOverride,
        BaseReferences<_$ProgressDatabase, $DifficultyOverridesTable, DifficultyOverride>,
      ),
      DifficultyOverride,
      PrefetchHooks Function()
    >;

class $ProgressDatabaseManager {
  final _$ProgressDatabase _db;
  $ProgressDatabaseManager(this._db);
  $$ReviewStatesTableTableManager get reviewStates =>
      $$ReviewStatesTableTableManager(_db, _db.reviewStates);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$SettingsTableTableManager get settings => $$SettingsTableTableManager(_db, _db.settings);
  $$DifficultyOverridesTableTableManager get difficultyOverrides =>
      $$DifficultyOverridesTableTableManager(_db, _db.difficultyOverrides);
}
