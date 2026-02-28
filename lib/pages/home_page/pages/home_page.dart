import 'dart:developer' as d;
import 'package:demo_ui/components/custom_snack_bar.dart';
import 'package:demo_ui/config/strings.dart';
import 'package:demo_ui/config/theme_config.dart';
import 'package:demo_ui/pages/home_page/widgets/for_you.dart';
import 'package:demo_ui/pages/home_page/widgets/hot_deals.dart';
import 'package:demo_ui/pages/home_page/widgets/search_container.dart';
import 'package:demo_ui/pages/home_page/widgets/sliver_app_bar_delegate.dart';
import 'package:demo_ui/providers/refresh_provider.dart';
import 'package:demo_ui/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RefreshProvider refreshProvider;
  late UserProvider userProvider;
  bool loading = false;
  ValueNotifier<bool> userLoggedIn = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    refreshProvider = context.read<RefreshProvider>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initData();
    });
  }

  Future<void> initData() async {
    try {
      loading = true;
      if (mounted) setState() {}

      SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.containsKey(LOGGED_TOKEN)) {
        userLoggedIn.value = true;
      }

      loading = false;
      if (mounted) setState() {}
    } on Exception catch (e) {
      String msg = "Error::HomePage::initData: ${e.toString()}";
      d.log(msg);
    }
  }

  Future<void> loginLogout(double width) async {
    try {
      if (userLoggedIn.value) {
        await userProvider.logout();
        userLoggedIn.value = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.customSnackBar(
              snackContext: context,
              isMobile: width < 700,
              width: width,
              color: greenColor,
              msg: 'Logout Successful',
              second: 3,
            ),
          );
        }
        if (mounted) setState(() {});
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } on Exception catch (e) {
      String msg = "Error::HomePage::loginLogout: ${e.toString()}";
      d.log(msg);
    }
  }

  Future<void> _pullRefresh() async {
    refreshProvider.refreshDone();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: loading
              ? Center(child: CircularProgressIndicator(color: bgColor))
              : RefreshIndicator(
                  displacement: 40,
                  onRefresh: _pullRefresh,
                  backgroundColor: bgColor,
                  color: Colors.white,
                  notificationPredicate: (n) => n.depth > 1,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          expandedHeight: 150,
                          pinned: true,
                          title: SearchContainer(),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.asset(
                              'assets/images/banner.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          actions: [
                            ValueListenableBuilder<bool>(
                              valueListenable: userLoggedIn,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    onPressed: () async {
                                      await loginLogout(width);
                                    },
                                    icon: Icon(
                                      userLoggedIn.value
                                          ? Icons.logout_rounded
                                          : Icons.login_rounded,
                                      color: bgColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 140,
                            child: Image.asset(
                              'assets/images/offer.jpeg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                          sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverAppBarDelegate(
                              TabBar(
                                indicator: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: bgColor,
                                unselectedLabelColor: greyColor.shade600,
                                labelStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: [
                                  Tab(text: "For You"),
                                  Tab(text: "Hot Deals"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },

                    body: const TabBarView(children: [ForYou(), HotDeals()]),
                  ),
                ),
        ),
      ),
    );
  }
}
