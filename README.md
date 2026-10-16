<div align="center">

# 🧭 CareerCompass — NeuraPath

### *AI-Powered Career Intelligence for the Next Generation*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Groq AI](https://img.shields.io/badge/Groq-LLM%20Engine-F55036?style=for-the-badge&logo=openai&logoColor=white)](https://groq.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge)](https://flutter.dev/multi-platform)

> **Research Project** · Final Year Project (FYP) · Department of Computer Science  

</div>

---

## 🔬 Research Context

> *"As AI systems grow more capable, the risk is not that machines will replace human jobs — it is that humans will stop thinking about which career path is right for them. CareerCompass was born from this concern."*

This project is part of an ongoing research initiative investigating **how generative AI can augment — rather than replace — human career decision-making**. With the accelerating pace of automation, millions of students and professionals face a paradox: more career options than ever before, yet less structured guidance to navigate them. CareerCompass addresses this gap by creating a **context-aware, role-specific AI advisory system** embedded in a mobile-first platform.

The system explores three research questions:
1. Can a fine-tuned LLM provide *domain-calibrated* career guidance across diverse educational backgrounds?
2. How can real-time job market data be integrated with AI reasoning to produce *actionable* recommendations?
3. What UI/UX patterns best support human agency when AI recommendations are involved?

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [User Roles](#-user-roles)
- [AI Engine](#-ai-engine)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Research Implications](#-research-implications)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌐 Overview

**CareerCompass (NeuraPath)** is a cross-platform mobile application built with **Flutter** and powered by a **Groq-hosted Large Language Model (LLM)**. It delivers personalized, role-aware career intelligence to three distinct user archetypes:

| User Type | Career Stage | Core AI Feature |
|-----------|-------------|-----------------|
| 🎓 **Student** | Matric → University | AI Career Path Recommendations |
| 💼 **Job Seeker** | Entry-level / Unemployed | Live Job Matching + Skill Gap Analysis |
| 🏢 **Professional** | Mid-to-Senior Career | Growth Pathway + Promotion Strategy |

The platform is **not a static job board**. It is a living, conversational career advisor that understands *who you are*, *where you are in your career journey*, and *where the market is heading* — synthesizing all three into a structured, personalized roadmap.

---

## ✨ Key Features

### 🤖 AI-Powered Intelligence
- **Contextual Career Recommendations** — The AI reads a user's full profile (education, GPA, skills, interests, major) and generates structured, role-specific guidance using a structured prompt schema
- **Skill Gap Analysis** — Compares current user skills against market-demanded competencies in real time
- **Growth Pathway Engine** — For working professionals: maps a promotion roadmap from their current job tier to their target level, including market benchmarking
- **Resume Intelligence (NeuraPath Enhancer)** — Uploads and parses PDF resumes, then returns AI-driven improvement suggestions and gap analysis using `read_pdf_text` + Groq LLM

### 📡 Real-Time Job Market Integration
- **Live Job Scraping** — Fetches real-time remote job postings from the [Remotive API](https://remotive.com/api) based on the user's skills and career interest
- **Dynamic Job Cards** — Each job listing is enriched with salary bands, experience requirements, skill tags, and direct application links
- **AI Job Matching** — The AI cross-references job descriptions with user profiles to generate a match score and highlight alignment gaps

### 👤 Smart Onboarding & Profile System
- **Role-Based Onboarding** — Users select their identity (Student / Job Seeker / Professional) and are guided through a tailored profile setup
- **Three Profile Models** — Independent Firestore data schemas for each user type, capturing education level, GPA, major, job level, years of experience, skills, and more
- **Cloudinary-Powered Media** — Profile images are uploaded and managed via [Cloudinary](https://cloudinary.com) for scalable, CDN-backed media delivery

### 🔐 Authentication & Security
- **Firebase Authentication** — Email/password sign-up with email verification flow
- **OTP Verification** — Custom OTP flow for password recovery via SMTP email service
- **Persistent Sessions** — `GetStorage` used for lightweight local state persistence between app launches

### 🎨 Modern UI/UX Design
- Clean, minimal design language with a green-accented palette
- Smooth `BouncingScrollPhysics` and `Lottie` animations for a polished feel
- `CurvedNavigationBar` for intuitive role-based navigation
- Responsive layouts supporting Android, iOS, and Web

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       Flutter App (Client)                   │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Student    │  │  Job Seeker  │  │   Professional   │  │
│  │   Module     │  │   Module     │  │     Module       │  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘  │
│         │                 │                   │             │
│  ┌──────▼─────────────────▼───────────────────▼──────────┐  │
│  │           GetX State Management (MVVM Pattern)         │  │
│  └──────────────────────────┬────────────────────────────┘  │
└─────────────────────────────┼───────────────────────────────┘
                              │
          ┌───────────────────┼──────────────────────┐
          │                   │                      │
   ┌──────▼──────┐   ┌────────▼────────┐   ┌────────▼────────┐
   │  Firebase   │   │   Groq LLM API  │   │  Remotive Jobs  │
   │  Firestore  │   │  (AI Engine)    │   │      API        │
   │  Firebase   │   │  openai-compat  │   │  (Real-time     │
   │    Auth     │   │  endpoint       │   │   job market)   │
   └──────┬──────┘   └─────────────────┘   └─────────────────┘
          │
   ┌──────▼────────┐
   │  Cloudinary   │
   │  (Media CDN)  │
   └───────────────┘
```

### Design Pattern
The application follows a strict **MVVM (Model-View-ViewModel)** architecture enforced through the **GetX** framework:

- **Models** (`/lib/model/`) — Pure data classes with `toJson`/`fromJson` for Firestore serialization
- **ViewModels** (`view_models/`) — Business logic, API calls, reactive state via `Rx` observables
- **Views** (`views/`) — Stateless UI widgets that observe ViewModel state via `Obx()`
- **Services** (`/lib/services/`) — Singleton service classes for AI, email, job scraping, connectivity, and cloud storage

---

## 👥 User Roles

### 🎓 Student
Students range from Matric (Grade 10) to University level. The system adapts its AI output based on education level:

| Education Level | AI Output |
|----------------|-----------|
| Matric | Recommended intermediate study paths |
| Intermediate | University admission and degree options |
| University | Career paths, internship tracks, post-grad options |

**Profile Fields:** `firstName`, `lastName`, `educationLevel`, `major`, `GPA`, `skills`, `interests`, `profileImageUrl`

### 💼 Job Seeker
Users actively looking for employment. The system fetches live job listings matched to their skills and provides gap analysis.

**Profile Fields:** `firstName`, `lastName`, `desiredJobTitle`, `skills`, `experienceLevel`, `expectedSalary`, `location`, `resumeUrl`

### 🏢 Professional
Working professionals aiming for promotion or career pivot. The AI generates a detailed Growth Pathway with market benchmarking.

**Profile Fields:** `firstName`, `lastName`, `currentJobTitle`, `jobLevel`, `yearsOfExperience`, `industry`, `skills`, `targetRole`

---

## 🧠 AI Engine

### LLM Integration
CareerCompass uses **Groq's ultra-low-latency inference API** with an OpenAI-compatible endpoint. The model is chosen for its balance of reasoning quality and inference speed.

```dart
// /lib/services/ai_service.dart
static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

final response = await http.post(url,
  headers: {'Authorization': 'Bearer $_apiKey'},
  body: jsonEncode({
    "model": "openai/gpt-oss-20b",
    "messages": [{"role": "user", "content": prompt}],
    "temperature": 0.7,
  }),
);
```

### Structured Prompt Schema
Each AI call uses a **structured prompt schema** that encodes the user's full profile into a constrained output format. The response is parsed using RegEx section extraction:

```
# RECOMMENDATIONS:
  - Career Path 1: Description...
  - Career Path 2: Description...

# SKILL_GAPS:
  - Missing Skill 1
  - Missing Skill 2

# ADVICE:
  Holistic career advisory text...
```

This schema ensures the AI output is **deterministic in structure** while remaining **flexible in content**, enabling reliable UI rendering without hallucination-induced layout breakage.

### Resume Intelligence
- Users upload their resume as a PDF via `file_picker`
- Text is extracted locally using `read_pdf_text`
- Extracted text is passed to the Groq LLM with a resume analysis prompt
- The AI returns scored feedback: strengths, weaknesses, missing keywords, and rewrite suggestions
- Results are rendered using `flutter_markdown` for rich, structured formatting

---

## 🛠️ Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Framework** | Flutter | `^3.x` |
| **Language** | Dart | `^3.8.1` |
| **State Management** | GetX | `^4.7.2` |
| **Backend / Auth** | Firebase Auth + Firestore | `^5.x` |
| **Cloud Functions** | Firebase Cloud Functions | `^5.6.2` |
| **AI / LLM** | Groq API (OpenAI-compatible) | REST |
| **Job Market Data** | Remotive Open API | REST |
| **Media Storage** | Cloudinary Flutter SDK | `^1.3.0` |
| **Local Storage** | GetStorage | `^2.1.1` |
| **Animations** | Lottie | `^2.7.0` |
| **PDF Parsing** | read_pdf_text | `^0.3.1` |
| **Email Service** | Mailer (SMTP) | `^6.6.0` |
| **Markdown Rendering** | flutter_markdown | `^0.7.7` |
| **Navigation** | curved_navigation_bar | `^1.0.6` |
| **Onboarding Indicators** | smooth_page_indicator | `^1.2.1` |

---

## 📁 Project Structure

```
fyp/
├── lib/
│   ├── main.dart                    # App entry point, GetX routing, Firebase init
│   ├── customs.dart                 # App-wide color tokens & constants
│   ├── firebase_options.dart        # Firebase platform configuration
│   │
│   ├── model/                       # Data layer — pure Dart models
│   │   ├── user_model.dart
│   │   ├── student_profile_model.dart
│   │   ├── job_seeker_profile_model.dart
│   │   ├── professional_profile_model.dart
│   │   └── job_model.dart
│   │
│   ├── services/                    # Service layer — external integrations
│   │   ├── ai_service.dart          # Groq LLM API client
│   │   ├── job_scraper_service.dart # Remotive API job fetcher
│   │   ├── cloudinary_service.dart  # Image/media upload service
│   │   ├── email_service.dart       # SMTP OTP email service
│   │   └── connectivity_service.dart
│   │
│   └── ui/                          # Presentation layer
│       ├── auth_screens/            # Login, Signup, OTP, Email Verification
│       ├── boarding_screen/         # Onboarding carousel
│       ├── launcher_screen/         # Splash + session restore
│       ├── category_screen/         # Role selection (Student / Job Seeker / Pro)
│       ├── profile_setup_screen/    # Role-adaptive profile form
│       ├── student/                 # Student home, profile, career recommendation
│       ├── job_seeker/              # Job seeker home, profile, job matching
│       ├── professional/            # Professional home, profile, growth pathway
│       ├── resume_enhancer/         # PDF upload + AI resume analysis
│       ├── common_screens/          # Shared screens (settings, etc.)
│       ├── custom_widgets/          # Reusable widget library
│       └── success_message_screens/
│
├── assets/
│   ├── images/                      # UI illustrations & onboarding assets
│   └── icons/                       # App icon (Android + iOS)
│
├── android/                         # Android platform project
├── ios/                             # iOS platform project
├── web/                             # Web platform project
├── firebase.json                    # Firebase hosting + functions config
├── pubspec.yaml                     # Dart dependencies & asset declarations
└── analysis_options.yaml            # Dart lint rules
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:

```bash
flutter --version   # Flutter 3.x or higher
dart --version      # Dart 3.8.1 or higher
```

Also required:
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- A Firebase project with **Firestore**, **Authentication**, and **Cloud Functions** enabled
- A [Groq API Key](https://console.groq.com) for LLM inference
- A [Cloudinary account](https://cloudinary.com) for media uploads

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/DanishR07/NeuraPath.git
cd NeuraPath
```

**2. Install Flutter dependencies**
```bash
flutter pub get
```

**3. Configure Firebase**

Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective platform directories. Then update `lib/firebase_options.dart` with your project credentials.

**4. Configure API Keys** *(see Configuration section below)*

**5. Run the application**
```bash
# Development
flutter run

# Specific platform
flutter run -d chrome        # Web
flutter run -d android       # Android emulator / device
flutter run -d ios           # iOS simulator / device
```

---

## ⚙️ Configuration

Update the following constants for your environment:

| File | Constant | Description |
|------|----------|-------------|
| `lib/services/ai_service.dart` | `_apiKey` | Your Groq API Key |
| `lib/services/cloudinary_service.dart` | `cloudName`, `uploadPreset` | Cloudinary credentials |
| `lib/services/email_service.dart` | SMTP credentials | Email service for OTP |
| `lib/firebase_options.dart` | Firebase config | Auto-generated by Firebase CLI |

> ⚠️ **Security Note:** Never commit your API keys to version control. Use `flutter_dotenv` or Firebase Remote Config for production deployments.

---

## 🔭 Research Implications

This project contributes to several active research domains:

### 1. AI-Augmented Decision Making
CareerCompass is designed with a **human-in-the-loop** philosophy. The AI does not make decisions for users — it *illuminates* options, surfacing patterns and gaps that are difficult to perceive manually. This aligns with research on *AI as a cognitive scaffold* rather than a replacement for deliberate human agency.

### 2. Personalization at Scale
The system demonstrates how **profile-conditioned LLM prompting** — without fine-tuning — can produce sufficiently personalized outputs for domain-specific advisory tasks. The structured prompt schema constrains hallucinations while preserving generative flexibility.

### 3. Cross-Stage Career Continuity
Most career platforms target a single user segment. CareerCompass models the **full career lifecycle** — from school-level academic planning to mid-career professional growth — in a unified platform. This multi-role architecture provides a unique dataset for longitudinal career trajectory research.

### 4. Real-Time Market Grounding
By integrating live job market data via the Remotive API, the AI recommendations are **grounded in current demand signals**, reducing the risk of generating career advice that is academically sound but industrially irrelevant.

---

## 🗺️ Roadmap

| Phase | Feature | Status |
|-------|---------|--------|
| v1.0 | Core authentication + role onboarding | ✅ Complete |
| v1.0 | Student career recommendation engine | ✅ Complete |
| v1.0 | Job seeker live job matching | ✅ Complete |
| v1.0 | Professional growth pathway | ✅ Complete |
| v1.0 | AI resume enhancer | ✅ Complete |
| v1.1 | Mentor matching module | 🔄 In Progress |
| v1.1 | Interview preparation AI coach | 🔄 Planned |
| v1.2 | Longitudinal career tracking dashboard | 📋 Planned |
| v2.0 | Fine-tuned domain-specific LLM | 📋 Research Phase |
| v2.0 | Peer community & networking layer | 📋 Planned |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. This project follows a standard GitHub Flow:

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

Please ensure your code passes all Flutter lint checks:
```bash
flutter analyze
flutter test
```

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Authors

**Danish Riasat**  
Computer Science · Final Year Project  
📧 [danishriasat07@gmail.com](mailto:danishriasat07@gmail.com)  
🐙 [@DanishR07](https://github.com/DanishR07)

**Usama Abbas**  
Computer Science · Final Year Project  
📧 [EMAIL_ADDRESS]](mailto:[uabbas331@gmail.com])  
🐙 [@UsamaAbbas51](https://github.com/Usama-Abbas788)

---

<div align="center">

*Built with ❤️ to prove that AI, when designed thoughtfully, makes humans think better — not less.*

**CareerCompass — NeuraPath** · © 2026 Danish Riasat, Usama Abbas

</div>
