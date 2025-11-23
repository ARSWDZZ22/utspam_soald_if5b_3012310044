class Medicine {
  final String id, name, category, imageUrl;
  final double price;

  Medicine(
      {required this.id,
      required this.name,
      required this.category,
      required this.imageUrl,
      required this.price});

  static List<Medicine> dummyMedicines = [
    Medicine(
        id: '1',
        name: 'Paracetamol 500mg',
        category: 'Pereda Nyeri',
        imageUrl:
            'https://via.placeholder.com/150/008000/FFFFFF?text=Paracetamol',
        price: 5000),
    Medicine(
        id: '2',
        name: 'Amoxicillin 500mg',
        category: 'Antibiotik',
        imageUrl:
            'https://via.placeholder.com/150/FF0000/FFFFFF?text=Amoxicillin',
        price: 15000),
    Medicine(
        id: '3',
        name: 'Vitamin C 1000mg',
        category: 'Suplemen',
        imageUrl:
            'https://via.placeholder.com/150/FFA500/FFFFFF?text=Vitamin+C',
        price: 75000),
    Medicine(
        id: '4',
        name: 'Bodrex Flu',
        category: 'Flu & Batuk',
        imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Bodrex',
        price: 12000),
    Medicine(
        id: '5',
        name: 'Antangin JRG',
        category: 'Flu & Batuk',
        imageUrl: 'https://via.placeholder.com/150/800080/FFFFFF?text=Antangin',
        price: 4000),
    Medicine(
        id: '6',
        name: 'Betadine',
        category: 'Antiseptik',
        imageUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=Betadine',
        price: 25000),
  ];
}
