import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../widgets/loading_indicator.dart';

class NotificationScreen extends StatefulWidget {
  final String token; // Token otentikasi

  const NotificationScreen({super.key, required this.token});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  bool isLoading = true;
  String errorMessage = "";
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await _notificationService.checkNewAbsensi(widget.token);
      setState(() {
        notifications = response.hasNewData ? [response.message] : [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifikasi")),
      body: isLoading
          ? const LoadingIndicator()
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : notifications.isEmpty
                  ? Center(child: Text("Tidak ada notifikasi baru"))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading:
                                Icon(Icons.notifications, color: Colors.blue),
                            title: Text(notifications[index]),
                          ),
                        );
                      },
                    ),
    );
  }
}
