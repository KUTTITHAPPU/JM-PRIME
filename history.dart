class HistoryPage extends StatelessWidget {
  // This would eventually be fetched from your Firebase 'scans' collection
  final List<Map<String, String>> scanHistory = [
    {"title": "Project Contract", "date": "12 Jan 2026", "type": "Word"},
    {"title": "Grocery Receipt", "date": "10 Jan 2026", "type": "PDF"},
    {"title": "Office Inventory", "date": "08 Jan 2026", "type": "Excel"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your History"),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: scanHistory.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                scanHistory[index]['type'] == 'Excel' ? Icons.table_chart : Icons.insert_drive_file,
                color: Colors.blue,
              ),
              title: Text(scanHistory[index]['title']!),
              subtitle: Text("Scanned on ${scanHistory[index]['date']}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Logic to re-open this specific old document
                print("Opening ${scanHistory[index]['title']}");
              },
            ),
          );
        },
      ),
    );
  }
}
