import 'package:expenz/constants/colors.dart';
import 'package:expenz/constants/constants.dart';
import 'package:expenz/models/expense_model.dart';
import 'package:expenz/models/income_model.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/widgets/expense_card.dart';
import 'package:expenz/widgets/income_expenz_card.dart';
import 'package:expenz/widgets/linechart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Expense> expensesList;
  final List<Income> incomeList;
  const HomeScreen(
      {super.key, required this.expensesList, required this.incomeList});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // to store the userName and email
  String username = "";
  String email = "";
  double expenseTotal = 0;
  double incomeTotal = 0;
  @override
  void initState() {
    super.initState();
    // Get the user details from shared preferences
    UserServices.getUserData().then((value) {
      setState(() {
        username = value['username'] ?? "";
        email = value['email'] ?? "";
      });
    });
    setState(() {
      // total amount of expenses
      for (var i = 0; i < widget.expensesList.length; i++) {
        expenseTotal += widget.expensesList[i].amount;
      }
      // total amount of income
      for (var i = 0; i < widget.incomeList.length; i++) {
        incomeTotal += widget.incomeList[i].amount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // main column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // bg color column
              Container(
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: kMainColor.withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(100),
                              color: kMainColor,
                              border: Border.all(color: kMainColor, width: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                "assets/images/user.jpg",
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Welcome $username",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications,
                              color: kMainColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IncomeExpenzCard(
                            title: "Income",
                            amount: incomeTotal,
                            bgColor: kGreen,
                            imageUrl: "assets/images/income.png",
                          ),
                          IncomeExpenzCard(
                            title: "Expense",
                            amount: expenseTotal,
                            bgColor: kRed,
                            imageUrl: "assets/images/expense.png",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // line chart
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Spend Frequency",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const LinechartSample(),
                    // recent transactions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recent Transactions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // show the recent transactions
                          Column(
                            children: [
                              // Use a conditional statement to check for expensesList
                              // Assuming `expensesList` is passed to this widget
                              widget.expensesList.isEmpty
                                  ? const Text(
                                      "No expenses added yet, add some expenses to see here",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: kGrey,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: widget.expensesList.length,
                                      itemBuilder: (context, index) {
                                        final expense =
                                            widget.expensesList[index];
                                        return ExpenseCard(
                                          title: expense.title,
                                          date: expense.date,
                                          amount: expense.amount,
                                          category: expense.category,
                                          description: expense.description,
                                          createdAt: expense.time,
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
