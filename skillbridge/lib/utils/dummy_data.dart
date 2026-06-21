import '../models/skill_model.dart';
import '../models/user_model.dart';

/// Seed data used the very first time the app runs (i.e. when there is
/// nothing yet in local storage). This simulates what would normally be
/// rows already sitting in a remote database / backend.
class DummyData {
  DummyData._();

  static List<UserModel> seedUsers() => [
        UserModel(
          id: 'u1',
          name: 'Ayesha Khan',
          email: 'ayesha@example.com',
          password: 'password123',
          location: 'F-10, Islamabad',
          bio: 'Graphic designer who loves bartering design work for home-cooked food \ud83c\udf72',
          avatarColorHex: '#6C5CE7',
          rating: 4.8,
          ratingCount: 23,
          skillsOffered: ['Logo Design', 'Poster Design'],
        ),
        UserModel(
          id: 'u2',
          name: 'Bilal Ahmed',
          email: 'bilal@example.com',
          password: 'password123',
          location: 'Bahria Town, Rawalpindi',
          bio: 'Electrician by trade, hobbyist guitarist looking to trade lessons.',
          avatarColorHex: '#0984E3',
          rating: 4.6,
          ratingCount: 15,
          skillsOffered: ['Home Wiring Repair', 'Guitar Basics'],
        ),
        UserModel(
          id: 'u3',
          name: 'Sara Malik',
          email: 'sara@example.com',
          password: 'password123',
          location: 'DHA Phase 2, Lahore',
          bio: 'Math tutor and part-time henna artist.',
          avatarColorHex: '#E17055',
          rating: 4.9,
          ratingCount: 31,
          skillsOffered: ['O/A Level Math Tutoring', 'Henna Art'],
        ),
      ];

  static List<SkillModel> seedSkills() => [
        SkillModel(
          id: 's1',
          userId: 'u1',
          title: 'Custom Logo & Brand Design',
          category: 'Design & Art',
          description:
              'I will design a clean, modern logo for your small business or personal brand. '
              'Happy to trade for home-cooked meals or fresh garden produce!',
          type: ExchangeType.skillSwap,
          wantedInExchange: 'Home-cooked meals or gardening help',
          location: 'F-10, Islamabad',
          rating: 4.8,
          completedCount: 12,
        ),
        SkillModel(
          id: 's2',
          userId: 'u2',
          title: 'Home Electrical Wiring & Repairs',
          category: 'Home Repair',
          description:
              'Licensed electrician offering switchboard repair, wiring fixes and fan/light '
              'installation. Affordable local rates, same-day service available.',
          type: ExchangeType.paidGig,
          price: 1500,
          location: 'Bahria Town, Rawalpindi',
          rating: 4.6,
          completedCount: 27,
        ),
        SkillModel(
          id: 's3',
          userId: 'u3',
          title: 'O/A Level Mathematics Tutoring',
          category: 'Tutoring',
          description:
              'Experienced tutor for O/A Level Mathematics. Weekend group sessions or '
              'one-on-one, in person or online.',
          type: ExchangeType.paidGig,
          price: 2000,
          location: 'DHA Phase 2, Lahore',
          rating: 4.9,
          completedCount: 40,
        ),
        SkillModel(
          id: 's4',
          userId: 'u2',
          title: 'Beginner Guitar Lessons',
          category: 'Music',
          description:
              'I can teach guitar basics \u2014 chords, strumming patterns and a couple of songs '
              'in a few sessions. Looking to swap for cooking lessons!',
          type: ExchangeType.skillSwap,
          wantedInExchange: 'Cooking lessons (desi food)',
          location: 'Bahria Town, Rawalpindi',
          rating: 4.4,
          completedCount: 6,
        ),
        SkillModel(
          id: 's5',
          userId: 'u3',
          title: 'Traditional Henna (Mehndi) Art',
          category: 'Events',
          description:
              'Beautiful bridal and party henna designs. Booking for weddings, Eid and small '
              'get-togethers.',
          type: ExchangeType.paidGig,
          price: 3000,
          location: 'DHA Phase 2, Lahore',
          rating: 5.0,
          completedCount: 18,
        ),
        SkillModel(
          id: 's6',
          userId: 'u1',
          title: 'Free Resume & CV Review',
          category: 'Tutoring',
          description:
              'I review and improve resumes/CVs for students and new graduates \u2014 completely '
              'free, just trying to give back to the community.',
          type: ExchangeType.free,
          location: 'F-10, Islamabad',
          rating: 4.7,
          completedCount: 9,
        ),
        SkillModel(
          id: 's7',
          userId: 'u2',
          title: 'Vegetable Garden Setup Help',
          category: 'Gardening',
          description:
              'I will help you set up a small kitchen garden on your rooftop or backyard. '
              'Open to swapping for any home repair help you can offer.',
          type: ExchangeType.skillSwap,
          wantedInExchange: 'Any small home repair help',
          location: 'Bahria Town, Rawalpindi',
          rating: 4.3,
          completedCount: 4,
        ),
        SkillModel(
          id: 's8',
          userId: 'u3',
          title: 'Basic Photography Coaching',
          category: 'Photography',
          description:
              'Learn how to use your phone or DSLR camera properly \u2014 composition, lighting '
              'and basic editing in Lightroom.',
          type: ExchangeType.paidGig,
          price: 1200,
          location: 'DHA Phase 2, Lahore',
          rating: 4.5,
          completedCount: 11,
        ),
      ];
}
