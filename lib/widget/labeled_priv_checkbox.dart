import 'package:flutter/material.dart';

class LabeledPrivCheckbox extends StatefulWidget {
  final bool? value;
  final String label;
  final ValueChanged<bool?>? onChanged;
  final Function() function;

  const LabeledPrivCheckbox({
    Key? key,
    this.value,
    required this.label,
    required this.function,
    this.onChanged,
  }) : super(key: key);

  @override
  _LabeledPrivCheckboxState createState() => _LabeledPrivCheckboxState();
}

class _LabeledPrivCheckboxState extends State<LabeledPrivCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? false; // Initialize with widget value or false
  }

  @override
  void didUpdateWidget(LabeledPrivCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _value = widget.value ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onCheckedChanged(),
      child: GestureDetector(
        onTap: widget.function,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: _value,
              onChanged: (v) => _onCheckedChanged(),
            ),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckedChanged() {
    setState(() {
      _value = !_value;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_value);
    }
  }
}
