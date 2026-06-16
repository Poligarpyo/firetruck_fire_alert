import '../../exceptions/invalid_phone_number_exception.dart';

class PhoneNumber {
  final String value;

  PhoneNumber._(this.value);

  static PhoneNumber parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.startsWith('09') && cleaned.length == 11) {
      return PhoneNumber._('+63${cleaned.substring(1)}');
    }

    if (cleaned.startsWith('9') && cleaned.length == 10) {
      return PhoneNumber._('+63$cleaned');
    }

    if (cleaned.startsWith('639') && cleaned.length == 12) {
      return PhoneNumber._('+$cleaned');
    }

    throw InvalidPhoneNumberException();
  }

  @override
  String toString() => value;
}
