import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/appointment_validation.dart';

void main() {
  group('parseDocumentUrl', () {
    test('keeps web addresses and adds https when none was typed', () {
      expect(
        parseDocumentUrl(' https://lab.example.com/r?id=4 '),
        'https://lab.example.com/r?id=4',
      );
      expect(
        parseDocumentUrl('http://lab.example.com'),
        'http://lab.example.com',
      );
      expect(
        parseDocumentUrl('drive.example.com/ecg.pdf'),
        'https://drive.example.com/ecg.pdf',
      );
      expect(
        parseDocumentUrl('lab.example.com:8080/results'),
        'https://lab.example.com:8080/results',
      );
    });

    test('rejects what is not a web address', () {
      for (final text in [
        '',
        'results',
        'ecg report.pdf',
        'mailto:lab@example.com',
        'ftp://files.example.com/ecg',
        'javascript:alert(1)',
        'https://lab.example.com@other.example.org/results',
      ]) {
        expect(parseDocumentUrl(text), isNull, reason: text);
      }
    });
  });

  test('a document needs a title and a web address', () {
    expect(validateDocument(title: ' ', url: 'nope'), {
      DocumentIssue.titleMissing,
      DocumentIssue.urlInvalid,
    });
    expect(validateDocument(title: 'ECG', url: 'lab.example.com'), isEmpty);
  });
}
