class TransactionModel {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final String iconPath;

  TransactionModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.iconPath,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        title: json['title'],
        category: json['category'],
        amount: json['amount'],
        isIncome: json['isIncome'],
        iconPath: json['iconPath'],
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'amount': amount,
    'isIncome': isIncome,
    'iconPath': iconPath,
  };
}
