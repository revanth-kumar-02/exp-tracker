import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../domain/parsed_transaction.dart';

class DeduplicationService {
  /// Generates a deterministic SHA-256 fingerprint for transaction deduplication.
  /// Bucket is quantized into 10-minute intervals (600,000 ms) to absorb network retries
  /// and repeated alerts for the same event.
  static String generateFingerprint(ParsedTransaction tx) {
    const int tenMinutesMs = 10 * 60 * 1000;
    final int timeBucket = tx.occurredAt.millisecondsSinceEpoch ~/ tenMinutesMs;

    final String normalizedMerchant = tx.merchant.trim().toLowerCase();
    final String suffix = tx.cardSuffix ?? 'NONE';

    final String raw = '${tx.sourceApp}|${tx.amountPaise}|$timeBucket|$normalizedMerchant|$suffix|${tx.type.dbValue}';
    final bytes = utf8.encode(raw);
    return sha256.convert(bytes).toString();
  }
}
