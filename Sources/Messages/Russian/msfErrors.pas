﻿unit msfErrors;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS_SECTION_INTERFACE}
interface
{$ENDIF}

{$IFDEF SUPPORTS_RESOURCE_STRINGS}
 resourcestring
{$ELSE}
 const
{$ENDIF}
  rsNotSupportClone = 'Класс "%s" не поддерживает клонирования';
  rsNotLoadingLibrary = 'Указанная библиотека не загружена %s';
  rsDriverSupportOnlyFirebirdSQL = 'Поддерживается только драйвер FirebirdSQL';
  rsErrorFormatPDBC = 'Ошибка формата pDBC';
  rsSourceNotSpecified = 'Не указан источник';
  rsTasksNotSpecified = 'Не указана папка с задачами';
  rsSettingsNotSpecified = 'Не указан файл с настройками';
  rsFolderForLogsNotSpecified = 'Не указана папка под логи';
  rsExportFolderNotSpecified = 'Не указана папка для экспорта';
  rsImportFolderNotSpecified = 'Не указана папка для импорта';
  rsUnknownType = 'Неизвестный тип %s';
  rsUnknownCodePage = 'Неизвестная кодовая страница. Процедура: %s';
  rsFolderForWorkError = 'В папке work есть открытые файлы';
  rsPropertyNotSupport = 'Свойство "%s" не поддерживается';
  rsTypeNotSupport = 'Тип "%s" не поддерживается';
  rsTheLogicalChainIsBroken = 'Нарушена логическая цепочка в методе %s';
  rsFixedQuantityError = 'Требуется фиксированное количество, %d<>%d, %s';
  rsPairCannotBeAddedTo = 'Тип ключа-значения не возможно добавить в %s';
  rsPairKeyOnlyStringKind = 'Допускается только стороковый тип ключа, %s';
  rsObjectOnlyPairKind = 'Допускается только ключ-значение у объекта, %s';
  rsObjectCannotBeAddedTo = 'Тип объект не возможно добавить в %s';
  rsInvalidCharsInPath = 'Не допустимые символы в пути';

{$IFDEF SUPPORTS_RESOURCE_STRINGS}
 resourcestring
{$ELSE}
 const
{$ENDIF}
  rsObject    = 'Объект';
  rsArray     = 'Массив';
  rsPair      = 'Ключ-значения';
  rsComment   = 'Комментарий';
  rsBool      = 'Логическое значение';
  rsString    = 'Строковое значение';
  rsFloat     = 'Вещественное значение';
  rsInt       = 'Целочисленное значение';
  rsDate      = 'Значение типа дата';
  rsTime      = 'Значение типа время';
  rsDateTime  = 'Значение типа дата и время';
  rsNull      = 'Значение типа Null';
  rsUndefined = 'Неопределенное значение';

implementation

end.
