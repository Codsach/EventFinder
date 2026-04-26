import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  // Mock API endpoint — replace with your Mocky/Beeceptor URL
  static const String _baseUrl =
      'https://event-finder-api.free.beeceptor.com/events';

  // Fallback mock data used when the API is unreachable
  static final List<Map<String, dynamic>> _mockData = [
    {
      'id': '1',
      'title': 'Neon Nights Music Festival',
      'category': 'Music',
      'date': 'Sat, May 10 2025',
      'time': '7:00 PM',
      'location': 'Bangalore Palace Grounds',
      'imageUrl':
          'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
      'distance': '2.4 km',
      'description':
          'An electrifying night of live music featuring top indie and electronic artists. '
              'The festival spans two stages with immersive light installations, gourmet food trucks, '
              'and an open-air dance floor. Celebrate music, art, and community under the stars at '
              'Bangalore\'s most iconic venue. Gates open at 6 PM — don\'t miss the opening act!',
      'price': 1299.0,
      'attendees': 3200,
    },
    {
      'id': '2',
      'title': 'IPL: RCB vs MI',
      'category': 'Sports',
      'date': 'Sun, May 11 2025',
      'time': '3:30 PM',
      'location': 'M. Chinnaswamy Stadium',
      'imageUrl':
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800',
      'distance': '1.1 km',
      'description':
          'The most electrifying rivalry in Indian cricket returns! Watch RCB take on Mumbai Indians '
              'in a high-stakes IPL clash at the iconic Chinnaswamy Stadium. Experience the roar of '
              '50,000 fans, live commentary, cheerleaders, and post-match performances. Book your seats '
              'early — this match always sells out within hours.',
      'price': 800.0,
      'attendees': 50000,
    },
    {
      'id': '3',
      'title': 'TechSpark Summit 2025',
      'category': 'Tech',
      'date': 'Fri, May 16 2025',
      'time': '9:00 AM',
      'location': 'NIMHANS Convention Centre',
      'imageUrl':
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      'distance': '4.7 km',
      'description':
          'Join 5000+ developers, designers, and founders for a full-day conference on AI, '
              'Web3, and the future of software. Featuring 30+ keynote speakers, hands-on workshops, '
              'hackathon zones, and a massive networking expo. Whether you\'re a student or a CTO, '
              'TechSpark is where Bangalore\'s tech community comes together.',
      'price': 499.0,
      'attendees': 5000,
    },
    {
      'id': '4',
      'title': 'Sunset Yoga & Wellness',
      'category': 'Wellness',
      'date': 'Sun, May 18 2025',
      'time': '5:00 PM',
      'location': 'Cubbon Park Open Lawn',
      'imageUrl':
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
      'distance': '0.8 km',
      'description':
          'Unwind with a guided outdoor yoga session as the sun sets over Cubbon Park. '
              'Led by certified instructors, this 90-minute session covers breathwork, asanas, '
              'and meditation. Bring your mat and a water bottle. Suitable for all skill levels. '
              'Post-session herbal teas and wellness products available from local vendors.',
      'price': 299.0,
      'attendees': 150,
    },
    {
      'id': '5',
      'title': 'Indie Art Fair: Canvas & Craft',
      'category': 'Art',
      'date': 'Sat, May 24 2025',
      'time': '11:00 AM',
      'location': '1 Shanthala Street, Indiranagar',
      'imageUrl':
          'https://images.unsplash.com/photo-1545987796-200677ee1011?w=800',
      'distance': '5.3 km',
      'description':
          'Explore a curated collection of paintings, sculptures, photography, and handcrafted goods '
              'from 80+ independent artists across Karnataka. Attend live demos, artist talks, and '
              'interactive craft sessions. A perfect day out for art lovers, collectors, and families. '
              'All purchases directly support local artists.',
      'price': 0.0,
      'attendees': 800,
    },
    {
      'id': '6',
      'title': 'Retro Arcade Night',
      'category': 'Gaming',
      'date': 'Fri, May 23 2025',
      'time': '6:00 PM',
      'location': 'Koramangala Social',
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      'distance': '3.2 km',
      'description':
          'Step back into the golden era of gaming! Over 50 retro arcade machines, '
              'NES/SNES consoles, pinball machines, and competitive Street Fighter tournaments '
              'await you. Neon lights, chiptune DJ sets, and retro-themed cocktails complete the vibe. '
              'Unlimited play wristbands available at the door.',
      'price': 599.0,
      'attendees': 400,
    },
  ];

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(
            const Duration(seconds: 8),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        return _getFallbackEvents();
      }
    } catch (_) {
      // Return fallback data on any network error
      return _getFallbackEvents();
    }
  }

  List<Event> _getFallbackEvents() =>
      _mockData.map((e) => Event.fromJson(e)).toList();
}
