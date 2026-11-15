import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/cards/data/card_repository.dart';
import 'package:expense_tracker/features/cards/domain/card_enums.dart';
import 'package:expense_tracker/features/notifications/domain/notification_payload.dart';
import 'package:expense_tracker/features/notifications/domain/parsed_transaction.dart';
import 'package:expense_tracker/features/notifications/parsers/hdfc_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/icici_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/parser_registry.dart';
import 'package:expense_tracker/features/notifications/parsers/sbi_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/rbl_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/canara_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/slice_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/amazon_pay_icici_parser.dart';
import 'package:expense_tracker/features/notifications/parsers/iob_parser.dart';
import 'package:expense_tracker/features/notifications/services/transaction_ingestion_service.dart';

void main() {
  late AppDatabase db;
  late CardRepository cardRepo;
  late TransactionIngestionService ingestionService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cardRepo = CardRepository(db);
    ingestionService = TransactionIngestionService(db, cardRepo, ParserRegistry());

    // Seed test card: HDFC Debit ending in 4821
    await cardRepo.addCard(
      id: 'card_hdfc_4821',
      bankName: 'HDFC Bank',
      cardType: CardType.debit,
      network: CardNetwork.visa,
      maskedNumber: '•••• •••• •••• 4821',
      lastFour: '4821',
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Bank Parser Unit Tests', () {
    test('HDFC Parser parses debit purchase correctly', () {
      final parser = HdfcParser();
      final payload = NotificationPayload(
        packageName: 'com.snapwork.hdfc',
        title: 'Transaction Alert',
        text: 'INR 450.00 debited at SWIGGY from card ending 4821 on 14-NOV-26.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'hdfc_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(45000));
      expect(parsed.cardSuffix, equals('4821'));
      expect(parsed.merchant.toUpperCase(), contains('SWIGGY'));
      expect(parsed.type, equals(ParsedTransactionType.debit));
    });

    test('SBI Parser parses credit card alert correctly', () {
      final parser = SbiParser();
      final payload = NotificationPayload(
        packageName: 'com.sbi.lotusintouch',
        title: 'SBI Card Alert',
        text: 'Transaction of INR 12,300.00 done on SBI Credit Card ending 7290 at FLIPKART.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'sbi_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(1230000));
      expect(parsed.cardSuffix, equals('7290'));
      expect(parsed.merchant.toUpperCase(), contains('FLIPKART'));
      expect(parsed.type, equals(ParsedTransactionType.debit));
    });

    test('ICICI Parser parses debit alert correctly', () {
      final parser = IciciParser();
      final payload = NotificationPayload(
        packageName: 'com.csam.icici.bank.imobile',
        title: 'ICICI Bank Alert',
        text: 'ICICI Bank Acct XX1934 debited for Rs 3,840.00 on 14-Nov-26 at RELIANCE. Avl Bal...',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'icici_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(384000));
      expect(parsed.cardSuffix, equals('1934'));
      expect(parsed.merchant.toUpperCase(), contains('RELIANCE'));
      expect(parsed.type, equals(ParsedTransactionType.debit));
    });

    test('HDFC Parser distinguishes refund transaction', () {
      final parser = HdfcParser();
      final payload = NotificationPayload(
        packageName: 'com.snapwork.hdfc',
        title: 'Refund Alert',
        text: 'Refund of Rs 250.00 processed to your HDFC Card ending 4821 from ZOMATO.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'hdfc_refund_1',
      );

      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.type, equals(ParsedTransactionType.refund));
      expect(parsed.amountPaise, equals(25000));
    });

    test('RBL Parser parses RBL credit card alert correctly', () {
      final parser = RblParser();
      final payload = NotificationPayload(
        packageName: 'com.rblbank.mobank',
        title: 'RBL Alert',
        text: 'Alert: Rs 1,499.00 spent on RBL Bank Credit Card ending 3312 at BOOKMYSHOW on 15-Nov.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'rbl_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(149900));
      expect(parsed.cardSuffix, equals('3312'));
      expect(parsed.merchant.toUpperCase(), contains('BOOKMYSHOW'));
    });

    test('Canara Parser parses Canara debit alert correctly', () {
      final parser = CanaraParser();
      final payload = NotificationPayload(
        packageName: 'com.canarabank.ai1',
        title: 'Canara Alert',
        text: 'Canara Bank: Rs 2,500.00 debited from A/C ending 6621 at D-MART on 15-NOV-26.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'canara_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(250000));
      expect(parsed.cardSuffix, equals('6621'));
      expect(parsed.merchant.toUpperCase(), contains('D-MART'));
    });

    test('Slice Parser parses slice card spend correctly', () {
      final parser = SliceParser();
      final payload = NotificationPayload(
        packageName: 'indwin.c3.shareSpend',
        title: 'slice alert',
        text: 'Paid Rs 349.00 using slice card ending 8812 at NETFLIX.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'slice_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(34900));
      expect(parsed.cardSuffix, equals('8812'));
      expect(parsed.merchant.toUpperCase(), contains('NETFLIX'));
    });

    test('Amazon Pay ICICI Parser parses co-branded card alert correctly', () {
      final parser = AmazonPayIciciParser();
      final payload = NotificationPayload(
        packageName: 'com.csam.icici.bank.imobile',
        title: 'ICICI Alert',
        text: 'Alert: Rs 4,999.00 spent on Amazon Pay ICICI Bank Credit Card ending 9012 at AMAZON.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'amz_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(499900));
      expect(parsed.cardSuffix, equals('9012'));
      expect(parsed.merchant.toUpperCase(), contains('AMAZON'));
    });

    test('IOB Parser parses Indian Overseas Bank alert correctly', () {
      final parser = IobParser();
      final payload = NotificationPayload(
        packageName: 'com.overseas.netbanking',
        title: 'IOB Alert',
        text: 'IOB Alert: Rs 1,800.00 debited from your IOB Account ending 5543 at RELIANCE DIGITAL on 15-Nov.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'iob_1',
      );

      expect(parser.canHandle(payload), isTrue);
      final parsed = parser.parse(payload);
      expect(parsed, isNotNull);
      expect(parsed!.amountPaise, equals(180000));
      expect(parsed.cardSuffix, equals('5543'));
      expect(parsed.merchant.toUpperCase(), contains('RELIANCE DIGITAL'));
    });

    test('Parser rejects OTP, promotional, and security non-financial alerts', () {
      final registry = ParserRegistry();

      final otpPayload = NotificationPayload(
        packageName: 'com.snapwork.hdfc',
        title: 'NetBanking OTP',
        text: 'Your HDFC Bank NetBanking OTP is 492812. Do not share with anyone.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'otp_1',
      );
      expect(registry.parseNotification(otpPayload), isNull);

      final securityPayload = NotificationPayload(
        packageName: 'com.sbi.lotusintouch',
        title: 'Security Alert',
        text: 'Login alert for your SBI Account from a new device IP 192.168.1.1.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'sec_1',
      );
      expect(registry.parseNotification(securityPayload), isNull);
    });
  });

  group('Ingestion & Deterministic Matching Engine Tests', () {
    test('Confirmed match when notification card suffix matches registered card', () async {
      final payload = NotificationPayload(
        packageName: 'com.snapwork.hdfc',
        title: 'HDFC Alert',
        text: 'INR 450.00 debited at SWIGGY from card ending 4821.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'match_test_1',
      );

      final result = await ingestionService.processNotification(payload);

      expect(result.status, equals(IngestionStatus.confirmed));
      expect(result.matchedCardId, equals('card_hdfc_4821'));

      final tx = await (db.select(db.transactions)..where((t) => t.id.equals(result.transactionId!))).getSingle();
      expect(tx.matchStatus, equals('CONFIRMED'));
      expect(tx.paymentCardId, equals('card_hdfc_4821'));
      expect(tx.amountPaise, equals(45000));
    });

    test('Unassigned fallback when notification card suffix is not registered', () async {
      final payload = NotificationPayload(
        packageName: 'com.sbi.lotusintouch',
        title: 'SBI Alert',
        text: 'INR 850.00 debited at UBER from card ending 9999.', // 9999 is NOT registered
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'unassigned_test_1',
      );

      final result = await ingestionService.processNotification(payload);

      expect(result.status, equals(IngestionStatus.unassigned));
      expect(result.matchedCardId, isNull);

      final tx = await (db.select(db.transactions)..where((t) => t.id.equals(result.transactionId!))).getSingle();
      expect(tx.matchStatus, equals('UNASSIGNED'));
      expect(tx.paymentCardId, isNull);
    });

    test('Unassigned fallback when notification omits card suffix (e.g. UPI alert)', () async {
      final payload = NotificationPayload(
        packageName: 'com.google.android.apps.nbu.paisa.user',
        title: 'Google Pay',
        text: 'Paid Rs 150.00 to Chai Point via UPI.', // No card suffix
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'upi_test_1',
      );

      final result = await ingestionService.processNotification(payload);

      expect(result.status, equals(IngestionStatus.unassigned));
      expect(result.matchedCardId, isNull);

      final tx = await (db.select(db.transactions)..where((t) => t.id.equals(result.transactionId!))).getSingle();
      expect(tx.matchStatus, equals('UNASSIGNED'));
      expect(tx.paymentCardId, isNull);
    });

    test('Duplicate notifications are detected and rejected', () async {
      final payload = NotificationPayload(
        packageName: 'com.snapwork.hdfc',
        title: 'HDFC Alert',
        text: 'INR 450.00 debited at SWIGGY from card ending 4821.',
        postTime: DateTime.now().millisecondsSinceEpoch,
        key: 'dedupe_1',
      );

      // First delivery: Confirmed
      final firstResult = await ingestionService.processNotification(payload);
      expect(firstResult.status, equals(IngestionStatus.confirmed));

      // Second delivery of same notification: Rejected as duplicate
      final secondResult = await ingestionService.processNotification(payload);
      expect(secondResult.status, equals(IngestionStatus.duplicate));

      // Total transaction count in database remains exactly 1
      final allTxs = await db.select(db.transactions).get();
      expect(allTxs.length, equals(1));
    });
  });
}
