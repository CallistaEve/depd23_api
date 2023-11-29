part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final Costs cost;
  const CardCost(this.cost);

  @override
  State<CardCost> createState() => _CardCostState();
}
class _CardCostState extends State<CardCost> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.cost;
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text("${c.service}"),
        subtitle: Text("${c.description}"),
      ),
    );
  }
}