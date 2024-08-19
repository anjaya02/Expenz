import 'package:expenz/constants/colors.dart';
import 'package:expenz/constants/constants.dart';
import 'package:expenz/models/expense_model.dart';
import 'package:expenz/models/income_model.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_service.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewScreen extends StatefulWidget {
  final Function(Expense) addExpense;
  final Function(Income) addIcome;
  const AddNewScreen({
    super.key,
    required this.addExpense,
    required this.addIcome,
  });

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  int _selectedMethod = 0;
  dynamic _selectedCategory; // Allow both ExpenseCategory and IncomeCategory
  ExpenseCategory _expenseCategory = ExpenseCategory.health;
  IncomeCategory _incomeCategory = IncomeCategory.salary;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedMethod == 0 ? kRed : kGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kWhite,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMethod = 0;
                                _selectedCategory =
                                    _expenseCategory; // Set the category
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedMethod == 0 ? kRed : kWhite,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                child: Text(
                                  "Expense",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        _selectedMethod == 0 ? kWhite : kBlack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMethod = 1;
                                _selectedCategory =
                                    _incomeCategory; // Set the category
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedMethod == 1 ? kGreen : kWhite,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                child: Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        _selectedMethod == 1 ? kWhite : kBlack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .12),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How much?",
                            style: TextStyle(
                                color: kLightGrey.withOpacity(.8),
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter an amount!";
                              }

                              double? amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return "Please enter a valid amount";
                              }
                              return null;
                            },
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "0",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: kWhite,
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold)),
                            style: const TextStyle(
                                fontSize: 80,
                                color: kWhite,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .75,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .31),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Category",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: _selectedMethod == 0
                                ? ExpenseCategory.values.map((category) {
                                    return DropdownMenuItem<ExpenseCategory>(
                                      value: category,
                                      child: Text(category.name),
                                    );
                                  }).toList()
                                : IncomeCategory.values.map((category) {
                                    return DropdownMenuItem<IncomeCategory>(
                                      value: category,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                            onChanged: (value) {
                              setState(() {
                                if (_selectedMethod == 0) {
                                  _expenseCategory = value as ExpenseCategory;
                                } else {
                                  _incomeCategory = value as IncomeCategory;
                                }
                                _selectedCategory = value;
                              });
                            },
                            value: _selectedCategory,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Title!";
                              }
                              return null;
                            },
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Description!";
                              }
                              return null;
                            },
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Amount",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                            ),
                          ),
                          // date picker
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2025),
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedDate = value;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kMainColor,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: kWhite,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Select Date",
                                          style: TextStyle(
                                            color: kWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // date
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd().format(_selectedDate),
                                style: const TextStyle(
                                  color: kGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedTime = DateTime(
                                          _selectedDate.year,
                                          _selectedDate.month,
                                          _selectedDate.day,
                                          value.hour,
                                          value.minute,
                                        );
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color:
                                        const Color.fromARGB(255, 30, 173, 8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: kWhite,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Select Time",
                                          style: TextStyle(
                                            color: kWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // date
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.jm().format(_selectedTime),
                                style: const TextStyle(
                                  color: kGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            color: kLightGrey,
                            thickness: 5,
                          ),

                          // submit button

                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedMethod == 0) {
                                  // save the income or expense data into shared prefs
                                  List<Expense> loadedExpenses =
                                      await ExpenceService().loadExpenses();
                                  // create the expense to store
                                  Expense expense = Expense(
                                    id: loadedExpenses.length + 1,
                                    title: _titleController.text,
                                    amount: _amountController.text.isEmpty
                                        ? 0
                                        : double.parse(_amountController.text),
                                    category: _expenseCategory,
                                    date: _selectedDate,
                                    time: _selectedTime,
                                    description: _descriptionController.text,
                                  );
                                  widget.addExpense(expense);
                                  // clear text fields
                                  _titleController.clear();
                                  _amountController.clear();
                                  _descriptionController.clear();
                                } else {
                                  // load incomes
                                  List<Income> loadedIncome =
                                      await IncomeServices().loadIncomes();
                                  Income income = Income(
                                    id: loadedIncome.length + 1,
                                    title: _titleController.text,
                                    amount: _amountController.text.isEmpty
                                        ? 0
                                        : double.parse(_amountController.text),
                                    category: _incomeCategory,
                                    date: _selectedDate,
                                    time: _selectedTime,
                                    description: _descriptionController.text,
                                  );
                                  widget.addIcome(income);
                                  // clear text fields
                                  _titleController.clear();
                                  _amountController.clear();
                                  _descriptionController.clear();
                                }
                              }
                            },
                            child: CustomButton(
                              buttonName: "Add",
                              buttonColor: _selectedMethod == 0 ? kRed : kGreen,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
