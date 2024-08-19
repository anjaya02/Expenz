import 'package:flutter/material.dart';

enum IncomeCategory {
  freelance,
  salary,
  passive,
  sales,
}

// Category images
final Map<IncomeCategory, String> incomeCategoryImages = {
  IncomeCategory.freelance: "assets/images/freelance.png",
  IncomeCategory.passive: "assets/images/car.png",
  IncomeCategory.sales: "assets/images/health.png",
  IncomeCategory.salary: "assets/images/salary.png",
};

// Category colors
final Map<IncomeCategory, Color> incomeCategoryColors = {
  IncomeCategory.freelance: const Color(0xFFE57373),
  IncomeCategory.passive: const Color(0xFF81C784),
  IncomeCategory.sales: const Color(0xFF64B5F6),
  IncomeCategory.salary: const Color(0xFFFFD54F),
};

final class Income {
  final int id;
  final String title;
  final double amount;
  final IncomeCategory category;
  final DateTime date;
  final DateTime time;
  final String description;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.description,
  });

  // Converts the income object to a JSON object
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.toString().split('.').last,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'description': description,
    };
  }

  // Creates an income object from a JSON object
  factory Income.fromJSON(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: IncomeCategory.values
          .firstWhere((e) => e.toString().split('.').last == json['category']),
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      description: json['description'],
    );
  }
}
