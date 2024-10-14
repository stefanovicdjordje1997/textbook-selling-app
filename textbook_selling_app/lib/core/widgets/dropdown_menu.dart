import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.title,
    required this.items,
    required this.defaultItem,
    required this.itemDisplayValue,
    this.selectedItemDisplayValue,
    this.onSelectedItem,
    this.searchLabel,
    this.itemSearchValue,
    this.onSaved,
    this.validator,
    this.enabled = true,
    this.shouldResetSeletion = false,
  });

  final String title;
  final List<T> items;
  final T defaultItem;
  final String Function(T item) itemDisplayValue;
  final String Function(T item)? selectedItemDisplayValue;
  final void Function(T item)? onSelectedItem;
  final String? searchLabel;
  final String Function(T item)? itemSearchValue;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;
  final bool enabled;
  final bool shouldResetSeletion;

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

  // This method is used when we need to apply search term and refresh the list of items
  @override
  void didUpdateWidget(covariant CustomDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      if (widget.shouldResetSeletion) {
        _selectedItem = null;
      }
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
                        if (widget.onSelectedItem != null) {
                          widget.onSelectedItem!(item);
                        }
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
      enabled: widget.enabled,
      minLines: 1,
      maxLines: 3,
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
      validator: widget.validator,
    );
  }
}
