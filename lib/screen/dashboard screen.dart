import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedStarFilter = 0; // 0 means 'All'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback available yet.'));
          }

          var allDocs = snapshot.data!.docs;

          // Analytics calculations
          int totalReviews = allDocs.length;
          double totalRatingSum = 0;
          Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

          for (var doc in allDocs) {
            var data = doc.data() as Map<String, dynamic>;
            double rating = double.tryParse(data['rating']?.toString() ?? '0') ?? 0;
            totalRatingSum += rating;

            int starKey = rating.round().clamp(1, 5);
            ratingCounts[starKey] = (ratingCounts[starKey] ?? 0) + 1;
          }

          double avgRating = totalReviews > 0 ? (totalRatingSum / totalReviews) : 0;

          // Filter logic
          var filteredDocs = allDocs.where((doc) {
            if (selectedStarFilter == 0) return true;
            var data = doc.data() as Map<String, dynamic>;
            double rating = double.tryParse(data['rating']?.toString() ?? '0') ?? 0;
            return rating.round() == selectedStarFilter;
          }).toList();

          return Column(
            children: [
              // 1. Analytics Cards Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.deepPurple.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Total Reviews',
                        '$totalReviews',
                        Icons.rate_review,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'Avg Rating',
                        '${avgRating.toStringAsFixed(1)} ★',
                        Icons.star,
                        Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', 0),
                    _buildFilterChip('5 ★', 5),
                    _buildFilterChip('4 ★', 4),
                    _buildFilterChip('3 ★', 3),
                    _buildFilterChip('2 ★', 2),
                    _buildFilterChip('1 ★', 1),
                  ],
                ),
              ),

              const Divider(),

              // 3. Feedback List
              Expanded(
                child: filteredDocs.isEmpty
                    ? const Center(child: Text('No reviews match this filter.'))
                    : ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index].data() as Map<String, dynamic>;
                    String rating = data['rating']?.toString() ?? '0';
                    String review = data['review']?.toString() ?? 'No review';
                    String userName = data['userName']?.toString() ?? 'Anonymous';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.shade100,
                          child: Text('$rating★', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(review),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int starValue) {
    bool isSelected = selectedStarFilter == starValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedStarFilter = starValue;
          });
        },
      ),
    );
  }
}