# 🌆 EventFinder — Flutter App

A dark-themed event discovery app with **glassmorphism UI**, built for the internship assignment.

## 📱 Screenshots

| Explore Screen | Saved Events |
|:---:|:---:|
| ![Explore Screen](assets/screenshots/explore_screen.png) | ![Saved Events](assets/screenshots/saved_screen.png) |

## ✨ Screens Implemented

### 1. Home Screen
- Events fetched from mock API (falls back to local mock data on failure)
- Live search bar (filters by title, location, category)
- Horizontal category filter chips
- Shimmer loading state, error state with retry, empty state
- Pull-to-refresh support
- Each event card shows: image, category badge, distance, title, date/time, location, price

### 2. Event Detail Screen
- Hero image with parallax AppBar
- Animated save (heart) button with haptic feedback
- Glass info grid: date, time, venue, price
- About section with event description
- Attendee count display
- "Get Tickets" CTA button with per-category gradient color
- Modal bottom sheet on ticket tap

### 3. Saved Events Screen
- Persistent list of bookmarked events
- Swipe-to-remove gesture with undo SnackBar
- Animated empty state when no events are saved
- Quick navigation back to event details

### 4. Create Event Screen
- Interactive form with glassmorphism styling
- Custom date and time pickers
- Per-category accent color selection
- Animated submission state and success dialog

### 5. Profile & Settings
- User stats overview (Attended, Saved, Reviews)
- App preferences: Push notifications, Location, Dark mode
- Integrated access to saved events and history
- Glass-themed edit profile interface

## 🛠 Tech Stack

| Package | Purpose |
|---|---|
| `http` | API networking |
| `cached_network_image` | Efficient image loading |
| `shimmer` | Skeleton loading effect |
| `google_fonts` | Syne + Space Grotesk typography |
| `intl` | Date formatting |

## 📁 Project Structure

```
lib/
├── main.dart
├── theme.dart             # Colors, TextTheme, AppTheme
├── models/
│   └── event.dart         # Event data model + fromJson
├── services/
│   └── event_service.dart # API + fallback mock data
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── event_detail_screen.dart
│   ├── saved_events_screen.dart
│   ├── add_event_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── event_card.dart
    ├── event_card_shimmer.dart
    ├── glass_card.dart
    └── category_chip.dart
```

## 🚀 Running the App

```bash
flutter pub get
flutter run
```

## 🌐 Mock API

The service hits `https://event-finder-api.free.beeceptor.com/events`. 

**Expected JSON structure:**
```json
[
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
  }
]
```

## 💡 Key Features

- **Glassmorphism** — `BackdropFilter` + semi-transparent containers throughout
- **Per-category accent colors** — each event type gets its own color identity
- **Smooth navigation** — fade + slide page transition between screens
- **Responsive layout** — `SafeArea`, `MediaQuery.padding`, `LayoutBuilder` safe practices
- **Graceful degradation** — API failures silently fall back to rich local mock data

## ⚡ Bonus Features

- ✅ Pull-to-refresh
- ✅ Search + category filter
- ✅ Shimmer loading skeleton
- ✅ Haptic feedback
- ✅ Animated save button
