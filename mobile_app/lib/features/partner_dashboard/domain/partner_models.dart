/// Model B2B sesuai mockup Partner Suite Layar 01-06.
enum SeatStatus { serving, ready, break_ }

class KapsterSeat {
  final String name; final String desc; final SeatStatus status; final String info;
  const KapsterSeat(this.name, this.desc, this.status, this.info);
}

class PartnerTicket {
  final String id; final String code; final String customer; final String phone;
  final String service; final int price; final String kapster;
  final bool isWalkIn; final String status; // SERVING | READY | WAITING
  const PartnerTicket({required this.id, required this.code, required this.customer,
    required this.phone, required this.service, required this.price,
    required this.kapster, this.isWalkIn = false, this.status = 'WAITING'});
}

class ServiceItem {
  final String name; final String duration; final int price;
  const ServiceItem(this.name, this.duration, this.price);
}

class KapsterPerf {
  final String name; final int guests; final int revenue;
  const KapsterPerf(this.name, this.guests, this.revenue);
}

// Dummy 1:1 mockup — ganti API queue-engine / barbershop_service nanti.
const mockSeats = [
  KapsterSeat('Rian "The Razor"', 'Kursi 01 • Sedang cukur A-06', SeatStatus.serving, 'Sibuk (~12mnt)'),
  KapsterSeat('Anton FadeMaster', 'Kursi 02 • Bersiap A-08', SeatStatus.ready, 'Siap Panggil'),
  KapsterSeat('Ben Junior', 'Kursi 03 • Istirahat', SeatStatus.break_, 'Break (15mnt)'),
];

const mockPartnerQueue = [
  PartnerTicket(id: 'q-06', code: 'A-06', customer: 'Rian: Fade Cut', phone: '', service: 'Low Fade Cut', price: 50000, kapster: 'Rian', status: 'SERVING'),
  PartnerTicket(id: 'q-08', code: 'A-08', customer: 'Gabriel Kevin', phone: '+62 812-8599-7721', service: 'French Crop + Hair Wash', price: 55000, kapster: 'Anton', status: 'READY'),
  PartnerTicket(id: 'q-09', code: 'A-09', customer: 'Budi Santoso', phone: '0813-2244-9988', service: 'Classic Cut', price: 50000, kapster: 'Rian', isWalkIn: true),
  PartnerTicket(id: 'q-10', code: 'A-10', customer: 'Farhan Malik', phone: '', service: 'Fade + Shaving', price: 60000, kapster: 'Anton'),
];

const mockServices = [
  ServiceItem('Low Fade Cut', 'Estimasi: 25 Menit', 50000),
  ServiceItem('French Crop', 'Estimasi: 30 Menit', 55000),
];

const mockPerf = [
  KapsterPerf('Rian (16 Tamu)', 16, 450000),
  KapsterPerf('Anton (14 Tamu)', 14, 480000),
  KapsterPerf('Ben (6 Tamu)', 6, 120000),
];
