import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['For You', 'Men', 'Women', 'Jackets', 'Shoes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 2,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black38,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Explore'),
                ],
              ),
              Container(height: 1, color: Colors.black12),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildCategoryChips(),
            _buildFeaturedCard(),
            _buildSectionHeader('For You:'),
            _buildStaggeredGrid(),
            const SizedBox(height: 30),
            _buildWideFeaturedProduct(),
            const SizedBox(height: 30),
            _buildSecondaryGrid(),
            const SizedBox(height: 100), // Space for bottom navbar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.search, color: Colors.black26, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Search your product...',
                    style: TextStyle(color: Colors.black26, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChoiceChip(
              label: Text(_categories[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategoryIndex = index);
              },
              selectedColor: AppTheme.primaryBlue,
              backgroundColor: const Color(0xFFF5F5F5),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: BorderSide.none,
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/images/Group 893.png',
              width: double.infinity,
              height: 450,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Emerging Designers',
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Explore small businesses and discover unique,\none-of-a-kind looks.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B2A),
              minimumSize: const Size(160, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Shop Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 25),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStaggeredGrid() {
    final List<Map<String, String>> products = [
      {'title': 'Box Fit Minecraft Tee', 'price': 'R4 999.99', 'image': 'assets/images/Rectangle Copy 2.png', 'store': 'Store Name'},
      {'title': 'Box Fit Minecraft Tee', 'price': 'R4 999.99', 'image': 'assets/images/Group 893.png', 'store': 'Store Name'},
      {'title': 'Colour Between...', 'price': 'R16 999.99', 'image': 'assets/images/Rectangle 569.png', 'store': 'Store Name'},
      {'title': 'A-H-D Oversized Tee', 'price': 'R899.99', 'image': 'assets/images/Rectangle Copy 2.png', 'store': 'Store Name'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildStaggeredProductCard(product, index);
        },
      ),
    );
  }

  Widget _buildStaggeredProductCard(Map<String, String> product, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                product['image']!,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    product['price']!,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(radius: 8, backgroundColor: AppTheme.primaryBlue),
            const SizedBox(width: 6),
            Text(product['store']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          product['title']!,
          style: const TextStyle(fontSize: 11, color: Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildWideFeaturedProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Mask.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 40,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 15, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(radius: 12, backgroundColor: AppTheme.primaryBlue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Nike - Off White Air Prestos [Virgil Abloh 2019]',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.black45),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'R4 999.99',
                style: TextStyle(fontSize: 10, color: Colors.black45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          // Row 1 Left
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 220,
            child: _buildSecondaryProductTile(
              'assets/images/IMG_9886 1.png',
              '\'No Breeze\' Wind Br...',
              'R16 999.99',
            ),
          ),
          // Row 1 Right
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 280,
            child: _buildSecondaryProductTile(
              'assets/images/IMG-9897 1.png',
              '\'No Breeze\' Wind Br...',
              'R16 999.99',
            ),
          ),
          // Row 2 Left
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 130,
            child: _buildInformativeCard('Exclusively\non Swéy...', Icons.north_east),
          ),
          // Row 2 & 3 Right (Tall)
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 500,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/IMG_9886 2.png', // Reusing tall version
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          // Row 3 Left
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 250,
            child: _buildSecondaryProductTile(
              'assets/images/Group 894.png',
              '\'No Breeze\' Wind Br...',
              'R16 999.99',
            ),
          ),
          // Row 4 Left
          StaggeredGridTile.extent(
            crossAxisCellCount: 1,
            mainAxisExtent: 130,
            child: _buildInformativeCard('Grab the best!', Icons.north_east),
          ),
        ],
      ),
    );
  }

  Widget _buildInformativeCard(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryProductTile(String image, String title, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(radius: 6, backgroundColor: AppTheme.primaryBlue),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 9, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavbar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavbarItem(Icons.home, 'Shop', true),
          _buildNavbarItem(Icons.shopping_cart_outlined, 'Cart', false),
          _buildNavbarItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavbarItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? AppTheme.primaryBlue : Colors.black38),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isSelected ? AppTheme.primaryBlue : Colors.black38)),
      ],
    );
  }
}
