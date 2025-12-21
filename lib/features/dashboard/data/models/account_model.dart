class AccountModel {
  final String accountNumber;
  final double balance;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  AccountModel({
    required this.accountNumber,
    required this.balance,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    accountNumber: json['accountNumber'],
    balance: json['balance'],
    cardHolderName: json['cardHolderName'],
    expiryDate: json['expiryDate'],
    cvv: json['cvv'],
  );

  Map<String, dynamic> toJson() => {
    'accountNumber': accountNumber,
    'balance': balance,
    'cardHolderName': cardHolderName,
    'expiryDate': expiryDate,
    'cvv': cvv,
  };
}
