import 'package:flutter/material.dart';

class DividendSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const DividendSearchBar({super.key, required this.onSearch});

  @override
  State<DividendSearchBar> createState() => _DividendSearchBarState();
}

class _DividendSearchBarState extends State<DividendSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter stock symbol (e.g., BANPU)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onSearch(value);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSearch(_controller.text);
            }
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
} 