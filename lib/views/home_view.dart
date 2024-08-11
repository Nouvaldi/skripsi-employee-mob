import 'package:employee_mobile/views/attendance_view.dart';
import 'package:employee_mobile/views/items_view.dart';
import 'package:employee_mobile/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../components/my_card.dart';
import '../components/my_drawer_tile.dart';
import '../components/my_elevated_button.dart';
import '../components/my_icon_button.dart';
import '../viewmodels/home_viewmodel.dart';
import 'attendance_history_view.dart';
import 'settings_view.dart';
import 'transaction_history_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final prefs = Provider.of<LoginViewModel>(context);
    // final username = prefs.username;
    final DateTime now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel()..fetchHomeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Employee Mobile'),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Icon(
                    Icons.shopify_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                MyDrawerTile(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('HOME'),
                ),
                const SizedBox(height: 8),
                MyDrawerTile(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('SETTINGS'),
                ),
                const Spacer(),
                MyDrawerTile(
                  onPressed: () {
                    HomeViewModel().logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('LOGOUT'),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            if (homeViewModel.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (homeViewModel.errorMessage != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  await homeViewModel.fetchHomeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 300),
                      child: Text(
                        homeViewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await homeViewModel.fetchHomeData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        MyCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Welcome back, ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Text(
                                homeViewModel.username!,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        MyCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Announcement',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Text(
                                DateFormat('d MMMM yyyy').format(now),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (homeViewModel.announcements.isNotEmpty)
                                Text(
                                  homeViewModel.announcements[0].announcement,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        MyCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 124,
                                alignment: Alignment.center,
                                child: Text(
                                  "Check In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 124,
                                alignment: Alignment.center,
                                child: Text(
                                  "Check Out",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        MyCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 124,
                                    alignment: Alignment.center,
                                    child: Text(
                                      homeViewModel.checkInTime != null
                                          ? DateFormat('Hm').format(
                                              homeViewModel.checkInTime!)
                                          : "--:--",
                                      style: TextStyle(
                                        fontSize: 36,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 124,
                                    alignment: Alignment.center,
                                    child: Text(
                                      homeViewModel.checkOutTime != null
                                          ? homeViewModel.checkOutTime!.year > 1
                                              ? DateFormat('Hm').format(
                                                  homeViewModel.checkOutTime!)
                                              : "--:--"
                                          : "--:--",
                                      style: TextStyle(
                                        fontSize: 36,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        MyElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AttendanceHistoryPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('Attendance History'),
                        ),
                        const SizedBox(height: 120),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyIconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionPage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.work_history,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              tooltip: 'Transaction History',
                            ),
                            MyIconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ItemsPage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.shopping_cart_rounded,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              tooltip: 'Item List',
                            ),
                            MyIconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendancePage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.timer_rounded,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              tooltip: 'Attendance',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
