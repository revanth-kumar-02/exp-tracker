# Expense Tracker — Mock Data & Production Hardening Audit

**Document Version:** 1.0.0  
**Audit Date:** 2026-11-16  
**Auditors:** Senior Flutter Engineer, Android Systems Engineer & Software Architect  
**Scope:** Complete Codebase (`lib/`, `android/`, SQLite Drift Schema, Riverpod Providers, Native Bridge)

---

## 1. Executive Summary

A comprehensive codebase audit was conducted across all Dart presentation layers, domain entities, Riverpod controllers, database repositories, Drift SQLite tables, and Android Kotlin native components.

The application has established a solid architectural foundation with a local Drift SQLite database (`expense_tracker.sqlite`), deterministic regex-based notification parsers, and a Kotlin `NotificationListenerService`. However, several hardcoded mock data fallbacks, auto-seeded demo records, static percentage metrics, and in-memory state objects were identified that compromise production readiness.

This document identifies every occurrence of mock or simulated data, describes its exact location, and details the production replacement plan using SQLite as the single source of truth.

---

## 2. Comprehensive Mock Data Inventory

| # | File Path | Component / Location | Mock / Hardcoded Artifact | Impact | Proposed Production Replacement |
|---|---|---|---|---|---|
| **1** | `lib/main.dart` | Lines 14–56 (`main()` entrypoint) | Auto-seeding 3 demo cards (`demo_card_hdfc`, `demo_card_sbi`, `demo_card_icici`) with fake holder name `"John Doe"`, mock last-4 numbers (`4821`, `7290`, `1934`), and static expiry dates if DB is empty. | Prevents genuine empty-state verification; injects fake financial data into user's private database. | **Remove all auto-seeding logic.** Empty database must start with zero cards and cleanly display the "Add Your First Card" carousel call-to-action. |
| **2** | `lib/features/cards/presentation/screens/dashboard_screen.dart` | Lines 242–254 (`CardsOverviewSection` builder) | Hardcoded fallback spend values when transactions are empty:<br>• `totalSpentPaise: 2456000` (₹24,560)<br>• `deltaPercent: -12.0` (-12%)<br>• Hardcoded card spend map: `{allCards[0]: ₹8,420, allCards[1]: ₹12,300, allCards[2]: ₹3,840}` | Shows fake ₹24,560 spend even if user hasn't made any purchases. Deceives the user. | **Remove fallback spending block completely.** Feed real `totalSpentPaise` and actual per-card spending map calculated from current calendar month transactions in SQLite. If zero, display ₹0 and proper empty state. |
| **3** | `lib/features/cards/presentation/screens/dashboard_screen.dart` | Line 240 (`cardSpendMap`) | Empty map `final cardSpendMap = <String, int>{};` declared and passed when `totalSpentPaise > 0`. | Progress bars for registered cards never receive their actual spending breakdown in the non-fallback branch. | **Populate `cardSpendMap` from `DashboardSpendingOverview.cardMetrics`** (or directly from current month debit transactions grouped by `paymentCardId`). |
| **4** | `lib/features/cards/presentation/controllers/card_controller.dart` | Line 119 (`dashboardSpendingProvider`) | Hardcoded `monthOverMonthChangePercent: -12.0` in the returned `DashboardSpendingOverview`. | The month-over-month comparison badge on the dashboard always claims "-12% vs last month" regardless of user's spending. | **Compute real Month-over-Month Delta:** Query transactions occurring in the previous calendar month (`startOfPrevMonth` to `endOfPrevMonth`), sum debits, and calculate `((currentMonthDebits - prevMonthDebits) / prevMonthDebits) * 100`. |
| **5** | `lib/features/cards/presentation/controllers/card_controller.dart` | Line 120 (`dashboardSpendingProvider`) | Hardcoded empty list `cardMetrics: []`. | The metric list for individual card spending ratios is never populated. | **Populate `cardMetrics`:** Map each active payment card to its calculated monthly debit total, percentage of total spend, and card styling metadata. |
| **6** | `lib/features/cards/presentation/widgets/cards_overview_section.dart` | Line 17 (`deltaPercent`) | Default parameter `this.deltaPercent = -12.0`. | Default fallback to -12% if omitted. | Make `deltaPercent` a required double without a fake -12.0 default, or default to `0.0`. |
| **7** | `lib/features/cards/presentation/screens/dashboard_screen.dart` | Lines 128–140 (Top App Bar Bell Icon) | Static red notification dot (`AppColors.redDot`) always rendered on the bell icon. | Red dot is permanently active even if there are 0 unreviewed transactions. | **Bind to `unassignedTransactionsCountProvider`:** Only display the unread red indicator when `unassignedCount > 0`. Tapping opens the Transactions screen with the "Needs Review" filter active. |
| **8** | `lib/features/cards/presentation/screens/dashboard_screen.dart` | Lines 156–162 (Greeting section) | Hardcoded static string `"Good evening 👋"`. | Inappropriate greeting during morning or afternoon hours. | **Compute time-of-day greeting dynamically:** "Good morning" (05:00–11:59), "Good afternoon" (12:00–16:59), "Good evening" (17:00–21:59), "Good night" (22:00–04:59). |
| **9** | `lib/features/cards/presentation/controllers/card_bills_controller.dart` | Lines 47–50, 81–87 | Hardcoded statement cycle day (15th) and payment due day (5th) as constants across all cards; fallback spend calculation. | Inaccurate for cards with custom billing cycles (e.g. 1st–30th, 20th–10th). | **Support configurable billing cycles on `PaymentCards` table:** Add `statementDay` (1–31) and `dueDay` (1–31) columns (or provide intelligent defaults) and compute cycle spend strictly within `[cycleStartDate, statementDate]`. |
| **10** | `lib/features/cards/presentation/controllers/card_bills_controller.dart` | Lines 7–30 (`paidBillsProvider`) | In-memory `Set<String>` state for paid bills (`PaidBillsNotifier`). | Marking a credit card bill as "Paid" is lost whenever the app is killed or restarted. | **Persist bill payment status:** Store paid bill records in SQLite (or verify against credit repayment transactions) so bill payment state survives app restarts. |
| **11** | `lib/features/cards/presentation/screens/card_details_screen.dart` | Lines 140–168 | Soft-delete only (`isActive = false`); no card active/inactive toggle; no card type indicator toggle. | User cannot temporarily deactivate a card without deleting it. | **Implement toggle active/inactive status** in addition to deletion, and maintain transaction association integrity. |

---

## 3. Verified Real Architecture & Non-Mock Modules

The audit verified that the following core modules are **genuine, production-ready, and free of mock data**:

1. **Android Notification Service (`ExpenseNotificationListenerService.kt`):**
   - Live Android `NotificationListenerService` capturing push notifications from 13 whitelisted Indian banking and UPI packages (HDFC, SBI, ICICI, Axis, Canara, RBL, Slice, IOB, Google Pay, PhonePe, Paytm).
   - Zero hardcoded mock notifications. Real runtime events stream through `EventChannel('com.expensetracker/notifications')`.

2. **Transaction Ingestion & Parsing (`transaction_ingestion_service.dart`, `parser_registry.dart`):**
   - 10 deterministic regex parsers extracting amount, currency, transaction type (`DEBIT`/`CREDIT`), merchant, and card suffix (`lastFour`).
   - SHA-256 fingerprint deduplication prevents duplicate entries.
   - Deterministic last-4 card matching links transactions to SQLite `PaymentCards` records.

3. **Drift SQLite Database (`app_database.dart`, `tables.dart`):**
   - Fully persistent tables: `PaymentCards`, `Categories`, `Transactions`, `Budgets`, `NotificationSources`.
   - Foreign key constraints ensure data consistency (`ON DELETE SET NULL`).
   - Category seeding on database creation (`cat_food`, `cat_shopping`, `cat_travel`, `cat_bills`, `cat_fuel`, `cat_other`).

4. **Budgets & Spending Caps (`budget_calculator_service.dart`, `budgets_screen.dart`):**
   - Evaluates real spend against user-defined budget records in SQLite.
   - Clean empty states when no budgets are defined.

5. **Insights & Analytics (`insights_service.dart`, `insights_screen.dart`):**
   - Computes category breakdowns, debit-vs-credit splits, and merchant rankings strictly from real SQLite `Transactions` rows.
   - Handles empty transactions gracefully with zero-state visual cards.

---

## 4. Phase-by-Phase Remediation Roadmap

### Phase 1: Mock Data Removal & Empty State Hardening (Immediate)
1. **Remove Seed Cards from `main.dart`:** Ensure clean initial launch with 0 fake cards.
2. **Remove Fallback Numbers in `dashboard_screen.dart`:** Eliminate the ₹24,560 and -12% fake fallback branch.
3. **Connect Real Reactive Spending Provider:**
   - In `card_controller.dart`, compute real current month debits, real previous month debits, true percentage delta, and actual per-card spend breakdown.
4. **Fix Notification Bell Indicator:** Dynamic badge bound to `unassignedCount > 0`.
5. **Dynamic Greeting:** Real clock-based greeting.

### Phase 2: Card Management Full Functionality (Immediate Focus)
1. **Add Card:** Form validation, bank selection, debit/credit toggle, network auto-detection (Visa, Mastercard, RuPay, Amex), last-4 extraction, color gradient picker.
2. **Edit Card:** Edit card nickname, gradient color, and billing cycle days.
3. **Card Status Management:** Activate / deactivate toggle button.
4. **Delete Card:** Confirmation dialog with warning; transactions preserved and unlinked gracefully.
5. **Filter Pills:** Live reactive filtering for "All Cards (N)", "Debit (N)", "Credit (N)".
6. **Card Carousel:** Displays only real user cards; renders high-polish empty card prompt when 0 cards exist.

### Phase 3: Card Bills & Persistence Hardening
1. Add billing cycle fields and persistent bill payment status.
2. End-to-end testing with real SQLite queries.

---

## 5. Security & Architectural Compliance Confirmation

- **No Sensitive Credential Storage:** Card CVV, PIN, OTP, and full 16-digit PAN are never collected, logged, or stored.
- **Local-First:** All financial data remains strictly on the device within encrypted/isolated SQLite storage.
- **UI Preservation:** All dark fintech aesthetics (`#0B0B12`, `#7C3AED`, gradients, typography, and carousel animations) are strictly preserved.
