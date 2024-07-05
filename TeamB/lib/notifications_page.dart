import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final bool isExpanded;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    this.isExpanded = false,
  });
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "Geoffrey Webster replied to 'Activity Resources and Rates'",
      description:
      "Discussion Reply - PMAN 634 9040 Foundations of Project Management (2245)",
      time: "Mon at 10:55 AM",
    ),
    NotificationItem(
      title: "Chad Tulumalo replied to 'Activity Resources and Rates'",
      description:
      "Discussion Reply - PMAN 634 9040 Foundations of Project Management (2245)",
      time: "Sun at 9:48 PM",
    ),
    NotificationItem(
      title: "Benjamin Derathe started the thread 'Activity Resources and Rates'",
      description:
      "Discussion Thread Started - PMAN 634 9040 Foundations of Project Management (2245)",
      time: "June 29 at 11:35 AM",
    ),
    // Add more notifications as needed
  ];

  void _loadMoreNotifications() {
    // Logic to load more notifications
    setState(() {
      _notifications.addAll([
        NotificationItem(
          title: "Geoffrey Webster replied to 'Team Project Choice'",
          description:
          "Discussion Reply - PMAN 634 9040 Foundations of Project Management (2245)",
          time: "June 14 at 9:04 AM",
        ),
        NotificationItem(
          title: "Dixie Barrette started the thread 'Team Project Choice'",
          description:
          "Discussion Thread Started - PMAN 634 9040 Foundations of Project Management (2245)",
          time: "June 13 at 10:59 PM",
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntelliGrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create...'),
              onTap: () {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Exams'),
              onTap: () {
                Navigator.pushNamed(context, '/viewExams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Card(
                      child: ListTile(
                        title: Text(notification.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.description),
                            Text(notification.time),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
                          setState(() {
                            _notifications[index] = NotificationItem(
                              title: notification.title,
                              description: notification.description,
                              time: notification.time,
                              isExpanded: !notification.isExpanded,
                            );
                          });
                        },
                        trailing: Icon(notification.isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _loadMoreNotifications,
                child: const Text('Load More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';

class Notifications extends StatelessWidget
{
  const Notifications({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntelliGrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create...'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Exams'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/viewExams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Notifications Page Content'),
      ),
    );
  }
}*/
