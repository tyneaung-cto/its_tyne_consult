import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ================= ENGLISH =================
    'en_US': {
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'my_sessions': 'My Sessions',
      'my_bookings': 'My Bookings',
      'no_sessions': 'No upcoming sessions',
      'book_now': 'Book Now',
      'notifications': 'Notifications',
      'request': 'Request',

      // Setting Page
      'settings': 'Settings',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'enable_dark_theme': 'Enable dark theme',
      'language': 'Language',
      'about_section': 'About',
      'about_app': 'About ItsTyne Consult',
      'privacy_policy': 'Privacy Policy',
      'terms_conditions': 'Terms & Conditions',
      'app_version': 'App Version',
      'copyright': '© 2026 TECH4MM. All rights reserved.',

      // Drawer
      'home': 'Home',
      'profile': 'Profile',
      'request_account_deletion': 'Request Account Deletion',
      'guest': 'Guest',
      'delete_account_title': 'Delete Account',
      'delete_account_confirm': 'Are you sure you want to delete your account?',
      'delete_account_warning':
          'THIS ACTION CANNOT BE UNDONE.\nAll your data will be permanently deleted in 7 working days.',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'close': 'Close',

      // Home
      'home_welcome_title': 'Welcome to ItsTyne Consult',
      'home_welcome_subtitle':
          'Book your consultation session and get started.',

      'home_book_session': 'Book Session',
      'home_my_sessions': 'My Sessions',
      'home_view_history': 'View history',
      'home_upcoming_title': 'Upcoming Sessions',
      'home_no_upcoming': 'No upcoming sessions',
      'home_no_upcoming_desc': 'You have no scheduled consultations yet.',
      'home_book_now': 'Book Now',
      'home_how_it_works': 'How It Works',
      'home_step_1_title': 'Request a Session',
      'home_step_1_desc': 'Choose a 30 or 40 minute consultation slot',
      'home_step_2_title': 'Get Confirmation',
      'home_step_2_desc': 'We will review and confirm your request',
      'home_step_3_title': 'Join Consultation',
      'home_step_3_desc': 'Attend your session at the scheduled time',

      // Profile Page
      'profile_title': 'Profile',
      'account_information': 'Account Information',
      'actions': 'Actions',
      'full_name': 'Full Name',
      'email': 'Email',
      'role': 'Role',
      'change_password': 'Change Password',
      'profile_secure_note': 'Profile information is managed securely.',

      // Request Consultation Page
      'request_consultation': 'Request Consultation',
      'consultation_details': 'Consultation Details',
      'consultation_details_desc':
          'Please provide the details below to request your consultation session.',
      'consultation_topic': 'Consultation Topic',
      'preferred_date': 'Preferred Date',
      'preferred_time_slot': 'Preferred Time Slot',
      'session_duration': 'Session Duration',
      'additional_notes_optional': 'Additional Notes (Optional)',
      'minutes_30': '30 minutes',
      'minutes_40': '40 minutes',
      'submit_request': 'Submit Request',
      'request_confirmation_note':
          'You will receive a confirmation once your request is reviewed.',
    },

    // ================= MYANMAR =================
    'my_MM': {
      'login': 'ဝင်ရန်',
      'register': 'စာရင်းသွင်းရန်',
      'logout': 'ထွက်ရန်',
      'my_sessions': 'ကျွန်ုပ်၏ ဆက်ရှင်များ',
      'my_bookings': 'ကျွန်ုပ်၏ ဘွတ်ကင်းများ',
      'no_sessions': 'လာမည့် ဆက်ရှင် မရှိသေးပါ',
      'book_now': 'ဘွတ်ကင်းလုပ်ရန်',
      'notifications': 'အသိပေးချက်များ',
      'request': 'တောင်းဆိုရန်',

      // Settings Page
      'settings': 'ဆက်တင်များ',
      'appearance': 'အသွင်အပြင်',
      'dark_mode': 'အမှောင်မုဒ်',
      'enable_dark_theme': 'အမှောင်အပြင်အဆင် အသုံးပြုရန်',
      'language': 'ဘာသာစကား',
      'about_section': 'အကြောင်း',
      'about_app': 'ItsTyne Consult အကြောင်း',
      'privacy_policy': 'ကိုယ်ရေးကိုယ်တာ မူဝါဒ',
      'terms_conditions': 'စည်းကမ်းချက်များနှင့် သတ်မှတ်ချက်များ',
      'app_version': 'အက်ပ်ဗားရှင်း',
      'copyright': '© 2026 TECH4MM. မူပိုင်ခွင့်များအားလုံး သိမ်းဆည်းထားသည်။',

      // Drawer
      'home': 'ပင်မစာမျက်နှာ',
      'profile': 'ကိုယ်ရေးအချက်အလက်',
      'request_account_deletion': 'အကောင့်ဖျက်ရန် တောင်းဆိုမည်',
      'guest': 'ဧည့်သည်',
      'delete_account_title': 'အကောင့်ဖျက်ခြင်း',
      'delete_account_confirm': 'သင့်အကောင့်ကို ဖျက်ရန် သေချာပါသလား?',
      'delete_account_warning':
          'ဤလုပ်ဆောင်ချက်ကို ပြန်လည်မရနိုင်ပါ။\nသင့်ဒေတာအားလုံးကို ၇ ရက်အတွင်း ဖျက်သိမ်းမည်ဖြစ်သည်။',
      'cancel': 'မလုပ်တော့ပါ',
      'confirm': 'အတည်ပြုမည်',
      'close': 'ပိတ်မည်',

      // Home
      'home_welcome_title': 'ItsTyne Consult မှ ကြိုဆိုပါသည်',
      'home_welcome_subtitle': 'ဆွေးနွေးပွဲကို ကြိုတင်စာရင်းသွင်းပြီး စတင်ပါ။',
      'home_book_session': 'Session စာရင်းသွင်းရန်',
      'home_my_sessions': 'ကျွန်ုပ်၏ Sessions',
      'home_view_history': 'မှတ်တမ်းကြည့်ရန်',
      'home_upcoming_title': 'လာမည့် Sessions များ',
      'home_no_upcoming': 'လာမည့် session မရှိသေးပါ',
      'home_no_upcoming_desc': 'သင့်တွင် စီစဉ်ထားသော ဆွေးနွေးပွဲ မရှိသေးပါ။',
      'home_book_now': 'ယခု စာရင်းသွင်းရန်',
      'home_how_it_works': 'အသုံးပြုပုံ',
      'home_step_1_title': 'Session တောင်းဆိုရန်',
      'home_step_1_desc':
          '၃၀ မိနစ် သို့မဟုတ် ၄၀ မိနစ် ဆွေးနွေးချိန် ရွေးချယ်ပါ',
      'home_step_2_title': 'အတည်ပြုချက် ရယူရန်',
      'home_step_2_desc': 'သင့်တောင်းဆိုမှုကို စစ်ဆေးပြီး အတည်ပြုမည်',
      'home_step_3_title': 'ဆွေးနွေးပွဲ တက်ရောက်ရန်',
      'home_step_3_desc': 'သတ်မှတ်ထားသော အချိန်တွင် ဆွေးနွေးပွဲ တက်ရောက်ပါ',

      // Profile Page
      'profile_title': 'ပရိုဖိုင်',
      'account_information': 'အကောင့် အချက်အလက်များ',
      'actions': 'လုပ်ဆောင်ချက်များ',
      'full_name': 'အမည် အပြည့်အစုံ',
      'email': 'အီးမေးလ်',
      'role': 'အခန်းကဏ္ဍ',
      'change_password': 'စကားဝှက် ပြောင်းရန်',
      'profile_secure_note':
          'ပရိုဖိုင် အချက်အလက်များကို လုံခြုံစွာ စီမံထားပါသည်။',

      // Request Consultation Page
      'request_consultation': 'အကြံပေးဆွေးနွေးမှု တောင်းဆိုရန်',
      'consultation_details': 'ဆွေးနွေးမှု အချက်အလက်များ',
      'consultation_details_desc':
          'သင့်ဆွေးနွေးမှု တောင်းဆိုရန် အောက်ပါအချက်အလက်များကို ဖြည့်စွက်ပါ။',
      'consultation_topic': 'ဆွေးနွေးလိုသော ခေါင်းစဉ်',
      'preferred_date': 'လိုချင်သော နေ့ရက်',
      'preferred_time_slot': 'လိုချင်သော အချိန်ပိုင်း',
      'session_duration': 'ဆွေးနွေးချိန် ကြာချိန်',
      'additional_notes_optional': 'ထပ်မံမှတ်ချက်များ (မဖြစ်မနေမဟုတ်)',
      'minutes_30': 'မိနစ် ၃၀',
      'minutes_40': 'မိနစ် ၄၀',
      'submit_request': 'တောင်းဆိုမှု ပို့မည်',
      'request_confirmation_note':
          'သင့်တောင်းဆိုမှုကို စိစစ်ပြီးနောက် အတည်ပြုချက် ရရှိပါမည်။',

      
    },
  };
}
