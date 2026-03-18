import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'services/api_service.dart';

class QRScannerPage extends StatefulWidget {
  final String coachUsername;
  final String? sportCategory;
  final String? role;

  const QRScannerPage({
    super.key,
    required this.coachUsername,
    this.sportCategory,
    this.role,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isScanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      
      if (code != null) {
        setState(() {
          isScanning = true;
        });
        
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Send to API
        print('=== SCAN DEBUG ===');
        print('Coach: ${widget.coachUsername}');
        print('Sport Category: ${widget.sportCategory}');
        print('Role: ${widget.role}');
        print('QR Code: $code');

        final result = await ApiService.scanQR(
          code,
          widget.coachUsername,
          'gate',
          sportCategory: widget.sportCategory,
          role: widget.role,
        );

        print('API Response: $result');
        print('==================');

        // Close loading
        if (mounted) Navigator.pop(context);

        // Show result
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    result['success'] ? Icons.check_circle : Icons.error,
                    color: result['success'] ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result['success'] ? 'Success!' : 'Error',
                      style: TextStyle(
                        color: result['success'] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result['success'] && result['data'] != null) ...[
                    // Success message with green background
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.green[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  result['message'] ?? 'Status updated',
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Student info
                    Text(
                      result['data']['student']['fullname'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.business, 'Division', result['data']['student']['division']),
                    _buildInfoRow(Icons.sports, 'Event', result['data']['student']['event'] ?? 'N/A'),
                    const SizedBox(height: 12),
                    
                    // Status info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.login, 'Time In', result['data']['time_in'] ?? 'N/A'),
                          _buildInfoRow(Icons.logout, 'Time Out', result['data']['time_out'] ?? 'N/A'),
                          _buildInfoRow(Icons.access_time, 'Scanned', result['data']['scan_time'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Error message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        result['message'] ?? 'Unknown error',
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (result['data'] != null && result['data']['student'] != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        result['data']['student']['fullname'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isScanning = false;
                    });
                  },
                  child: Text(
                    'Scan Again',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true); // Return true to refresh dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          // Overlay with scanning frame
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Align QR code within the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
