import 'dart:developer' as d;
import 'package:demo_ui/config/theme_config.dart';
import 'package:demo_ui/models/product_model.dart';
import 'package:demo_ui/pages/home_page/widgets/product_view.dart';
import 'package:demo_ui/providers/refresh_provider.dart';
import 'package:demo_ui/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HotDeals extends StatefulWidget {
  const HotDeals({super.key});

  @override
  State<HotDeals> createState() => _HotDealsState();
}

class _HotDealsState extends State<HotDeals> {
  late RefreshProvider refreshProvider;
  late ApiService apiService;
  List<ProductModel> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refreshProvider = context.read<RefreshProvider>();
    apiService = ApiService();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // adding some delay for better swipe experience
      await Future.delayed(const Duration(milliseconds: 800));
      await getProducts();
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    refreshProvider = context.watch<RefreshProvider>();
    if (mounted && refreshProvider.getRefresh) {
      await getProducts();
    }
  }

  Future<void> getProducts() async {
    try {
      loading = true;
      products.clear();
      if (mounted) setState(() {});

      ApiResponse response = await apiService.getProducts();

      if (response.data != null && mounted) {
        var dataList = response.data as List;
        products = dataList.map((el) => ProductModel.fromJson(el)).toList();
        // just to show a different view
        products.sort((a, b) => b.id.compareTo(a.id));
      }
      loading = false;
      if (mounted) setState(() {});
    } on Exception catch (e) {
      String msg = "Error::HotDeals::getProducts: ${e.toString()}";
      d.log(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: bgColor));
    }

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      //primary: false,
      key: const PageStorageKey('hotDealsScroll'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductView(product: products[index]),
              childCount: products.length,
            ),
          ),
        ),

        const SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}
