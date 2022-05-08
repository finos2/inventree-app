import "package:inventree/widget/back.dart";
import "package:inventree/widget/drawer.dart";
import "package:flutter/material.dart";


abstract class RefreshableState<T extends StatefulWidget> extends State<T> {

  final refreshableKey = GlobalKey<ScaffoldState>();

  // Storage for context once "Build" is called
  late BuildContext? _context;

  // Current tab index (used for widgets which display bottom tabs)
  int tabIndex = 0;

  // Bool indicator
  bool loading = false;

  bool get loaded => !loading;

  // Update current tab selection
  void onTabSelectionChanged(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  List<Widget> getAppBarActions(BuildContext context) {
    return [];
  }

  String getAppBarTitle(BuildContext context) { return "App Bar Title"; }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => onBuild(_context!));
  }

  // Function called after the widget is first build
  Future<void> onBuild(BuildContext context) async {
    refresh(context);
  }

  // Function to request data for this page
  Future<void> request(BuildContext context) async {
    return;
  }

  Future<void> refresh(BuildContext context) async {

    setState(() {
      loading = true;
    });

    await request(context);

    setState(() {
      loading = false;
    });
  }

  // Function to construct a drawer (override if needed)
  Widget getDrawer(BuildContext context) {
    return InvenTreeDrawer(context);
  }

  // Function to construct a body (MUST BE PROVIDED)
  Widget getBody(BuildContext context) {

    // Default return is an empty ListView
    return ListView();
  }

  Widget? getBottomNavBar(BuildContext context) {
    return null;
  }

  Widget? getFab(BuildContext context) {
    return null;
  }

  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(getAppBarTitle(context)),
      actions: getAppBarActions(context),
      leading: backButton(context, refreshableKey),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Save the context for future use
    _context = context;

    return Scaffold(
      key: refreshableKey,
      appBar: buildAppBar(context),
      drawer: getDrawer(context),
      floatingActionButton: getFab(context),
      body: Builder(
        builder: (BuildContext context) {
          return RefreshIndicator(
              onRefresh: () async {
                refresh(context);
              },
              child: getBody(context)
          );
        }
      ),
      bottomNavigationBar: getBottomNavBar(context),
    );
  }
}