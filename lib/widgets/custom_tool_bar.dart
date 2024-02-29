import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_report.dart';

class CustomToolbar extends StatefulWidget {
  final List<ExpenseReport> data;
  final Function(List<ExpenseReport>) onSort;
  final Function(List<ExpenseReport>) onSearch;

  CustomToolbar(
      {required this.data,
      required this.onSort,
      required this.onSearch,
      Key? key})
      : super(key: key);

  @override
  _CustomToolbarState createState() => _CustomToolbarState();
}

class _CustomToolbarState extends State<CustomToolbar> {
  int? selectedValue;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: 350.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    widget.onSearch(widget.data);
                  } else {
                    List<ExpenseReport> searchData = widget.data.where((report) {
                      return report.companyName
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();

                    widget.onSearch(searchData);
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.sort,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context)!
                    .context
                    .findRenderObject() as RenderBox;
                final Offset buttonPosition =
                    button.localToGlobal(Offset.zero, ancestor: overlay);
                final double buttonWidth = button.size.width;

                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    buttonPosition.dx + buttonWidth,
                    buttonPosition.dy,
                    overlay.size.width - buttonPosition.dx,
                    overlay.size.height - buttonPosition.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      child: Text('Date'),
                      value: 'date',
                    ),
                    PopupMenuItem(
                      child: Text('Amount'),
                      value: 'amount',
                    ),
                    PopupMenuItem(
                      child: Text('Status'),
                      value: 'status',
                    ),
                  ],
                ).then((value) {
                  List<ExpenseReport> sortedData = List.from(widget.data);
                  switch (value) {
                    case 'date':
                      sortedData.sort((a, b) {
                        DateTime dateA =
                            DateFormat('MMM dd, yyyy').parse(a.dateSubmitted);
                        DateTime dateB =
                            DateFormat('MMM dd, yyyy').parse(b.dateSubmitted);
                        return dateB.compareTo(dateA);
                      });
                      break;
                    case 'amount':
                      sortedData.sort((a, b) => b.amount.compareTo(a.amount));
                      break;
                    case 'status':
                      sortedData.sort((a, b) => a.status.compareTo(b.status));
                      break;
                  }
                  widget.onSort(sortedData);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
