import 'package:expenz/constants/colors.dart';
import 'package:expenz/models/expense_model.dart';
import 'package:expenz/models/income_model.dart';
import 'package:expenz/screens/add_new_screen.dart';
import 'package:expenz/screens/budget_screen.dart';
import 'package:expenz/screens/home_screen.dart';
import 'package:expenz/screens/profile_screen.dart';
import 'package:expenz/screens/transaction_screen.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_service.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0; // Moved this here to be a member variable
  List<Expense> expensesList = [];
  List<Income> incomeList = [];

  //category total expenses
  Map<ExpenseCategory, double> calculateExpensesCategories() {
    Map<ExpenseCategory, double> categoryTotals = {
      ExpenseCategory.food: 0,
      ExpenseCategory.transport: 0,
      ExpenseCategory.shopping: 0,
      ExpenseCategory.health: 0,
      ExpenseCategory.subscription: 0,
    };

    for (Expense expense in expensesList) {
      categoryTotals[expense.category] =
          categoryTotals[expense.category]! + expense.amount;
    }

    //print the food category total
    // print(categoryTotals[ExpenseCategory.health].runtimeType);

    return categoryTotals;
  }

  //category total income
  Map<IncomeCategory, double> calculateIncomeCategories() {
    Map<IncomeCategory, double> categoryTotals = {
      IncomeCategory.salary: 0,
      IncomeCategory.freelance: 0,
      IncomeCategory.passive: 0,
      IncomeCategory.sales: 0,
    };

    for (Income income in incomeList) {
      categoryTotals[income.category] =
          categoryTotals[income.category]! + income.amount;
    }

    //print the food category total
    // print(categoryTotals[IncomeCategory.salary].runtimeType);

    return categoryTotals;
  }

  // Function to fetch expenses
  void fetchAllExpenses() async {
    List<Expense> loadedExpenses = await ExpenceService().loadExpenses();
    setState(() {
      expensesList = loadedExpenses;
    });
  }

// Function to fetch all incomes
  void fetchAllIncomes() async {
    List<Income> loadedIncomes = await IncomeServices().loadIncomes();
    setState(() {
      incomeList = loadedIncomes;
    });
  }

// Function to add a new expense
  void addNewExpense(Expense newExpense) {
    ExpenceService().saveExpense(newExpense, context);
    // Update the list of expenses
    setState(() {
      expensesList.add(newExpense);
    });
  }

  // Function to add new income
  void addNewIncome(Income newIncome) {
    IncomeServices().saveIncome(newIncome, context);
    // Updated the income list
    setState(() {
      incomeList.add(newIncome);
    });
  }

// Function to remove an expense
  void removeExpense(Expense expense) {
    ExpenceService().deleteExpense(expense.id, context);

    setState(() {
      expensesList.remove(expense);
    });
  }

// Function to remove an income
  void removeIncome(Income income) {
    IncomeServices().deleteIncome(income.id, context);

    setState(() {
      incomeList.remove(income);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchAllExpenses();
      fetchAllIncomes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        expensesList: expensesList,
        incomeList: incomeList,
      ),
      TransactionsScreen(
        onDismissedIncome: removeIncome,
        incomeList: incomeList,
        expensesList: expensesList,
        onDismissedExpenses: removeExpense,
      ),
      AddNewScreen(
        addExpense: addNewExpense,
        addIcome: addNewIncome,
      ),
      BudgetScreen(
        expenseCategoryTotals: calculateExpensesCategories(),
        incomeCategoryTotals: calculateIncomeCategories(),
      ),
      const ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: kWhite,
        selectedItemColor: kMainColor,
        unselectedItemColor: kGrey,
        selectedLabelStyle:
            const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: kMainColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.add,
                  color: kWhite,
                  size: 45,
                ),
              ),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.rocket),
            label: "Budget",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
      body: pages[_currentPageIndex],
    );
  }
}
