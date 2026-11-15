// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PaymentCardsTable extends PaymentCards
    with TableInfo<$PaymentCardsTable, PaymentCardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maskedNumberMeta = const VerificationMeta(
    'maskedNumber',
  );
  @override
  late final GeneratedColumn<String> maskedNumber = GeneratedColumn<String>(
    'masked_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFourMeta = const VerificationMeta(
    'lastFour',
  );
  @override
  late final GeneratedColumn<String> lastFour = GeneratedColumn<String>(
    'last_four',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardholderNameMeta = const VerificationMeta(
    'cardholderName',
  );
  @override
  late final GeneratedColumn<String> cardholderName = GeneratedColumn<String>(
    'cardholder_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryMonthYearMeta = const VerificationMeta(
    'expiryMonthYear',
  );
  @override
  late final GeneratedColumn<String> expiryMonthYear = GeneratedColumn<String>(
    'expiry_month_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorGradientIndexMeta =
      const VerificationMeta('colorGradientIndex');
  @override
  late final GeneratedColumn<int> colorGradientIndex = GeneratedColumn<int>(
    'color_gradient_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankName,
    cardType,
    nickname,
    network,
    maskedNumber,
    lastFour,
    cardholderName,
    expiryMonthYear,
    colorGradientIndex,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentCardData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_cardTypeMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('masked_number')) {
      context.handle(
        _maskedNumberMeta,
        maskedNumber.isAcceptableOrUnknown(
          data['masked_number']!,
          _maskedNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maskedNumberMeta);
    }
    if (data.containsKey('last_four')) {
      context.handle(
        _lastFourMeta,
        lastFour.isAcceptableOrUnknown(data['last_four']!, _lastFourMeta),
      );
    } else if (isInserting) {
      context.missing(_lastFourMeta);
    }
    if (data.containsKey('cardholder_name')) {
      context.handle(
        _cardholderNameMeta,
        cardholderName.isAcceptableOrUnknown(
          data['cardholder_name']!,
          _cardholderNameMeta,
        ),
      );
    }
    if (data.containsKey('expiry_month_year')) {
      context.handle(
        _expiryMonthYearMeta,
        expiryMonthYear.isAcceptableOrUnknown(
          data['expiry_month_year']!,
          _expiryMonthYearMeta,
        ),
      );
    }
    if (data.containsKey('color_gradient_index')) {
      context.handle(
        _colorGradientIndexMeta,
        colorGradientIndex.isAcceptableOrUnknown(
          data['color_gradient_index']!,
          _colorGradientIndexMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentCardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentCardData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      maskedNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}masked_number'],
      )!,
      lastFour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_four'],
      )!,
      cardholderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cardholder_name'],
      ),
      expiryMonthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_month_year'],
      ),
      colorGradientIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_gradient_index'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentCardsTable createAlias(String alias) {
    return $PaymentCardsTable(attachedDatabase, alias);
  }
}

class PaymentCardData extends DataClass implements Insertable<PaymentCardData> {
  final String id;
  final String bankName;
  final String cardType;
  final String? nickname;
  final String network;
  final String maskedNumber;
  final String lastFour;
  final String? cardholderName;
  final String? expiryMonthYear;
  final int colorGradientIndex;
  final bool isActive;
  final DateTime createdAt;
  const PaymentCardData({
    required this.id,
    required this.bankName,
    required this.cardType,
    this.nickname,
    required this.network,
    required this.maskedNumber,
    required this.lastFour,
    this.cardholderName,
    this.expiryMonthYear,
    required this.colorGradientIndex,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['card_type'] = Variable<String>(cardType);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    map['network'] = Variable<String>(network);
    map['masked_number'] = Variable<String>(maskedNumber);
    map['last_four'] = Variable<String>(lastFour);
    if (!nullToAbsent || cardholderName != null) {
      map['cardholder_name'] = Variable<String>(cardholderName);
    }
    if (!nullToAbsent || expiryMonthYear != null) {
      map['expiry_month_year'] = Variable<String>(expiryMonthYear);
    }
    map['color_gradient_index'] = Variable<int>(colorGradientIndex);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentCardsCompanion toCompanion(bool nullToAbsent) {
    return PaymentCardsCompanion(
      id: Value(id),
      bankName: Value(bankName),
      cardType: Value(cardType),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      network: Value(network),
      maskedNumber: Value(maskedNumber),
      lastFour: Value(lastFour),
      cardholderName: cardholderName == null && nullToAbsent
          ? const Value.absent()
          : Value(cardholderName),
      expiryMonthYear: expiryMonthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryMonthYear),
      colorGradientIndex: Value(colorGradientIndex),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentCardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentCardData(
      id: serializer.fromJson<String>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      cardType: serializer.fromJson<String>(json['cardType']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      network: serializer.fromJson<String>(json['network']),
      maskedNumber: serializer.fromJson<String>(json['maskedNumber']),
      lastFour: serializer.fromJson<String>(json['lastFour']),
      cardholderName: serializer.fromJson<String?>(json['cardholderName']),
      expiryMonthYear: serializer.fromJson<String?>(json['expiryMonthYear']),
      colorGradientIndex: serializer.fromJson<int>(json['colorGradientIndex']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bankName': serializer.toJson<String>(bankName),
      'cardType': serializer.toJson<String>(cardType),
      'nickname': serializer.toJson<String?>(nickname),
      'network': serializer.toJson<String>(network),
      'maskedNumber': serializer.toJson<String>(maskedNumber),
      'lastFour': serializer.toJson<String>(lastFour),
      'cardholderName': serializer.toJson<String?>(cardholderName),
      'expiryMonthYear': serializer.toJson<String?>(expiryMonthYear),
      'colorGradientIndex': serializer.toJson<int>(colorGradientIndex),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentCardData copyWith({
    String? id,
    String? bankName,
    String? cardType,
    Value<String?> nickname = const Value.absent(),
    String? network,
    String? maskedNumber,
    String? lastFour,
    Value<String?> cardholderName = const Value.absent(),
    Value<String?> expiryMonthYear = const Value.absent(),
    int? colorGradientIndex,
    bool? isActive,
    DateTime? createdAt,
  }) => PaymentCardData(
    id: id ?? this.id,
    bankName: bankName ?? this.bankName,
    cardType: cardType ?? this.cardType,
    nickname: nickname.present ? nickname.value : this.nickname,
    network: network ?? this.network,
    maskedNumber: maskedNumber ?? this.maskedNumber,
    lastFour: lastFour ?? this.lastFour,
    cardholderName: cardholderName.present
        ? cardholderName.value
        : this.cardholderName,
    expiryMonthYear: expiryMonthYear.present
        ? expiryMonthYear.value
        : this.expiryMonthYear,
    colorGradientIndex: colorGradientIndex ?? this.colorGradientIndex,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentCardData copyWithCompanion(PaymentCardsCompanion data) {
    return PaymentCardData(
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      network: data.network.present ? data.network.value : this.network,
      maskedNumber: data.maskedNumber.present
          ? data.maskedNumber.value
          : this.maskedNumber,
      lastFour: data.lastFour.present ? data.lastFour.value : this.lastFour,
      cardholderName: data.cardholderName.present
          ? data.cardholderName.value
          : this.cardholderName,
      expiryMonthYear: data.expiryMonthYear.present
          ? data.expiryMonthYear.value
          : this.expiryMonthYear,
      colorGradientIndex: data.colorGradientIndex.present
          ? data.colorGradientIndex.value
          : this.colorGradientIndex,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCardData(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardType: $cardType, ')
          ..write('nickname: $nickname, ')
          ..write('network: $network, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('lastFour: $lastFour, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('expiryMonthYear: $expiryMonthYear, ')
          ..write('colorGradientIndex: $colorGradientIndex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankName,
    cardType,
    nickname,
    network,
    maskedNumber,
    lastFour,
    cardholderName,
    expiryMonthYear,
    colorGradientIndex,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentCardData &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.cardType == this.cardType &&
          other.nickname == this.nickname &&
          other.network == this.network &&
          other.maskedNumber == this.maskedNumber &&
          other.lastFour == this.lastFour &&
          other.cardholderName == this.cardholderName &&
          other.expiryMonthYear == this.expiryMonthYear &&
          other.colorGradientIndex == this.colorGradientIndex &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class PaymentCardsCompanion extends UpdateCompanion<PaymentCardData> {
  final Value<String> id;
  final Value<String> bankName;
  final Value<String> cardType;
  final Value<String?> nickname;
  final Value<String> network;
  final Value<String> maskedNumber;
  final Value<String> lastFour;
  final Value<String?> cardholderName;
  final Value<String?> expiryMonthYear;
  final Value<int> colorGradientIndex;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentCardsCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.cardType = const Value.absent(),
    this.nickname = const Value.absent(),
    this.network = const Value.absent(),
    this.maskedNumber = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.cardholderName = const Value.absent(),
    this.expiryMonthYear = const Value.absent(),
    this.colorGradientIndex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentCardsCompanion.insert({
    required String id,
    required String bankName,
    required String cardType,
    this.nickname = const Value.absent(),
    required String network,
    required String maskedNumber,
    required String lastFour,
    this.cardholderName = const Value.absent(),
    this.expiryMonthYear = const Value.absent(),
    this.colorGradientIndex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bankName = Value(bankName),
       cardType = Value(cardType),
       network = Value(network),
       maskedNumber = Value(maskedNumber),
       lastFour = Value(lastFour);
  static Insertable<PaymentCardData> custom({
    Expression<String>? id,
    Expression<String>? bankName,
    Expression<String>? cardType,
    Expression<String>? nickname,
    Expression<String>? network,
    Expression<String>? maskedNumber,
    Expression<String>? lastFour,
    Expression<String>? cardholderName,
    Expression<String>? expiryMonthYear,
    Expression<int>? colorGradientIndex,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (cardType != null) 'card_type': cardType,
      if (nickname != null) 'nickname': nickname,
      if (network != null) 'network': network,
      if (maskedNumber != null) 'masked_number': maskedNumber,
      if (lastFour != null) 'last_four': lastFour,
      if (cardholderName != null) 'cardholder_name': cardholderName,
      if (expiryMonthYear != null) 'expiry_month_year': expiryMonthYear,
      if (colorGradientIndex != null)
        'color_gradient_index': colorGradientIndex,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? bankName,
    Value<String>? cardType,
    Value<String?>? nickname,
    Value<String>? network,
    Value<String>? maskedNumber,
    Value<String>? lastFour,
    Value<String?>? cardholderName,
    Value<String?>? expiryMonthYear,
    Value<int>? colorGradientIndex,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentCardsCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      cardType: cardType ?? this.cardType,
      nickname: nickname ?? this.nickname,
      network: network ?? this.network,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      lastFour: lastFour ?? this.lastFour,
      cardholderName: cardholderName ?? this.cardholderName,
      expiryMonthYear: expiryMonthYear ?? this.expiryMonthYear,
      colorGradientIndex: colorGradientIndex ?? this.colorGradientIndex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (maskedNumber.present) {
      map['masked_number'] = Variable<String>(maskedNumber.value);
    }
    if (lastFour.present) {
      map['last_four'] = Variable<String>(lastFour.value);
    }
    if (cardholderName.present) {
      map['cardholder_name'] = Variable<String>(cardholderName.value);
    }
    if (expiryMonthYear.present) {
      map['expiry_month_year'] = Variable<String>(expiryMonthYear.value);
    }
    if (colorGradientIndex.present) {
      map['color_gradient_index'] = Variable<int>(colorGradientIndex.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCardsCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardType: $cardType, ')
          ..write('nickname: $nickname, ')
          ..write('network: $network, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('lastFour: $lastFour, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('expiryMonthYear: $expiryMonthYear, ')
          ..write('colorGradientIndex: $colorGradientIndex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, colorHex, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isCustom;
  const CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorHex: Value(colorHex),
      isCustom: Value(isCustom),
    );
  }

  factory CategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<String>(colorHex),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  CategoryData copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    bool? isCustom,
  }) => CategoryData(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    isCustom: isCustom ?? this.isCustom,
  );
  CategoryData copyWithCompanion(CategoriesCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, colorHex, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.isCustom == this.isCustom);
}

class CategoriesCompanion extends UpdateCompanion<CategoryData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> colorHex;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required String colorHex,
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       colorHex = Value(colorHex);
  static Insertable<CategoryData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? colorHex,
    Value<bool>? isCustom,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentCardIdMeta = const VerificationMeta(
    'paymentCardId',
  );
  @override
  late final GeneratedColumn<String> paymentCardId = GeneratedColumn<String>(
    'payment_card_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES payment_cards(id) ON DELETE SET NULL',
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES categories(id) ON DELETE SET NULL',
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DEBIT'),
  );
  static const VerificationMeta _matchStatusMeta = const VerificationMeta(
    'matchStatus',
  );
  @override
  late final GeneratedColumn<String> matchStatus = GeneratedColumn<String>(
    'match_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CONFIRMED'),
  );
  static const VerificationMeta _dedupeFingerprintMeta = const VerificationMeta(
    'dedupeFingerprint',
  );
  @override
  late final GeneratedColumn<String> dedupeFingerprint =
      GeneratedColumn<String>(
        'dedupe_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _sourceAppMeta = const VerificationMeta(
    'sourceApp',
  );
  @override
  late final GeneratedColumn<String> sourceApp = GeneratedColumn<String>(
    'source_app',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawNotificationTextMeta =
      const VerificationMeta('rawNotificationText');
  @override
  late final GeneratedColumn<String> rawNotificationText =
      GeneratedColumn<String>(
        'raw_notification_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentCardId,
    categoryId,
    amountPaise,
    currency,
    merchant,
    description,
    transactionType,
    matchStatus,
    dedupeFingerprint,
    sourceApp,
    rawNotificationText,
    occurredAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_card_id')) {
      context.handle(
        _paymentCardIdMeta,
        paymentCardId.isAcceptableOrUnknown(
          data['payment_card_id']!,
          _paymentCardIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    }
    if (data.containsKey('match_status')) {
      context.handle(
        _matchStatusMeta,
        matchStatus.isAcceptableOrUnknown(
          data['match_status']!,
          _matchStatusMeta,
        ),
      );
    }
    if (data.containsKey('dedupe_fingerprint')) {
      context.handle(
        _dedupeFingerprintMeta,
        dedupeFingerprint.isAcceptableOrUnknown(
          data['dedupe_fingerprint']!,
          _dedupeFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dedupeFingerprintMeta);
    }
    if (data.containsKey('source_app')) {
      context.handle(
        _sourceAppMeta,
        sourceApp.isAcceptableOrUnknown(data['source_app']!, _sourceAppMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceAppMeta);
    }
    if (data.containsKey('raw_notification_text')) {
      context.handle(
        _rawNotificationTextMeta,
        rawNotificationText.isAcceptableOrUnknown(
          data['raw_notification_text']!,
          _rawNotificationTextMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_card_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      matchStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_status'],
      )!,
      dedupeFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_fingerprint'],
      )!,
      sourceApp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_app'],
      )!,
      rawNotificationText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_notification_text'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionData extends DataClass implements Insertable<TransactionData> {
  final String id;
  final String? paymentCardId;
  final String? categoryId;
  final int amountPaise;
  final String currency;
  final String merchant;
  final String? description;
  final String transactionType;
  final String matchStatus;
  final String dedupeFingerprint;
  final String sourceApp;
  final String? rawNotificationText;
  final DateTime occurredAt;
  final DateTime createdAt;
  const TransactionData({
    required this.id,
    this.paymentCardId,
    this.categoryId,
    required this.amountPaise,
    required this.currency,
    required this.merchant,
    this.description,
    required this.transactionType,
    required this.matchStatus,
    required this.dedupeFingerprint,
    required this.sourceApp,
    this.rawNotificationText,
    required this.occurredAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || paymentCardId != null) {
      map['payment_card_id'] = Variable<String>(paymentCardId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_paise'] = Variable<int>(amountPaise);
    map['currency'] = Variable<String>(currency);
    map['merchant'] = Variable<String>(merchant);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['match_status'] = Variable<String>(matchStatus);
    map['dedupe_fingerprint'] = Variable<String>(dedupeFingerprint);
    map['source_app'] = Variable<String>(sourceApp);
    if (!nullToAbsent || rawNotificationText != null) {
      map['raw_notification_text'] = Variable<String>(rawNotificationText);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      paymentCardId: paymentCardId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentCardId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountPaise: Value(amountPaise),
      currency: Value(currency),
      merchant: Value(merchant),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionType: Value(transactionType),
      matchStatus: Value(matchStatus),
      dedupeFingerprint: Value(dedupeFingerprint),
      sourceApp: Value(sourceApp),
      rawNotificationText: rawNotificationText == null && nullToAbsent
          ? const Value.absent()
          : Value(rawNotificationText),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionData(
      id: serializer.fromJson<String>(json['id']),
      paymentCardId: serializer.fromJson<String?>(json['paymentCardId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      currency: serializer.fromJson<String>(json['currency']),
      merchant: serializer.fromJson<String>(json['merchant']),
      description: serializer.fromJson<String?>(json['description']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      matchStatus: serializer.fromJson<String>(json['matchStatus']),
      dedupeFingerprint: serializer.fromJson<String>(json['dedupeFingerprint']),
      sourceApp: serializer.fromJson<String>(json['sourceApp']),
      rawNotificationText: serializer.fromJson<String?>(
        json['rawNotificationText'],
      ),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentCardId': serializer.toJson<String?>(paymentCardId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'currency': serializer.toJson<String>(currency),
      'merchant': serializer.toJson<String>(merchant),
      'description': serializer.toJson<String?>(description),
      'transactionType': serializer.toJson<String>(transactionType),
      'matchStatus': serializer.toJson<String>(matchStatus),
      'dedupeFingerprint': serializer.toJson<String>(dedupeFingerprint),
      'sourceApp': serializer.toJson<String>(sourceApp),
      'rawNotificationText': serializer.toJson<String?>(rawNotificationText),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionData copyWith({
    String? id,
    Value<String?> paymentCardId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    int? amountPaise,
    String? currency,
    String? merchant,
    Value<String?> description = const Value.absent(),
    String? transactionType,
    String? matchStatus,
    String? dedupeFingerprint,
    String? sourceApp,
    Value<String?> rawNotificationText = const Value.absent(),
    DateTime? occurredAt,
    DateTime? createdAt,
  }) => TransactionData(
    id: id ?? this.id,
    paymentCardId: paymentCardId.present
        ? paymentCardId.value
        : this.paymentCardId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountPaise: amountPaise ?? this.amountPaise,
    currency: currency ?? this.currency,
    merchant: merchant ?? this.merchant,
    description: description.present ? description.value : this.description,
    transactionType: transactionType ?? this.transactionType,
    matchStatus: matchStatus ?? this.matchStatus,
    dedupeFingerprint: dedupeFingerprint ?? this.dedupeFingerprint,
    sourceApp: sourceApp ?? this.sourceApp,
    rawNotificationText: rawNotificationText.present
        ? rawNotificationText.value
        : this.rawNotificationText,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionData copyWithCompanion(TransactionsCompanion data) {
    return TransactionData(
      id: data.id.present ? data.id.value : this.id,
      paymentCardId: data.paymentCardId.present
          ? data.paymentCardId.value
          : this.paymentCardId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      currency: data.currency.present ? data.currency.value : this.currency,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      description: data.description.present
          ? data.description.value
          : this.description,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      matchStatus: data.matchStatus.present
          ? data.matchStatus.value
          : this.matchStatus,
      dedupeFingerprint: data.dedupeFingerprint.present
          ? data.dedupeFingerprint.value
          : this.dedupeFingerprint,
      sourceApp: data.sourceApp.present ? data.sourceApp.value : this.sourceApp,
      rawNotificationText: data.rawNotificationText.present
          ? data.rawNotificationText.value
          : this.rawNotificationText,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionData(')
          ..write('id: $id, ')
          ..write('paymentCardId: $paymentCardId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('transactionType: $transactionType, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('dedupeFingerprint: $dedupeFingerprint, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('rawNotificationText: $rawNotificationText, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    paymentCardId,
    categoryId,
    amountPaise,
    currency,
    merchant,
    description,
    transactionType,
    matchStatus,
    dedupeFingerprint,
    sourceApp,
    rawNotificationText,
    occurredAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionData &&
          other.id == this.id &&
          other.paymentCardId == this.paymentCardId &&
          other.categoryId == this.categoryId &&
          other.amountPaise == this.amountPaise &&
          other.currency == this.currency &&
          other.merchant == this.merchant &&
          other.description == this.description &&
          other.transactionType == this.transactionType &&
          other.matchStatus == this.matchStatus &&
          other.dedupeFingerprint == this.dedupeFingerprint &&
          other.sourceApp == this.sourceApp &&
          other.rawNotificationText == this.rawNotificationText &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionData> {
  final Value<String> id;
  final Value<String?> paymentCardId;
  final Value<String?> categoryId;
  final Value<int> amountPaise;
  final Value<String> currency;
  final Value<String> merchant;
  final Value<String?> description;
  final Value<String> transactionType;
  final Value<String> matchStatus;
  final Value<String> dedupeFingerprint;
  final Value<String> sourceApp;
  final Value<String?> rawNotificationText;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.paymentCardId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.currency = const Value.absent(),
    this.merchant = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.matchStatus = const Value.absent(),
    this.dedupeFingerprint = const Value.absent(),
    this.sourceApp = const Value.absent(),
    this.rawNotificationText = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.paymentCardId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int amountPaise,
    this.currency = const Value.absent(),
    required String merchant,
    this.description = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.matchStatus = const Value.absent(),
    required String dedupeFingerprint,
    required String sourceApp,
    this.rawNotificationText = const Value.absent(),
    required DateTime occurredAt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountPaise = Value(amountPaise),
       merchant = Value(merchant),
       dedupeFingerprint = Value(dedupeFingerprint),
       sourceApp = Value(sourceApp),
       occurredAt = Value(occurredAt);
  static Insertable<TransactionData> custom({
    Expression<String>? id,
    Expression<String>? paymentCardId,
    Expression<String>? categoryId,
    Expression<int>? amountPaise,
    Expression<String>? currency,
    Expression<String>? merchant,
    Expression<String>? description,
    Expression<String>? transactionType,
    Expression<String>? matchStatus,
    Expression<String>? dedupeFingerprint,
    Expression<String>? sourceApp,
    Expression<String>? rawNotificationText,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentCardId != null) 'payment_card_id': paymentCardId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (currency != null) 'currency': currency,
      if (merchant != null) 'merchant': merchant,
      if (description != null) 'description': description,
      if (transactionType != null) 'transaction_type': transactionType,
      if (matchStatus != null) 'match_status': matchStatus,
      if (dedupeFingerprint != null) 'dedupe_fingerprint': dedupeFingerprint,
      if (sourceApp != null) 'source_app': sourceApp,
      if (rawNotificationText != null)
        'raw_notification_text': rawNotificationText,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? paymentCardId,
    Value<String?>? categoryId,
    Value<int>? amountPaise,
    Value<String>? currency,
    Value<String>? merchant,
    Value<String?>? description,
    Value<String>? transactionType,
    Value<String>? matchStatus,
    Value<String>? dedupeFingerprint,
    Value<String>? sourceApp,
    Value<String?>? rawNotificationText,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      paymentCardId: paymentCardId ?? this.paymentCardId,
      categoryId: categoryId ?? this.categoryId,
      amountPaise: amountPaise ?? this.amountPaise,
      currency: currency ?? this.currency,
      merchant: merchant ?? this.merchant,
      description: description ?? this.description,
      transactionType: transactionType ?? this.transactionType,
      matchStatus: matchStatus ?? this.matchStatus,
      dedupeFingerprint: dedupeFingerprint ?? this.dedupeFingerprint,
      sourceApp: sourceApp ?? this.sourceApp,
      rawNotificationText: rawNotificationText ?? this.rawNotificationText,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentCardId.present) {
      map['payment_card_id'] = Variable<String>(paymentCardId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (matchStatus.present) {
      map['match_status'] = Variable<String>(matchStatus.value);
    }
    if (dedupeFingerprint.present) {
      map['dedupe_fingerprint'] = Variable<String>(dedupeFingerprint.value);
    }
    if (sourceApp.present) {
      map['source_app'] = Variable<String>(sourceApp.value);
    }
    if (rawNotificationText.present) {
      map['raw_notification_text'] = Variable<String>(
        rawNotificationText.value,
      );
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('paymentCardId: $paymentCardId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('transactionType: $transactionType, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('dedupeFingerprint: $dedupeFingerprint, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('rawNotificationText: $rawNotificationText, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MONTHLY'),
  );
  static const VerificationMeta _amountLimitPaiseMeta = const VerificationMeta(
    'amountLimitPaise',
  );
  @override
  late final GeneratedColumn<int> amountLimitPaise = GeneratedColumn<int>(
    'amount_limit_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeTypeMeta = const VerificationMeta(
    'scopeType',
  );
  @override
  late final GeneratedColumn<String> scopeType = GeneratedColumn<String>(
    'scope_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OVERALL'),
  );
  static const VerificationMeta _scopeIdMeta = const VerificationMeta(
    'scopeId',
  );
  @override
  late final GeneratedColumn<String> scopeId = GeneratedColumn<String>(
    'scope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    period,
    amountLimitPaise,
    scopeType,
    scopeId,
    startDate,
    endDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('amount_limit_paise')) {
      context.handle(
        _amountLimitPaiseMeta,
        amountLimitPaise.isAcceptableOrUnknown(
          data['amount_limit_paise']!,
          _amountLimitPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountLimitPaiseMeta);
    }
    if (data.containsKey('scope_type')) {
      context.handle(
        _scopeTypeMeta,
        scopeType.isAcceptableOrUnknown(data['scope_type']!, _scopeTypeMeta),
      );
    }
    if (data.containsKey('scope_id')) {
      context.handle(
        _scopeIdMeta,
        scopeId.isAcceptableOrUnknown(data['scope_id']!, _scopeIdMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      amountLimitPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_limit_paise'],
      )!,
      scopeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_type'],
      )!,
      scopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_id'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetData extends DataClass implements Insertable<BudgetData> {
  final String id;
  final String name;
  final String period;
  final int amountLimitPaise;
  final String scopeType;
  final String? scopeId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  const BudgetData({
    required this.id,
    required this.name,
    required this.period,
    required this.amountLimitPaise,
    required this.scopeType,
    this.scopeId,
    this.startDate,
    this.endDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['period'] = Variable<String>(period);
    map['amount_limit_paise'] = Variable<int>(amountLimitPaise);
    map['scope_type'] = Variable<String>(scopeType);
    if (!nullToAbsent || scopeId != null) {
      map['scope_id'] = Variable<String>(scopeId);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      name: Value(name),
      period: Value(period),
      amountLimitPaise: Value(amountLimitPaise),
      scopeType: Value(scopeType),
      scopeId: scopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(scopeId),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      period: serializer.fromJson<String>(json['period']),
      amountLimitPaise: serializer.fromJson<int>(json['amountLimitPaise']),
      scopeType: serializer.fromJson<String>(json['scopeType']),
      scopeId: serializer.fromJson<String?>(json['scopeId']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'period': serializer.toJson<String>(period),
      'amountLimitPaise': serializer.toJson<int>(amountLimitPaise),
      'scopeType': serializer.toJson<String>(scopeType),
      'scopeId': serializer.toJson<String?>(scopeId),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetData copyWith({
    String? id,
    String? name,
    String? period,
    int? amountLimitPaise,
    String? scopeType,
    Value<String?> scopeId = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    DateTime? createdAt,
  }) => BudgetData(
    id: id ?? this.id,
    name: name ?? this.name,
    period: period ?? this.period,
    amountLimitPaise: amountLimitPaise ?? this.amountLimitPaise,
    scopeType: scopeType ?? this.scopeType,
    scopeId: scopeId.present ? scopeId.value : this.scopeId,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetData copyWithCompanion(BudgetsCompanion data) {
    return BudgetData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      period: data.period.present ? data.period.value : this.period,
      amountLimitPaise: data.amountLimitPaise.present
          ? data.amountLimitPaise.value
          : this.amountLimitPaise,
      scopeType: data.scopeType.present ? data.scopeType.value : this.scopeType,
      scopeId: data.scopeId.present ? data.scopeId.value : this.scopeId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('period: $period, ')
          ..write('amountLimitPaise: $amountLimitPaise, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    period,
    amountLimitPaise,
    scopeType,
    scopeId,
    startDate,
    endDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetData &&
          other.id == this.id &&
          other.name == this.name &&
          other.period == this.period &&
          other.amountLimitPaise == this.amountLimitPaise &&
          other.scopeType == this.scopeType &&
          other.scopeId == this.scopeId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> period;
  final Value<int> amountLimitPaise;
  final Value<String> scopeType;
  final Value<String?> scopeId;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.period = const Value.absent(),
    this.amountLimitPaise = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String name,
    this.period = const Value.absent(),
    required int amountLimitPaise,
    this.scopeType = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amountLimitPaise = Value(amountLimitPaise);
  static Insertable<BudgetData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? period,
    Expression<int>? amountLimitPaise,
    Expression<String>? scopeType,
    Expression<String>? scopeId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (period != null) 'period': period,
      if (amountLimitPaise != null) 'amount_limit_paise': amountLimitPaise,
      if (scopeType != null) 'scope_type': scopeType,
      if (scopeId != null) 'scope_id': scopeId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? period,
    Value<int>? amountLimitPaise,
    Value<String>? scopeType,
    Value<String?>? scopeId,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      period: period ?? this.period,
      amountLimitPaise: amountLimitPaise ?? this.amountLimitPaise,
      scopeType: scopeType ?? this.scopeType,
      scopeId: scopeId ?? this.scopeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (amountLimitPaise.present) {
      map['amount_limit_paise'] = Variable<int>(amountLimitPaise.value);
    }
    if (scopeType.present) {
      map['scope_type'] = Variable<String>(scopeType.value);
    }
    if (scopeId.present) {
      map['scope_id'] = Variable<String>(scopeId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('period: $period, ')
          ..write('amountLimitPaise: $amountLimitPaise, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationSourcesTable extends NotificationSources
    with TableInfo<$NotificationSourcesTable, NotificationSourceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _parserVersionMeta = const VerificationMeta(
    'parserVersion',
  );
  @override
  late final GeneratedColumn<String> parserVersion = GeneratedColumn<String>(
    'parser_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0.0'),
  );
  static const VerificationMeta _lastProcessedAtMeta = const VerificationMeta(
    'lastProcessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastProcessedAt =
      GeneratedColumn<DateTime>(
        'last_processed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    packageName,
    displayName,
    isEnabled,
    parserVersion,
    lastProcessedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationSourceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('parser_version')) {
      context.handle(
        _parserVersionMeta,
        parserVersion.isAcceptableOrUnknown(
          data['parser_version']!,
          _parserVersionMeta,
        ),
      );
    }
    if (data.containsKey('last_processed_at')) {
      context.handle(
        _lastProcessedAtMeta,
        lastProcessedAt.isAcceptableOrUnknown(
          data['last_processed_at']!,
          _lastProcessedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  NotificationSourceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSourceData(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      parserVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_version'],
      )!,
      lastProcessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_processed_at'],
      ),
    );
  }

  @override
  $NotificationSourcesTable createAlias(String alias) {
    return $NotificationSourcesTable(attachedDatabase, alias);
  }
}

class NotificationSourceData extends DataClass
    implements Insertable<NotificationSourceData> {
  final String packageName;
  final String displayName;
  final bool isEnabled;
  final String parserVersion;
  final DateTime? lastProcessedAt;
  const NotificationSourceData({
    required this.packageName,
    required this.displayName,
    required this.isEnabled,
    required this.parserVersion,
    this.lastProcessedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['display_name'] = Variable<String>(displayName);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['parser_version'] = Variable<String>(parserVersion);
    if (!nullToAbsent || lastProcessedAt != null) {
      map['last_processed_at'] = Variable<DateTime>(lastProcessedAt);
    }
    return map;
  }

  NotificationSourcesCompanion toCompanion(bool nullToAbsent) {
    return NotificationSourcesCompanion(
      packageName: Value(packageName),
      displayName: Value(displayName),
      isEnabled: Value(isEnabled),
      parserVersion: Value(parserVersion),
      lastProcessedAt: lastProcessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProcessedAt),
    );
  }

  factory NotificationSourceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSourceData(
      packageName: serializer.fromJson<String>(json['packageName']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      parserVersion: serializer.fromJson<String>(json['parserVersion']),
      lastProcessedAt: serializer.fromJson<DateTime?>(json['lastProcessedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'displayName': serializer.toJson<String>(displayName),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'parserVersion': serializer.toJson<String>(parserVersion),
      'lastProcessedAt': serializer.toJson<DateTime?>(lastProcessedAt),
    };
  }

  NotificationSourceData copyWith({
    String? packageName,
    String? displayName,
    bool? isEnabled,
    String? parserVersion,
    Value<DateTime?> lastProcessedAt = const Value.absent(),
  }) => NotificationSourceData(
    packageName: packageName ?? this.packageName,
    displayName: displayName ?? this.displayName,
    isEnabled: isEnabled ?? this.isEnabled,
    parserVersion: parserVersion ?? this.parserVersion,
    lastProcessedAt: lastProcessedAt.present
        ? lastProcessedAt.value
        : this.lastProcessedAt,
  );
  NotificationSourceData copyWithCompanion(NotificationSourcesCompanion data) {
    return NotificationSourceData(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      lastProcessedAt: data.lastProcessedAt.present
          ? data.lastProcessedAt.value
          : this.lastProcessedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSourceData(')
          ..write('packageName: $packageName, ')
          ..write('displayName: $displayName, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('lastProcessedAt: $lastProcessedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packageName,
    displayName,
    isEnabled,
    parserVersion,
    lastProcessedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSourceData &&
          other.packageName == this.packageName &&
          other.displayName == this.displayName &&
          other.isEnabled == this.isEnabled &&
          other.parserVersion == this.parserVersion &&
          other.lastProcessedAt == this.lastProcessedAt);
}

class NotificationSourcesCompanion
    extends UpdateCompanion<NotificationSourceData> {
  final Value<String> packageName;
  final Value<String> displayName;
  final Value<bool> isEnabled;
  final Value<String> parserVersion;
  final Value<DateTime?> lastProcessedAt;
  final Value<int> rowid;
  const NotificationSourcesCompanion({
    this.packageName = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.lastProcessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationSourcesCompanion.insert({
    required String packageName,
    required String displayName,
    this.isEnabled = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.lastProcessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       displayName = Value(displayName);
  static Insertable<NotificationSourceData> custom({
    Expression<String>? packageName,
    Expression<String>? displayName,
    Expression<bool>? isEnabled,
    Expression<String>? parserVersion,
    Expression<DateTime>? lastProcessedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (displayName != null) 'display_name': displayName,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (lastProcessedAt != null) 'last_processed_at': lastProcessedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationSourcesCompanion copyWith({
    Value<String>? packageName,
    Value<String>? displayName,
    Value<bool>? isEnabled,
    Value<String>? parserVersion,
    Value<DateTime?>? lastProcessedAt,
    Value<int>? rowid,
  }) {
    return NotificationSourcesCompanion(
      packageName: packageName ?? this.packageName,
      displayName: displayName ?? this.displayName,
      isEnabled: isEnabled ?? this.isEnabled,
      parserVersion: parserVersion ?? this.parserVersion,
      lastProcessedAt: lastProcessedAt ?? this.lastProcessedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<String>(parserVersion.value);
    }
    if (lastProcessedAt.present) {
      map['last_processed_at'] = Variable<DateTime>(lastProcessedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSourcesCompanion(')
          ..write('packageName: $packageName, ')
          ..write('displayName: $displayName, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('lastProcessedAt: $lastProcessedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PaymentCardsTable paymentCards = $PaymentCardsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $NotificationSourcesTable notificationSources =
      $NotificationSourcesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    paymentCards,
    categories,
    transactions,
    budgets,
    notificationSources,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$PaymentCardsTableCreateCompanionBuilder =
    PaymentCardsCompanion Function({
      required String id,
      required String bankName,
      required String cardType,
      Value<String?> nickname,
      required String network,
      required String maskedNumber,
      required String lastFour,
      Value<String?> cardholderName,
      Value<String?> expiryMonthYear,
      Value<int> colorGradientIndex,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PaymentCardsTableUpdateCompanionBuilder =
    PaymentCardsCompanion Function({
      Value<String> id,
      Value<String> bankName,
      Value<String> cardType,
      Value<String?> nickname,
      Value<String> network,
      Value<String> maskedNumber,
      Value<String> lastFour,
      Value<String?> cardholderName,
      Value<String?> expiryMonthYear,
      Value<int> colorGradientIndex,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PaymentCardsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentCardsTable, PaymentCardData> {
  $$PaymentCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionData>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'payment_cards__id__transactions__payment_card_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.paymentCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentCardsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryMonthYear => $composableBuilder(
    column: $table.expiryMonthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorGradientIndex => $composableBuilder(
    column: $table.colorGradientIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryMonthYear => $composableBuilder(
    column: $table.expiryMonthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorGradientIndex => $composableBuilder(
    column: $table.colorGradientIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastFour =>
      $composableBuilder(column: $table.lastFour, builder: (column) => column);

  GeneratedColumn<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryMonthYear => $composableBuilder(
    column: $table.expiryMonthYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorGradientIndex => $composableBuilder(
    column: $table.colorGradientIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentCardsTable,
          PaymentCardData,
          $$PaymentCardsTableFilterComposer,
          $$PaymentCardsTableOrderingComposer,
          $$PaymentCardsTableAnnotationComposer,
          $$PaymentCardsTableCreateCompanionBuilder,
          $$PaymentCardsTableUpdateCompanionBuilder,
          (PaymentCardData, $$PaymentCardsTableReferences),
          PaymentCardData,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$PaymentCardsTableTableManager(_$AppDatabase db, $PaymentCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> cardType = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<String> maskedNumber = const Value.absent(),
                Value<String> lastFour = const Value.absent(),
                Value<String?> cardholderName = const Value.absent(),
                Value<String?> expiryMonthYear = const Value.absent(),
                Value<int> colorGradientIndex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentCardsCompanion(
                id: id,
                bankName: bankName,
                cardType: cardType,
                nickname: nickname,
                network: network,
                maskedNumber: maskedNumber,
                lastFour: lastFour,
                cardholderName: cardholderName,
                expiryMonthYear: expiryMonthYear,
                colorGradientIndex: colorGradientIndex,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bankName,
                required String cardType,
                Value<String?> nickname = const Value.absent(),
                required String network,
                required String maskedNumber,
                required String lastFour,
                Value<String?> cardholderName = const Value.absent(),
                Value<String?> expiryMonthYear = const Value.absent(),
                Value<int> colorGradientIndex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentCardsCompanion.insert(
                id: id,
                bankName: bankName,
                cardType: cardType,
                nickname: nickname,
                network: network,
                maskedNumber: maskedNumber,
                lastFour: lastFour,
                cardholderName: cardholderName,
                expiryMonthYear: expiryMonthYear,
                colorGradientIndex: colorGradientIndex,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentCardsTable, PaymentCardData>(table),
                  $$PaymentCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedDataByColumns<
                      PaymentCardData,
                      $PaymentCardsTable,
                      TransactionData,
                      $TransactionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$PaymentCardsTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PaymentCardsTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'payment_card_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PaymentCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentCardsTable,
      PaymentCardData,
      $$PaymentCardsTableFilterComposer,
      $$PaymentCardsTableOrderingComposer,
      $$PaymentCardsTableAnnotationComposer,
      $$PaymentCardsTableCreateCompanionBuilder,
      $$PaymentCardsTableUpdateCompanionBuilder,
      (PaymentCardData, $$PaymentCardsTableReferences),
      PaymentCardData,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  required String icon,
  required String colorHex,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<String> colorHex,
  Value<bool> isCustom,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryData> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionData>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryData,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryData, $$CategoriesTableReferences),
          CategoryData,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required String colorHex,
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryData>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedDataByColumns<
                      CategoryData,
                      $CategoriesTable,
                      TransactionData,
                      $TransactionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'category_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryData,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryData, $$CategoriesTableReferences),
      CategoryData,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> paymentCardId,
      Value<String?> categoryId,
      required int amountPaise,
      Value<String> currency,
      required String merchant,
      Value<String?> description,
      Value<String> transactionType,
      Value<String> matchStatus,
      required String dedupeFingerprint,
      required String sourceApp,
      Value<String?> rawNotificationText,
      required DateTime occurredAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> paymentCardId,
      Value<String?> categoryId,
      Value<int> amountPaise,
      Value<String> currency,
      Value<String> merchant,
      Value<String?> description,
      Value<String> transactionType,
      Value<String> matchStatus,
      Value<String> dedupeFingerprint,
      Value<String> sourceApp,
      Value<String?> rawNotificationText,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TransactionData> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PaymentCardsTable _paymentCardIdTable(_$AppDatabase db) => db
      .paymentCards
      .createAlias('transactions__payment_card_id__payment_cards__id');

  $$PaymentCardsTableProcessedTableManager? get paymentCardId {
    final $_column = $_itemColumn<String>('payment_card_id');
    if ($_column == null) return null;
    final manager = $$PaymentCardsTableTableManager(
      $_db,
      $_db.paymentCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeFingerprint => $composableBuilder(
    column: $table.dedupeFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawNotificationText => $composableBuilder(
    column: $table.rawNotificationText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PaymentCardsTableFilterComposer get paymentCardId {
    final $$PaymentCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentCardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableFilterComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeFingerprint => $composableBuilder(
    column: $table.dedupeFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawNotificationText => $composableBuilder(
    column: $table.rawNotificationText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PaymentCardsTableOrderingComposer get paymentCardId {
    final $$PaymentCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentCardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dedupeFingerprint => $composableBuilder(
    column: $table.dedupeFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceApp =>
      $composableBuilder(column: $table.sourceApp, builder: (column) => column);

  GeneratedColumn<String> get rawNotificationText => $composableBuilder(
    column: $table.rawNotificationText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PaymentCardsTableAnnotationComposer get paymentCardId {
    final $$PaymentCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentCardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionData,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionData, $$TransactionsTableReferences),
          TransactionData,
          PrefetchHooks Function({bool paymentCardId, bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> paymentCardId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String> matchStatus = const Value.absent(),
                Value<String> dedupeFingerprint = const Value.absent(),
                Value<String> sourceApp = const Value.absent(),
                Value<String?> rawNotificationText = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                paymentCardId: paymentCardId,
                categoryId: categoryId,
                amountPaise: amountPaise,
                currency: currency,
                merchant: merchant,
                description: description,
                transactionType: transactionType,
                matchStatus: matchStatus,
                dedupeFingerprint: dedupeFingerprint,
                sourceApp: sourceApp,
                rawNotificationText: rawNotificationText,
                occurredAt: occurredAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> paymentCardId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required int amountPaise,
                Value<String> currency = const Value.absent(),
                required String merchant,
                Value<String?> description = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String> matchStatus = const Value.absent(),
                required String dedupeFingerprint,
                required String sourceApp,
                Value<String?> rawNotificationText = const Value.absent(),
                required DateTime occurredAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                paymentCardId: paymentCardId,
                categoryId: categoryId,
                amountPaise: amountPaise,
                currency: currency,
                merchant: merchant,
                description: description,
                transactionType: transactionType,
                matchStatus: matchStatus,
                dedupeFingerprint: dedupeFingerprint,
                sourceApp: sourceApp,
                rawNotificationText: rawNotificationText,
                occurredAt: occurredAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionData>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({paymentCardId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (paymentCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.paymentCardId,
                        referencedTable: $$TransactionsTableReferences
                            ._paymentCardIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._paymentCardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$TransactionsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionData,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionData, $$TransactionsTableReferences),
      TransactionData,
      PrefetchHooks Function({bool paymentCardId, bool categoryId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required String name,
  Value<String> period,
  required int amountLimitPaise,
  Value<String> scopeType,
  Value<String?> scopeId,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> period,
  Value<int> amountLimitPaise,
  Value<String> scopeType,
  Value<String?> scopeId,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountLimitPaise => $composableBuilder(
    column: $table.amountLimitPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountLimitPaise => $composableBuilder(
    column: $table.amountLimitPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get amountLimitPaise => $composableBuilder(
    column: $table.amountLimitPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scopeType =>
      $composableBuilder(column: $table.scopeType, builder: (column) => column);

  GeneratedColumn<String> get scopeId =>
      $composableBuilder(column: $table.scopeId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetData,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (
            BudgetData,
            BaseReferences<_$AppDatabase, $BudgetsTable, BudgetData>,
          ),
          BudgetData,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> amountLimitPaise = const Value.absent(),
                Value<String> scopeType = const Value.absent(),
                Value<String?> scopeId = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                name: name,
                period: period,
                amountLimitPaise: amountLimitPaise,
                scopeType: scopeType,
                scopeId: scopeId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> period = const Value.absent(),
                required int amountLimitPaise,
                Value<String> scopeType = const Value.absent(),
                Value<String?> scopeId = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                name: name,
                period: period,
                amountLimitPaise: amountLimitPaise,
                scopeType: scopeType,
                scopeId: scopeId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetData>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetData>(
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

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetData,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetData, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetData>),
      BudgetData,
      PrefetchHooks Function()
    >;
typedef $$NotificationSourcesTableCreateCompanionBuilder =
    NotificationSourcesCompanion Function({
      required String packageName,
      required String displayName,
      Value<bool> isEnabled,
      Value<String> parserVersion,
      Value<DateTime?> lastProcessedAt,
      Value<int> rowid,
    });
typedef $$NotificationSourcesTableUpdateCompanionBuilder =
    NotificationSourcesCompanion Function({
      Value<String> packageName,
      Value<String> displayName,
      Value<bool> isEnabled,
      Value<String> parserVersion,
      Value<DateTime?> lastProcessedAt,
      Value<int> rowid,
    });

class $$NotificationSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSourcesTable> {
  $$NotificationSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSourcesTable> {
  $$NotificationSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSourcesTable> {
  $$NotificationSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => column,
  );
}

class $$NotificationSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationSourcesTable,
          NotificationSourceData,
          $$NotificationSourcesTableFilterComposer,
          $$NotificationSourcesTableOrderingComposer,
          $$NotificationSourcesTableAnnotationComposer,
          $$NotificationSourcesTableCreateCompanionBuilder,
          $$NotificationSourcesTableUpdateCompanionBuilder,
          (
            NotificationSourceData,
            BaseReferences<
              _$AppDatabase,
              $NotificationSourcesTable,
              NotificationSourceData
            >,
          ),
          NotificationSourceData,
          PrefetchHooks Function()
        > {
  $$NotificationSourcesTableTableManager(
    _$AppDatabase db,
    $NotificationSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationSourcesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String> parserVersion = const Value.absent(),
                Value<DateTime?> lastProcessedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSourcesCompanion(
                packageName: packageName,
                displayName: displayName,
                isEnabled: isEnabled,
                parserVersion: parserVersion,
                lastProcessedAt: lastProcessedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String displayName,
                Value<bool> isEnabled = const Value.absent(),
                Value<String> parserVersion = const Value.absent(),
                Value<DateTime?> lastProcessedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSourcesCompanion.insert(
                packageName: packageName,
                displayName: displayName,
                isEnabled: isEnabled,
                parserVersion: parserVersion,
                lastProcessedAt: lastProcessedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $NotificationSourcesTable,
                    NotificationSourceData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotificationSourcesTable,
                    NotificationSourceData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationSourcesTable,
      NotificationSourceData,
      $$NotificationSourcesTableFilterComposer,
      $$NotificationSourcesTableOrderingComposer,
      $$NotificationSourcesTableAnnotationComposer,
      $$NotificationSourcesTableCreateCompanionBuilder,
      $$NotificationSourcesTableUpdateCompanionBuilder,
      (
        NotificationSourceData,
        BaseReferences<
          _$AppDatabase,
          $NotificationSourcesTable,
          NotificationSourceData
        >,
      ),
      NotificationSourceData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PaymentCardsTableTableManager get paymentCards =>
      $$PaymentCardsTableTableManager(_db, _db.paymentCards);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$NotificationSourcesTableTableManager get notificationSources =>
      $$NotificationSourcesTableTableManager(_db, _db.notificationSources);
}
