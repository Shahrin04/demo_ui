# demo_ui

1. How horizontal swipe was implemented

- The horizontal swipe is implemented through Controller Synchronization and Axis Isolation:

i. Coordinated Control
The DefaultTabController provides a shared TabController linking the TabBar (header) and TabBarView (body). Swiping the body updates the controller index, which simultaneously moves the header indicator.

ii. Internal PageView
The TabBarView acts as a specialized PageView. It utilizes a HorizontalDragGestureRecognizer to capture sideways movement while ignoring vertical scrolls.

iii. Axis Separation
Flutter separates gestures by axis. The NestedScrollView manages vertical scrolling for the entire page, while the TabBarView handles horizontal transitions between the ForYou and HotDeals widgets.



2. Who owns the vertical scroll and why

- The NestedScrollView owns the vertical scroll to act as a master coordinator between the header and the body.
  It manages two distinct areas:

i. Outer Scroll: Controls the SliverAppBar (banner) and the SliverPersistentHeader (the TabBar).

ii. Inner Scroll: Controls the product lists within the ForYou and HotDeals widgets.

The NestedScrollView is used to prevent Nested Scroll Conflicts. Without a master controller, the inner list would scroll independently, leaving the header stuck or unreachable. It merges the header and body into a single, continuous scrollable surface. Using the SliverOverlapAbsorber, it calculates exactly when the TabBar should pin to the top of the screen.

