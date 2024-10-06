import 'package:flutter/material.dart';

class LabeledTermCheckbox extends StatefulWidget {
  final bool? value;
  final String label;
  final ValueChanged<bool?>? onChanged;
  final String route;
  final Function() function;

  const LabeledTermCheckbox({
    Key? key,
    this.value,
    required this.label,
    required this.route,
    required this.function,
    this.onChanged,
  }) : super(key: key);

  @override
  _LabeledTermCheckboxState createState() => _LabeledTermCheckboxState();
}

class _LabeledTermCheckboxState extends State<LabeledTermCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? false; // Initialize with widget value or false
  }

  @override
  void didUpdateWidget(LabeledTermCheckbox oldWidget) {
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
