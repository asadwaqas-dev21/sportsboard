import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/core/enums/sport_type.dart";

class StandingTable extends StatelessWidget {
  final List<Standing> standings;
  final String sportTypeStr;

  const StandingTable({
    super.key,
    required this.standings,
    required this.sportTypeStr,
  });

  @override
  Widget build(BuildContext context) {
    final sportType = SportType.fromKey(sportTypeStr);

    return Card(
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          dataTextStyle: Theme.of(context).textTheme.bodyMedium,
          columns: _buildColumns(sportType),
          rows: _buildRows(sportType),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(SportType sportType) {
    final columns = [
      const DataColumn(label: Text("#")),
      const DataColumn(label: Text("Team")),
      const DataColumn(label: Text("P"), numeric: true),
      const DataColumn(label: Text("W"), numeric: true),
      const DataColumn(label: Text("L"), numeric: true),
      if (sportType.isFootball) const DataColumn(label: Text("D"), numeric: true),
      const DataColumn(label: Text("Pts"), numeric: true),
    ];

    if (sportType.isCricket) {
      columns.add(const DataColumn(label: Text("NRR"), numeric: true));
    } else if (sportType.isFootball) {
      columns.add(const DataColumn(label: Text("GD"), numeric: true));
    }

    return columns;
  }

  List<DataRow> _buildRows(SportType sportType) {
    return List.generate(standings.length, (index) {
      final standing = standings[index];
      final isTopTeam = index == 0;
      
      final cells = [
        DataCell(Text("${index + 1}", style: TextStyle(fontWeight: isTopTeam ? FontWeight.bold : null))),
        DataCell(Text(standing.teamName, style: TextStyle(fontWeight: isTopTeam ? FontWeight.bold : null))),
        DataCell(Text("${standing.played}")),
        DataCell(Text("${standing.won}")),
        DataCell(Text("${standing.lost}")),
        if (sportType.isFootball) DataCell(Text("${standing.draw}")),
        DataCell(Text("${standing.points}", style: const TextStyle(fontWeight: FontWeight.bold))),
      ];

      if (sportType.isCricket) {
        cells.add(DataCell(Text(standing.netRunRate.toStringAsFixed(2))));
      } else if (sportType.isFootball) {
        cells.add(DataCell(Text("${standing.goalDifference}")));
      }

      return DataRow(cells: cells);
    });
  }
}
