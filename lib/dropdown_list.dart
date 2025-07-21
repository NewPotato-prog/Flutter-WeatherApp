import 'package:weather_app/weather.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/api.dart';

class MyDropDown extends StatefulWidget {
  // pass list of string an render an text button
  final String initialValue;
  final TextEditingController inputController;

  const MyDropDown({
    super.key,
    required this.initialValue,
    required this.inputController,
  });

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  // bool dropdownOverlayController.isShowing = false;
  final dropdownOverlayController = OverlayPortalController();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController inputController;
  bool showClearIcon = true; // show by default
  List content = [];

  @override
  void initState() {
    inputController = widget.inputController;
    super.initState();
    getSearchResultsFromQuery('auto:ip').then((value) {
      setState(() {
        content = value.map((item) {
          return '${item.name}, ${item.country}';
        }).toList();
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    /*  if (inputController.text == '' && !_focusNode.hasFocus) {
      setState(() {
        inputController.text = Provider.of<CurrentLocation>(
          context,
          listen: false,
        ).location;
      });
    } */
  }

  void toggleDropdown() {
    setState(() {
      dropdownOverlayController.toggle();
    });
  }

  void toggleClearIcon() {
    setState(() {
      showClearIcon = _focusNode.hasFocus && inputController.text != '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: 'toggleDropdown',
      onTapOutside: (event) {
        if (dropdownOverlayController.isShowing) toggleDropdown();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              onChanged: (value) async {
                toggleClearIcon();

                if (!dropdownOverlayController.isShowing) toggleDropdown();
                final res = await getSearchResultsFromQuery(value);
                if (res.isNotEmpty) {
                  setState(() {
                    content = res.map((location) {
                      return '${location.name}, ${location.country}';
                    }).toList();
                  });
                }
              },
              focusNode: _focusNode,
              onTapOutside: (event) {
                _focusNode.unfocus();
                inputController.text = Provider.of<CurrentLocation>(
                  context,
                  listen: false,
                ).location;
              },
              onTap: () {
                if (!dropdownOverlayController.isShowing &&
                    !_focusNode.hasFocus) {
                  toggleDropdown();
                }
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Color(0xff69D1C5),
                filled: true,
                border: InputBorder.none,
                prefixIcon: Icon(Icons.location_pin),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 2,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showClearIcon
                          ? TapRegion(
                              consumeOutsideTaps: false,
                              child: Icon(Icons.close),
                              onTapInside: (event) => {
                                inputController.clear(),
                                _focusNode.requestFocus(),
                                toggleClearIcon(),
                              },
                            )
                          : Container(),
                      TapRegion(
                        onTapInside: (event) => toggleDropdown(),
                        child: Icon(
                          dropdownOverlayController.isShowing
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            OverlayPortal(
              controller: dropdownOverlayController,
              overlayChildBuilder: (context) => Positioned(
                top: 85,
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: TapRegion(
                    groupId: 'toggleDropdown',
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Card(
                        color: Color(0xffB8E0D2),
                        child: Consumer(
                          builder: (context, value, child) => FutureBuilder(
                            initialData: content,
                            future: getSearchResultsFromQuery(
                              Provider.of<CurrentLocation>(
                                context,
                                listen: false,
                              ).location,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearProgressIndicator(),
                                    ),
                                  ],
                                );
                              }
                              return ListView.separated(
                                padding: EdgeInsets.all(8),
                                itemCount: content.length,
                                separatorBuilder: (context, index) =>
                                    Divider(color: Color(0xffCDDDDD)),
                                itemBuilder: (context, int index) {
                                  return TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Color(0xffF1E4F3),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<CurrentLocation>(
                                        context,
                                        listen: false,
                                      ).changeLocation(content[index]);
                                      inputController.text = content[index];
                                      _focusNode.unfocus();
                                      if (dropdownOverlayController.isShowing) {
                                        toggleDropdown();
                                      }
                                    },
                                    child: Text(
                                      content[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff6F5E76),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
