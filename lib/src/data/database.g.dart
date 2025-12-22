// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientesTableTable extends ClientesTable
    with TableInfo<$ClientesTableTable, ClienteDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
      'odoo_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
      'street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _zipMeta = const VerificationMeta('zip');
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
      'zip', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryIdMeta =
      const VerificationMeta('countryId');
  @override
  late final GeneratedColumn<int> countryId = GeneratedColumn<int>(
      'country_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _hasPendingChangesMeta =
      const VerificationMeta('hasPendingChanges');
  @override
  late final GeneratedColumn<bool> hasPendingChanges = GeneratedColumn<bool>(
      'has_pending_changes', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_pending_changes" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        odooId,
        name,
        email,
        phone,
        mobile,
        street,
        city,
        zip,
        countryId,
        isSynced,
        hasPendingChanges,
        isDeleted,
        createdAt,
        updatedAt,
        lastSyncAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes_table';
  @override
  VerificationContext validateIntegrity(Insertable<ClienteDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('odoo_id')) {
      context.handle(_odooIdMeta,
          odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    }
    if (data.containsKey('street')) {
      context.handle(_streetMeta,
          street.isAcceptableOrUnknown(data['street']!, _streetMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('zip')) {
      context.handle(
          _zipMeta, zip.isAcceptableOrUnknown(data['zip']!, _zipMeta));
    }
    if (data.containsKey('country_id')) {
      context.handle(_countryIdMeta,
          countryId.isAcceptableOrUnknown(data['country_id']!, _countryIdMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('has_pending_changes')) {
      context.handle(
          _hasPendingChangesMeta,
          hasPendingChanges.isAcceptableOrUnknown(
              data['has_pending_changes']!, _hasPendingChangesMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      odooId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odoo_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile']),
      street: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}street']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      zip: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zip']),
      countryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}country_id']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      hasPendingChanges: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_pending_changes'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
    );
  }

  @override
  $ClientesTableTable createAlias(String alias) {
    return $ClientesTableTable(attachedDatabase, alias);
  }
}

class ClienteDb extends DataClass implements Insertable<ClienteDb> {
  final int id;
  final int? odooId;
  final String name;
  final String? email;
  final String? phone;
  final String? mobile;
  final String? street;
  final String? city;
  final String? zip;
  final int? countryId;
  final bool isSynced;
  final bool hasPendingChanges;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncAt;
  const ClienteDb(
      {required this.id,
      this.odooId,
      required this.name,
      this.email,
      this.phone,
      this.mobile,
      this.street,
      this.city,
      this.zip,
      this.countryId,
      required this.isSynced,
      required this.hasPendingChanges,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      this.lastSyncAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || zip != null) {
      map['zip'] = Variable<String>(zip);
    }
    if (!nullToAbsent || countryId != null) {
      map['country_id'] = Variable<int>(countryId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['has_pending_changes'] = Variable<bool>(hasPendingChanges);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  ClientesTableCompanion toCompanion(bool nullToAbsent) {
    return ClientesTableCompanion(
      id: Value(id),
      odooId:
          odooId == null && nullToAbsent ? const Value.absent() : Value(odooId),
      name: Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      street:
          street == null && nullToAbsent ? const Value.absent() : Value(street),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      zip: zip == null && nullToAbsent ? const Value.absent() : Value(zip),
      countryId: countryId == null && nullToAbsent
          ? const Value.absent()
          : Value(countryId),
      isSynced: Value(isSynced),
      hasPendingChanges: Value(hasPendingChanges),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory ClienteDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteDb(
      id: serializer.fromJson<int>(json['id']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      street: serializer.fromJson<String?>(json['street']),
      city: serializer.fromJson<String?>(json['city']),
      zip: serializer.fromJson<String?>(json['zip']),
      countryId: serializer.fromJson<int?>(json['countryId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      hasPendingChanges: serializer.fromJson<bool>(json['hasPendingChanges']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'mobile': serializer.toJson<String?>(mobile),
      'street': serializer.toJson<String?>(street),
      'city': serializer.toJson<String?>(city),
      'zip': serializer.toJson<String?>(zip),
      'countryId': serializer.toJson<int?>(countryId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'hasPendingChanges': serializer.toJson<bool>(hasPendingChanges),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  ClienteDb copyWith(
          {int? id,
          Value<int?> odooId = const Value.absent(),
          String? name,
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> mobile = const Value.absent(),
          Value<String?> street = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> zip = const Value.absent(),
          Value<int?> countryId = const Value.absent(),
          bool? isSynced,
          bool? hasPendingChanges,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastSyncAt = const Value.absent()}) =>
      ClienteDb(
        id: id ?? this.id,
        odooId: odooId.present ? odooId.value : this.odooId,
        name: name ?? this.name,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        mobile: mobile.present ? mobile.value : this.mobile,
        street: street.present ? street.value : this.street,
        city: city.present ? city.value : this.city,
        zip: zip.present ? zip.value : this.zip,
        countryId: countryId.present ? countryId.value : this.countryId,
        isSynced: isSynced ?? this.isSynced,
        hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
      );
  ClienteDb copyWithCompanion(ClientesTableCompanion data) {
    return ClienteDb(
      id: data.id.present ? data.id.value : this.id,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      street: data.street.present ? data.street.value : this.street,
      city: data.city.present ? data.city.value : this.city,
      zip: data.zip.present ? data.zip.value : this.zip,
      countryId: data.countryId.present ? data.countryId.value : this.countryId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      hasPendingChanges: data.hasPendingChanges.present
          ? data.hasPendingChanges.value
          : this.hasPendingChanges,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteDb(')
          ..write('id: $id, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('zip: $zip, ')
          ..write('countryId: $countryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('hasPendingChanges: $hasPendingChanges, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      odooId,
      name,
      email,
      phone,
      mobile,
      street,
      city,
      zip,
      countryId,
      isSynced,
      hasPendingChanges,
      isDeleted,
      createdAt,
      updatedAt,
      lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteDb &&
          other.id == this.id &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.mobile == this.mobile &&
          other.street == this.street &&
          other.city == this.city &&
          other.zip == this.zip &&
          other.countryId == this.countryId &&
          other.isSynced == this.isSynced &&
          other.hasPendingChanges == this.hasPendingChanges &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class ClientesTableCompanion extends UpdateCompanion<ClienteDb> {
  final Value<int> id;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> mobile;
  final Value<String?> street;
  final Value<String?> city;
  final Value<String?> zip;
  final Value<int?> countryId;
  final Value<bool> isSynced;
  final Value<bool> hasPendingChanges;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncAt;
  const ClientesTableCompanion({
    this.id = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.mobile = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.zip = const Value.absent(),
    this.countryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.hasPendingChanges = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  ClientesTableCompanion.insert({
    this.id = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.mobile = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.zip = const Value.absent(),
    this.countryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.hasPendingChanges = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ClienteDb> custom({
    Expression<int>? id,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? mobile,
    Expression<String>? street,
    Expression<String>? city,
    Expression<String>? zip,
    Expression<int>? countryId,
    Expression<bool>? isSynced,
    Expression<bool>? hasPendingChanges,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (mobile != null) 'mobile': mobile,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (zip != null) 'zip': zip,
      if (countryId != null) 'country_id': countryId,
      if (isSynced != null) 'is_synced': isSynced,
      if (hasPendingChanges != null) 'has_pending_changes': hasPendingChanges,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  ClientesTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? odooId,
      Value<String>? name,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String?>? mobile,
      Value<String?>? street,
      Value<String?>? city,
      Value<String?>? zip,
      Value<int?>? countryId,
      Value<bool>? isSynced,
      Value<bool>? hasPendingChanges,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastSyncAt}) {
    return ClientesTableCompanion(
      id: id ?? this.id,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      street: street ?? this.street,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      countryId: countryId ?? this.countryId,
      isSynced: isSynced ?? this.isSynced,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (zip.present) {
      map['zip'] = Variable<String>(zip.value);
    }
    if (countryId.present) {
      map['country_id'] = Variable<int>(countryId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (hasPendingChanges.present) {
      map['has_pending_changes'] = Variable<bool>(hasPendingChanges.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesTableCompanion(')
          ..write('id: $id, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('zip: $zip, ')
          ..write('countryId: $countryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('hasPendingChanges: $hasPendingChanges, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $SyncLogTableTable extends SyncLogTable
    with TableInfo<$SyncLogTableTable, SyncLogDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        status,
        errorMessage,
        createdAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_log_table';
  @override
  VerificationContext validateIntegrity(Insertable<SyncLogDb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLogDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $SyncLogTableTable createAlias(String alias) {
    return $SyncLogTableTable(attachedDatabase, alias);
  }
}

class SyncLogDb extends DataClass implements Insertable<SyncLogDb> {
  final int id;
  final String entityType;
  final int entityId;
  final String operation;
  final String status;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const SyncLogDb(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.status,
      this.errorMessage,
      required this.createdAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['operation'] = Variable<String>(operation);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncLogTableCompanion toCompanion(bool nullToAbsent) {
    return SyncLogTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncLogDb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogDb(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'operation': serializer.toJson<String>(operation),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncLogDb copyWith(
          {int? id,
          String? entityType,
          int? entityId,
          String? operation,
          String? status,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      SyncLogDb(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  SyncLogDb copyWithCompanion(SyncLogTableCompanion data) {
    return SyncLogDb(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogDb(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operation, status,
      errorMessage, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogDb &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class SyncLogTableCompanion extends UpdateCompanion<SyncLogDb> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> operation;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  const SyncLogTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  SyncLogTableCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityId,
    required String operation,
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation);
  static Insertable<SyncLogDb> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? operation,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  SyncLogTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<int>? entityId,
      Value<String>? operation,
      Value<String>? status,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<DateTime?>? syncedAt}) {
    return SyncLogTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTableTable clientesTable = $ClientesTableTable(this);
  late final $SyncLogTableTable syncLogTable = $SyncLogTableTable(this);
  late final ClientesDao clientesDao = ClientesDao(this as AppDatabase);
  late final SyncLogDao syncLogDao = SyncLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [clientesTable, syncLogTable];
}

typedef $$ClientesTableTableCreateCompanionBuilder = ClientesTableCompanion
    Function({
  Value<int> id,
  Value<int?> odooId,
  required String name,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> mobile,
  Value<String?> street,
  Value<String?> city,
  Value<String?> zip,
  Value<int?> countryId,
  Value<bool> isSynced,
  Value<bool> hasPendingChanges,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastSyncAt,
});
typedef $$ClientesTableTableUpdateCompanionBuilder = ClientesTableCompanion
    Function({
  Value<int> id,
  Value<int?> odooId,
  Value<String> name,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> mobile,
  Value<String?> street,
  Value<String?> city,
  Value<String?> zip,
  Value<int?> countryId,
  Value<bool> isSynced,
  Value<bool> hasPendingChanges,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastSyncAt,
});

class $$ClientesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odooId => $composableBuilder(
      column: $table.odooId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get street => $composableBuilder(
      column: $table.street, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get countryId => $composableBuilder(
      column: $table.countryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasPendingChanges => $composableBuilder(
      column: $table.hasPendingChanges,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));
}

class $$ClientesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odooId => $composableBuilder(
      column: $table.odooId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get street => $composableBuilder(
      column: $table.street, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get countryId => $composableBuilder(
      column: $table.countryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasPendingChanges => $composableBuilder(
      column: $table.hasPendingChanges,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));
}

class $$ClientesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get zip =>
      $composableBuilder(column: $table.zip, builder: (column) => column);

  GeneratedColumn<int> get countryId =>
      $composableBuilder(column: $table.countryId, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get hasPendingChanges => $composableBuilder(
      column: $table.hasPendingChanges, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);
}

class $$ClientesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientesTableTable,
    ClienteDb,
    $$ClientesTableTableFilterComposer,
    $$ClientesTableTableOrderingComposer,
    $$ClientesTableTableAnnotationComposer,
    $$ClientesTableTableCreateCompanionBuilder,
    $$ClientesTableTableUpdateCompanionBuilder,
    (ClienteDb, BaseReferences<_$AppDatabase, $ClientesTableTable, ClienteDb>),
    ClienteDb,
    PrefetchHooks Function()> {
  $$ClientesTableTableTableManager(_$AppDatabase db, $ClientesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> odooId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> street = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<int?> countryId = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> hasPendingChanges = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              ClientesTableCompanion(
            id: id,
            odooId: odooId,
            name: name,
            email: email,
            phone: phone,
            mobile: mobile,
            street: street,
            city: city,
            zip: zip,
            countryId: countryId,
            isSynced: isSynced,
            hasPendingChanges: hasPendingChanges,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncAt: lastSyncAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> odooId = const Value.absent(),
            required String name,
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> street = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<int?> countryId = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> hasPendingChanges = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              ClientesTableCompanion.insert(
            id: id,
            odooId: odooId,
            name: name,
            email: email,
            phone: phone,
            mobile: mobile,
            street: street,
            city: city,
            zip: zip,
            countryId: countryId,
            isSynced: isSynced,
            hasPendingChanges: hasPendingChanges,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncAt: lastSyncAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClientesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientesTableTable,
    ClienteDb,
    $$ClientesTableTableFilterComposer,
    $$ClientesTableTableOrderingComposer,
    $$ClientesTableTableAnnotationComposer,
    $$ClientesTableTableCreateCompanionBuilder,
    $$ClientesTableTableUpdateCompanionBuilder,
    (ClienteDb, BaseReferences<_$AppDatabase, $ClientesTableTable, ClienteDb>),
    ClienteDb,
    PrefetchHooks Function()>;
typedef $$SyncLogTableTableCreateCompanionBuilder = SyncLogTableCompanion
    Function({
  Value<int> id,
  required String entityType,
  required int entityId,
  required String operation,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
});
typedef $$SyncLogTableTableUpdateCompanionBuilder = SyncLogTableCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<int> entityId,
  Value<String> operation,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
});

class $$SyncLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncLogTableTable,
    SyncLogDb,
    $$SyncLogTableTableFilterComposer,
    $$SyncLogTableTableOrderingComposer,
    $$SyncLogTableTableAnnotationComposer,
    $$SyncLogTableTableCreateCompanionBuilder,
    $$SyncLogTableTableUpdateCompanionBuilder,
    (SyncLogDb, BaseReferences<_$AppDatabase, $SyncLogTableTable, SyncLogDb>),
    SyncLogDb,
    PrefetchHooks Function()> {
  $$SyncLogTableTableTableManager(_$AppDatabase db, $SyncLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              SyncLogTableCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            status: status,
            errorMessage: errorMessage,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required int entityId,
            required String operation,
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              SyncLogTableCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            status: status,
            errorMessage: errorMessage,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncLogTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncLogTableTable,
    SyncLogDb,
    $$SyncLogTableTableFilterComposer,
    $$SyncLogTableTableOrderingComposer,
    $$SyncLogTableTableAnnotationComposer,
    $$SyncLogTableTableCreateCompanionBuilder,
    $$SyncLogTableTableUpdateCompanionBuilder,
    (SyncLogDb, BaseReferences<_$AppDatabase, $SyncLogTableTable, SyncLogDb>),
    SyncLogDb,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableTableManager get clientesTable =>
      $$ClientesTableTableTableManager(_db, _db.clientesTable);
  $$SyncLogTableTableTableManager get syncLogTable =>
      $$SyncLogTableTableTableManager(_db, _db.syncLogTable);
}
