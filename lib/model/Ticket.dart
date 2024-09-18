import 'dart:convert';


class Ticket {
  final String departure;
  final String destination;
  final String flightNumber; // Flight number
  final String seatNumber;   // Seat number
  final double price;        // Price
  final DateTime departureTime; // Departure time
  final DateTime arrivalTime;   // Arrival time
  final String status;       // Status

  Ticket({
    required this.departure,
    required this.destination,
    required this.flightNumber,
    required this.seatNumber,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    this.status = 'available',
  });

  Map<String, dynamic> toMap() {
    return {
      'departure' : departure,
      'destination' : destination,
      'flight_number': flightNumber,
      'seat_number': seatNumber,
      'price': price,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) {
    final data = json.decode(source);
    return Ticket(
      departure: data['departure'],
      destination: data['destination'],
      flightNumber: data['flight_number'],
      seatNumber: data['seat_number'],
      price: data['price'].toDouble(),
      departureTime: DateTime.parse(data['departure_time']),
      arrivalTime: DateTime.parse(data['arrival_time']),
      status: data['status'],
    );
  }
}