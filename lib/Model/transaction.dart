class TransactionModel {
  final int amount;
  final DateTime date;
  final String note;
  final String type;
  final String selectedOption;

  TransactionModel(
      this.amount, this.date, this.note, this.type, this.selectedOption);
}
