import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'buy now.dart';

class HomepageDetails extends StatefulWidget {
  final String documentId; // Pass the Firestore doc ID to view

  const HomepageDetails({super.key, required this.documentId, required Map<String, dynamic> channelData, });

  @override
  State<HomepageDetails> createState() => _HomepageDetailsState();
}

class _HomepageDetailsState extends State<HomepageDetails> {
  late Future<DocumentSnapshot> _channelData;

  @override
  void initState() {
    super.initState();
    _channelData = FirebaseFirestore.instance
        .collection('HomepageChannels')
        .doc(widget.documentId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Details'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _channelData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Channel not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final channelName = data['channelName'] ?? 'Channel Name';
          final subtitle = data['subtitle'] ?? '';
          final description = data['description'] ?? '';
          final profileImage = data['profileImage'] ?? '';
          final attachments = List<String>.from(data['attachments'] ?? []);
          final subscribers = data['subscribers']?.toString() ?? '0';
          final price = data['price']?.toString() ?? '0';
          final monetization = data['monetization']?.toString() ?? 'No';
          final category = data['category'] ?? '';
          final channelAllTimeViews = data['channelAllTimeViews'] ?? '';
          final country = data['country'] ?? '';


          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Title
                Text(
                  channelName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800]),
                ),


                const SizedBox(height: 20),

                // Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(profileImage),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channelName,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                children: [
                                  Icon(Icons.verified,
                                      color: Colors.green, size: 18),
                                  SizedBox(width: 4),
                                  Text('Ownership Verified', style: TextStyle(
                                    fontSize: 8
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(label: 'Followers', value: subscribers),
                          _StatItem(label: 'Price (\$)', value: price),
                          _StatItem(label: 'Monetization', value: '$monetization'),
                          _StatItem(label: 'Category', value: category),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Channel Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

                Text(
                  description,
                  style: const TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 24),


                Text('Channel All Time Views',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  channelAllTimeViews,
                  style: const TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 24),

                Text('Country',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  country,
                  style: const TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 24),


                const Text(
                  'Attachment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: attachments.map((url) {
                    return Builder(
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Buy Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyNowPage(
                          channelData: data,
                          documentId: widget.documentId,
                        ),
                      ),
                    );
                  },

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
