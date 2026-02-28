import 'package:demo_ui/components/custom_elevated_button.dart';
import 'package:demo_ui/config/strings.dart';
import 'package:demo_ui/config/theme_config.dart';
import 'package:flutter/material.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final TextEditingController _searchController = TextEditingController();
  double searchBoxHeight = 38;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return SizedBox(
      height: searchBoxHeight,
      width: width,
      child: TextFormField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        autovalidateMode: AutovalidateMode.always,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        onFieldSubmitted: (value) async {},
        decoration: InputDecoration(
          fillColor: searchBarBgColor,
          contentPadding: const EdgeInsets.only(left: 5),
          filled: true,
          border: InputBorder.none,
          hintText: SEARCH_HINT_TEXT,
          hintStyle: TextStyle(
            fontSize: 12,
            color: greyColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: width < 145
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_rounded, color: greyColor),
                    ),
                    Flexible(child: CustomElevatedButton(text: 'Search')),
                    const SizedBox(width: 5),
                  ],
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
