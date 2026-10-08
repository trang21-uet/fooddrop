// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_upload.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateUploadCWProxy {
  CreateUpload purpose(CreateUploadPurposeEnum? purpose);

  CreateUpload contentType(CreateUploadContentTypeEnum contentType);

  CreateUpload sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUpload(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUpload(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUpload call({
    CreateUploadPurposeEnum? purpose,
    CreateUploadContentTypeEnum contentType,
    int sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateUpload.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateUpload.copyWith.fieldName(...)`
class _$CreateUploadCWProxyImpl implements _$CreateUploadCWProxy {
  const _$CreateUploadCWProxyImpl(this._value);

  final CreateUpload _value;

  @override
  CreateUpload purpose(CreateUploadPurposeEnum? purpose) =>
      this(purpose: purpose);

  @override
  CreateUpload contentType(CreateUploadContentTypeEnum contentType) =>
      this(contentType: contentType);

  @override
  CreateUpload sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUpload(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUpload(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUpload call({
    Object? purpose = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return CreateUpload(
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as CreateUploadPurposeEnum?,
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as CreateUploadContentTypeEnum,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as int,
    );
  }
}

extension $CreateUploadCopyWith on CreateUpload {
  /// Returns a callable class that can be used as follows: `instanceOfCreateUpload.copyWith(...)` or like so:`instanceOfCreateUpload.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateUploadCWProxy get copyWith => _$CreateUploadCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUpload _$CreateUploadFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateUpload', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['contentType', 'sizeBytes']);
      final val = CreateUpload(
        purpose: $checkedConvert(
          'purpose',
          (v) => $enumDecodeNullable(_$CreateUploadPurposeEnumEnumMap, v),
        ),
        contentType: $checkedConvert(
          'contentType',
          (v) => $enumDecode(_$CreateUploadContentTypeEnumEnumMap, v),
        ),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CreateUploadToJson(
  CreateUpload instance,
) => <String, dynamic>{
  'purpose': ?_$CreateUploadPurposeEnumEnumMap[instance.purpose],
  'contentType': _$CreateUploadContentTypeEnumEnumMap[instance.contentType]!,
  'sizeBytes': instance.sizeBytes,
};

const _$CreateUploadPurposeEnumEnumMap = {
  CreateUploadPurposeEnum.parser: 'parser',
  CreateUploadPurposeEnum.recipeStep: 'recipe-step',
};

const _$CreateUploadContentTypeEnumEnumMap = {
  CreateUploadContentTypeEnum.imageSlashJpeg: 'image/jpeg',
  CreateUploadContentTypeEnum.imageSlashPng: 'image/png',
  CreateUploadContentTypeEnum.imageSlashWebp: 'image/webp',
};
