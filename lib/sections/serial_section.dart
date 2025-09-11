import 'package:flutter/material.dart';
import '../assets.dart';

class SerialSectionPage extends StatefulWidget {
  const SerialSectionPage({super.key});

  @override
  State<SerialSectionPage> createState() => _SerialSectionPageState();
}

class _SerialSectionPageState extends State<SerialSectionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Campus 1', 'Campus 2', 'Campus 3'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Serial Section',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // Filter buttons
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected 
                              ? const Color(0xFFE9E9EF) 
                              : Colors.white,
                          foregroundColor: AppColors.textColor,
                          side: BorderSide(
                            color: isSelected 
                                ? const Color(0xFFE9E9EF) 
                                : const Color(0xFFCBCBD4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          filter,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search journals...',
                  hintStyle: TextStyle(
                    color: AppColors.textColor.withOpacity(0.5),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Serial listings
              Expanded(
                child: ListView.builder(
                  itemCount: 6, // Show serial publications
                  itemBuilder: (context, index) {
                    return _buildSerialCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSerialCard(int index) {
    final serialTitles = [
      'Journal of Computer Science',
      'Nature Research',
      'IEEE Transactions',
      'Science Daily',
      'Technology Review',
      'Academic Research Quarterly',
    ];
    
    final publishers = [
      'ACM Publications',
      'Nature Publishing',
      'IEEE Society',
      'Science Media',
      'MIT Press',
      'Academic Press',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Serial icon placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9EF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCBCBD4)),
              ),
              child: const Center(
                child: Icon(
                  Icons.article,
                  color: AppColors.textColor,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Serial details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${serialTitles[index]}',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Publisher: ${publishers[index]}',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: Serial Section',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
              child: Text(
                'Available',
                style: AppTextStyles.body.copyWith(
                  fontSize: 10,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

