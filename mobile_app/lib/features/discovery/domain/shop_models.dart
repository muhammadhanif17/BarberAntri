class Shop {
  final String id; final String name; final double rating; final String distance;
  final String nowServing; final int waiting; final int etaMin;
  const Shop({required this.id, required this.name, required this.rating, required this.distance,
    required this.nowServing, required this.waiting, required this.etaMin});
}

/// Data dummy sesuai mockup (ganti API barbershop_service PostGIS nanti).
const mockShops = [
  Shop(id: 'shop-vintage', name: 'Vintage Cut Studio', rating: 4.8, distance: '0,8 km', nowServing: 'A-04', waiting: 4, etaMin: 15),
  Shop(id: 'shop-gentleman', name: 'Gentleman Prime', rating: 4.9, distance: '1,2 km', nowServing: 'B-11', waiting: 2, etaMin: 10),
];

class Kapster {
  final String name; final String skill; final bool available;
  const Kapster(this.name, this.skill, this.available);
}
const mockKapsters = [Kapster('Rian "The Razor"', 'Low Fade Cut', true), Kapster('Anton FadeMaster', 'French Crop', true)];

class Ticket {
  final String code; final String shopName; final int position; final int etaMin;
  const Ticket({required this.code, required this.shopName, required this.position, required this.etaMin});
}
