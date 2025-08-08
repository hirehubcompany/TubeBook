import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'mypurchases/mypurchases.dart';

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic> channelData;
  final String documentId;

  const BuyNowPage({
    super.key,
    required this.channelData,
    required this.documentId,
  });

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  bool _isSubmitting = false;
  String? _paymentDocId;

  Future<void> _submitPaymentRequest() async {
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to continue.')),
        );
        return;
      }

      final paymentRef = await FirebaseFirestore.instance
          .collection('Payments')
          .add({
        'userId': user.uid,
        'channelId': widget.documentId,
        'channelName': widget.channelData['channelName'] ?? '',
        'price': widget.channelData['price'] ?? '',
        'profileImage': widget.channelData['profileImage'] ?? '',
        'monetization': widget.channelData['monetization'] ?? '',
        'category': widget.channelData['category'] ?? '',
        'country': widget.channelData['country'] ?? '',
        'channelAllTimeViews':
        widget.channelData['channelAllTimeViews'] ?? '',
        'subscribers': widget.channelData['subscribers'] ?? '',
        'attachments': widget.channelData['attachments'] ?? [],
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'channelGmail': widget.channelData['channelGmail'] ?? '',
        'whatsappNumber': widget.channelData['whatsappNumber'] ?? '',
        'channelPassword': widget.channelData['channelPassword'] ?? '',
      });

      _paymentDocId = paymentRef.id;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Payment initiated. Awaiting confirmation.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _verifyPaymentStatus() async {
    if (_paymentDocId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please initiate payment first.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Payments')
          .doc(_paymentDocId)
          .get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment record not found.')),
        );
      } else {
        final status = doc['status'];
        if (status == 'approved') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('🎉 Congratulations!'),
              content: const Text(
                'Your payment has been approved. The channel is now yours!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Mypurchases(),
                      ),
                    );
                  },
                  child: const Text('View My Channels'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
              Text('⏳ Still pending. Try again in a minute or two.'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelName = widget.channelData['channelName'] ?? 'N/A';
    final price = widget.channelData['price'] ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Complete Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Instructions Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.payment, size: 26, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Payment Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Please make payment to the following Binance ID:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'BINANCE ID: 880136964',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Account Name: Milliwork Company',
                            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Channel Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.tv, color: Colors.black),
                      title: const Text('Channel Name'),
                      subtitle: Text(channelName),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.price_check, color: Colors.green),
                      title: const Text('Price'),
                      subtitle: Text(price),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitPaymentRequest,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('I Have Paid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _verifyPaymentStatus,
                    icon: const Icon(Icons.verified),
                    label: const Text('Verify Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
