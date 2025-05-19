class DividendRecord {
  final String symbol;
  final String year;
  final String quarter;
  final String yieldPercent;
  final String amount;
  final String xdDate;
  final String payDate;
  final String type;
  final int scrapedAt;

  DividendRecord({
    required this.symbol,
    required this.year,
    required this.quarter,
    required this.yieldPercent,
    required this.amount,
    required this.xdDate,
    required this.payDate,
    required this.type,
    required this.scrapedAt,
  });

  factory DividendRecord.fromJson(Map<String, dynamic> json) {
    return DividendRecord(
      symbol: json['symbol'] as String,
      year: json['year'] as String,
      quarter: json['quarter'] as String,
      yieldPercent: json['yield_percent'] as String,
      amount: json['amount'] as String,
      xdDate: json['xd_date'] as String,
      payDate: json['pay_date'] as String,
      type: json['type'] as String,
      scrapedAt: json['scraped_at'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'year': year,
      'quarter': quarter,
      'yield_percent': yieldPercent,
      'amount': amount,
      'xd_date': xdDate,
      'pay_date': payDate,
      'type': type,
      'scraped_at': scrapedAt,
    };
  }
} 