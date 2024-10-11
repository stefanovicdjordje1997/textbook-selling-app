import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.title,
    required this.items,
    required this.defaultItem,
    required this.itemDisplayValue,
    this.selectedItemDisplayValue,
    this.searchLabel,
    this.itemSearchValue,
    required this.onSaved,
  });

  final String title;
  final List<T> items;
  final T defaultItem;
  final String Function(T item) itemDisplayValue;
  final String Function(T item)? selectedItemDisplayValue;
  final String? searchLabel;
  final String Function(T item)? itemSearchValue;
  final void Function(String? value) onSaved;

  @override
  State<CustomDropdownMenu<T>> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  List<T> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.itemSearchValue != null) {
      _searchController.addListener(_filterItems);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // This methode is used when we need to apply search term and refresh the list of items
  @override
  void didUpdateWidget(covariant CustomDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  // Method for searching an item
  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        return widget.itemSearchValue!(item).toLowerCase().contains(query);
      }).toList();
    });
  }

  // Showing modal window with the list of items
  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              if (widget.searchLabel != null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: widget.searchLabel,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    T item = _filteredItems[index];
                    return ListTile(
                      title: Text(widget.itemDisplayValue(item)),
                      onTap: () {
                        setState(() {
                          _selectedItem = item;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredItems.isEmpty && widget.items.isNotEmpty) {
      _filteredItems = widget.items;
    }
    final displayItem = _selectedItem ?? widget.defaultItem;

    return TextFormField(
      readOnly: true,
      onTap: _showPicker,
      decoration: InputDecoration(
        labelText: widget.title,
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      controller: TextEditingController(
        text: widget.selectedItemDisplayValue != null
            ? widget.selectedItemDisplayValue!(displayItem)
            : widget.itemDisplayValue(displayItem),
      ),
      onSaved: widget.onSaved,
    );
  }
}
