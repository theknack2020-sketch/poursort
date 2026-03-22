# Privacy & App Store Compliance Research — PourSort

**Date:** 2026-03-22
**Scope:** Privacy nutrition labels, age rating, App Store Review Guidelines, required metadata, content rights declaration for a casual puzzle game with no ads, no analytics, no tracking, and no third-party SDKs.

---

## 1. Privacy Nutrition Labels

### What They Are

Apple's Privacy Nutrition Labels (introduced iOS 14.3, Dec 2020) are self-reported disclosures of an app's data collection practices, displayed on every App Store product page. Developers must provide this information in App Store Connect before submitting any new app or update.

Source: https://developer.apple.com/app-store/app-privacy-details/

### PourSort's Position: "Data Not Collected"

Since PourSort:
- Has **no third-party SDKs** (no Firebase, no AdMob, no analytics)
- Has **no ads** of any kind
- Has **no user accounts** (no sign-in, no email collection)
- Has **no server-side component** (all data stays on-device)
- Uses only **StoreKit 2** (Apple's native IAP — Apple handles all payment data)
- Uses only **SwiftData** (local on-device storage)

PourSort qualifies for the cleanest possible label: **"Data Not Collected"**.

Apple's definition of "collect" is: *transmitting data off the device in a way that allows you and/or your third-party partners to access it for a period longer than what is necessary to service the transmitted request in real time.*

Since all game data (level progress, settings, IAP state) stays on-device via SwiftData, and StoreKit 2 IAP transactions are handled entirely by Apple, **nothing is "collected" under Apple's definition**.

### App Store Connect Questionnaire

When filling out privacy details in ASC, the flow is:
1. **"Do you or your third-party partners collect data from this app?"** → **No**
2. This results in the label: *"The developer does not collect any data from this app."*

No further questions are required.

### Important Caveats

- **StoreKit 2 purchase data:** Apple processes this — you are not responsible for disclosing data collected by Apple. However, if you stored purchase receipts on your own server, that would be collection. PourSort does not do this.
- **Gameplay Content:** Apple's data types include "Gameplay Content" (saved games, multiplayer matching, gameplay logic). Since PourSort saves all game state locally via SwiftData and never transmits it off-device, this does not need to be declared.
- **Privacy Manifest file:** Since Spring 2024, apps that use "Required Reason APIs" must include a privacy manifest (PrivacyInfo.xcprivacy). Even with zero third-party SDKs, check if any Apple APIs used (e.g., UserDefaults, file timestamps) fall under Required Reason APIs. If so, include the manifest with approved reason codes. This is a build-time requirement, not a nutrition label issue.

Source: https://developer.apple.com/news/upcoming-requirements/

---

## 2. Privacy Policy

### Requirement

**Every App Store app must have a privacy policy URL**, even if the app collects no data.

- Must be provided in App Store Connect metadata
- Must be accessible from within the app (typically Settings or About screen)
- Must be hosted at a publicly accessible URL

Source: App Review Guideline 5.1.1(i), https://developer.apple.com/app-store/review/guidelines/

### What PourSort's Privacy Policy Should Say

For a zero-collection app, the policy can be minimal but must exist. It should state:

1. **What data is collected:** None. PourSort does not collect, store, or transmit any personal information.
2. **Third-party services:** None. No third-party analytics, advertising, or SDKs are used.
3. **On-device data:** Game progress is stored locally on the device using Apple's SwiftData framework and is never transmitted to external servers.
4. **In-App Purchases:** Handled entirely by Apple's StoreKit. The developer does not have access to payment information.
5. **Children's privacy:** The app does not collect personal information from any user, including children.
6. **Contact information:** How to reach the developer.
7. **Changes to policy:** How updates will be communicated.

### Hosting

Options:
- A simple static page on GitHub Pages or a personal website
- A page on the app's marketing site (if one exists)

---

## 3. Privacy Manifest (PrivacyInfo.xcprivacy)

### Requirement

Since May 1, 2024, apps that don't describe their use of Required Reason APIs in a privacy manifest file are rejected by App Store Connect.

### Required Reason APIs to Check

Even a zero-SDK app may use these system APIs that require declaration:
- **UserDefaults** — if used (reason: `CA92.1` — app preferences)
- **File timestamp APIs** — if accessing file modification dates
- **System boot time / Disk space APIs** — uncommon in games
- **Active keyboard API** — uncommon in games

### Action Item

When building PourSort, run **Xcode's Privacy Report** (Product → Generate Privacy Report) to see if any Required Reason APIs are in use. If UserDefaults is used (common in SwiftUI apps), add a PrivacyInfo.xcprivacy file declaring the approved reason.

Source: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files

---

## 4. Age Rating

### Current System (iOS 26+)

Apple updated its age rating system with iOS 26 (announced July 2025). The new tiers are:
- **4+** — Contains no objectionable material
- **9+** — May contain content unsuitable for children under 9
- **13+** — May contain content unsuitable for children under 13 (replaces old 12+)
- **16+** — May contain content unsuitable for children under 16 (replaces old 17+)
- **18+** — May contain content unsuitable for children under 18

Source: https://developer.apple.com/help/app-store-connect/reference/age-ratings-values-and-definitions/

### PourSort's Rating: 4+

PourSort is a color-sorting puzzle game with:
- No violence
- No mature/suggestive themes
- No profanity
- No horror/fear themes
- No gambling (real or simulated)
- No alcohol/drug/tobacco references
- No user-generated content
- No unrestricted web access

**All content descriptor answers = "None" → Calculated rating: 4+**

### Age Rating Questionnaire (7 Steps in ASC)

The updated questionnaire covers:
1. Content descriptions (violence, sexual content, profanity, etc.)
2. In-app controls and capabilities
3. Medical or wellness content
4. Violent themes
5. Feature capabilities
6. Additional info

For PourSort, all answers will be "None" / "No" across all categories.

### Deadline

Apple required all developers to respond to updated age rating questions by **January 31, 2026**. Since PourSort is a new submission, it will go through the new questionnaire directly.

### Regional Ratings

- **Australia:** Games category apps may receive additional regional ratings from the Australian Classification Board.
- **Korea:** Games in the Games or Entertainment categories get additional ratings from GRAC (Korean Games Rating and Administration Committee).
- **Brazil:** May receive region-specific rating from MOJ.

For a 4+ game with zero objectionable content, regional ratings should align with the global 4+ rating. No special action needed.

### Kids Category (Optional)

Apps rated 4+ or 9+ are eligible for the **Kids Category**. PourSort could optionally be listed there if desired, but this imposes strict additional requirements:
- No links out of the app (without parental gate)
- No third-party analytics or advertising
- No purchasing opportunities without parental gate
- Must comply with COPPA/GDPR for children

Since PourSort has no ads, no analytics, and no links out, it **could** qualify — but the Kids Category locks in permanently once approved and adds review friction. **Recommendation: Do NOT target Kids Category for v1.** A standard 4+ Games listing is sufficient and less restrictive.

---

## 5. App Store Review Guidelines — Relevant Sections for Games

### 2.1 App Completeness
- App must be fully functional, crash-free, and testable by reviewers
- All IAP items must be visible and functional
- Backend services must be live during review (N/A for PourSort — no backend)

### 2.3 Accurate Metadata
- App name ≤ 30 characters
- Screenshots must show actual app in use (not just title art or splash screens)
- Description must accurately reflect app functionality
- If IAP exists, screenshots/description must indicate additional purchases are available
- Keywords must accurately describe the app — no keyword stuffing with competitor names
- Metadata must be appropriate for all audiences (4+ rating on metadata even if app is rated higher)

### 2.3.6 Age Rating Honesty
- Answer age rating questions honestly
- Mis-rating may trigger government regulatory inquiry

### 3.1.1 In-App Purchase
- All digital content unlocks must use Apple's IAP system
- Credits/currencies purchased via IAP may not expire
- Must have a **restore mechanism** for restorable purchases (non-consumables, subscriptions)
- If offering "loot boxes" or randomized items, must disclose odds (N/A for PourSort)

### 4.1 Copycats
- Must be original — don't copy another app's name or UI
- Cannot use another developer's icon, brand, or product name
- Ball/tube sort is a well-established genre — PourSort needs distinct visual identity and name

### 4.2 Minimum Functionality
- App must provide lasting entertainment value
- Must not be a thin wrapper or repackaged website
- PourSort with 1000+ algorithmically generated levels easily meets this bar

### 4.3 Spam
- Don't submit multiple Bundle IDs of the same app
- Category (Games → Puzzle) must not be saturated with identical clones — PourSort needs differentiation

### 5.1 Privacy
Covered in sections 1-3 above. Key points:
- Privacy policy required (in ASC metadata and in-app)
- Data minimization principle
- No account required = good (Guideline 5.1.1(v): let people use the app without login)
- No tracking = no ATT prompt needed

### 5.2 Intellectual Property
- All content must be original or licensed
- No protected third-party material (trademarks, copyrighted works)
- App icon, screenshots, marketing materials must be original

### 5.3 Gaming, Gambling, Lotteries
- PourSort has no gambling mechanics (no real-money gaming, no loot boxes)
- No sweepstakes or contests
- This section is not applicable, but confirms PourSort is in safe territory

---

## 6. Required Metadata for Submission

### App Store Connect Fields

| Field | Requirement | PourSort Notes |
|-------|-------------|----------------|
| App Name | ≤30 chars, unique | "PourSort" — 8 chars ✓ |
| Subtitle | ≤30 chars, optional but recommended | e.g. "Color Sorting Puzzle" |
| Description | Required, no max length | Describe gameplay, levels, premium model |
| Keywords | ≤100 chars total (comma-separated) | color sort, ball sort, puzzle, brain game, etc. |
| Primary Category | Required | Games → Puzzle |
| Secondary Category | Optional | Games → Casual |
| Privacy Policy URL | Required | Must point to live, accessible page |
| Support URL | Required | Contact/support page |
| Marketing URL | Optional | App website if exists |
| Screenshots | Required per device class | iPhone 6.9" and 6.7" required; iPad 13" required even for iPhone-only apps (K007) |
| App Preview | Optional (up to 3 per locale) | 15-30 sec gameplay video recommended |
| App Icon | 1024×1024 PNG, no alpha | Required in asset catalog |
| Age Rating | Via questionnaire | 4+ |
| Copyright | Required | "© 2026 [Developer Name]" |
| Version | Required | "1.0" |
| Build | Uploaded via Xcode/Transporter | — |
| Price | Set in Pricing section | Free (with IAP) or Paid |
| In-App Purchases | Configured separately | Level packs, hints, full unlock, etc. |
| Review Notes | Text for App Review team | Explain gameplay, how to test IAP |
| App Review Contact | Name, phone, email | Required |

### Screenshot Requirements

- **iPhone 6.9"** (iPhone 16 Pro Max): Required
- **iPhone 6.7"** (iPhone 15 Plus/Pro Max): Required  
- **iPad Pro 13"**: Required even for iPhone-only apps (per K007)
- 2-10 screenshots per device class
- First 3 screenshots are most visible in search results

---

## 7. Content Rights Declaration

### What It Is

During app submission in ASC, you must declare content rights:

> "Does your app contain, display, or access third-party content?"

### PourSort's Declaration

PourSort should declare:
- **All content is original** — algorithms generate levels, all art/sound/UI assets are created by the developer or properly licensed
- **No third-party content** is displayed or accessed
- **No user-generated content** is included
- **Stock assets** (if any — fonts, sound effects, icons) must be properly licensed for commercial use in mobile apps

### Checklist Before Submission

- [ ] All visual assets (icons, game graphics, UI elements) are original or licensed
- [ ] All sound effects and music are original or licensed (royalty-free with appropriate license)
- [ ] All fonts used are either system fonts (SF Pro) or properly licensed
- [ ] No Apple emoji used in the app itself (Guideline 5.2.5)
- [ ] No copyrighted game mechanics or patented ideas infringed
- [ ] App name "PourSort" doesn't infringe existing trademarks (verify via trademark search)

---

## 8. App Tracking Transparency (ATT)

### Not Required for PourSort

The ATT framework (AppTrackingTransparency) is only required when an app tracks users across other companies' apps or websites. Since PourSort:
- Has no tracking of any kind
- Has no advertising SDKs
- Has no third-party analytics
- Collects no device identifiers (IDFA)
- Shares no data with data brokers

**ATT is not applicable. No tracking prompt should be shown.**

---

## 9. Summary: Compliance Checklist

| Requirement | Status | Notes |
|-------------|--------|-------|
| Privacy Nutrition Label | ✅ Ready | "Data Not Collected" — answer "No" to data collection |
| Privacy Policy | ⬜ Needed | Create minimal policy, host at public URL, link in ASC and in-app |
| Privacy Manifest | ⬜ Check | Run Xcode Privacy Report; add if UserDefaults or other Required Reason APIs used |
| Age Rating | ✅ Ready | All "None" → 4+ rating |
| App Review Guidelines | ✅ Aligned | No violations; ensure IAP restore mechanism, accurate metadata |
| Required Metadata | ⬜ Needed | Prepare screenshots, descriptions, keywords, support URL |
| Content Rights | ✅ Ready | All original content; verify asset licenses |
| ATT / Tracking | ✅ N/A | No tracking — no prompt needed |
| COPPA / GDPR | ✅ Aligned | No data collection = minimal regulatory surface |
| Account Deletion | ✅ N/A | No accounts = no deletion requirement |

---

## 10. Sources

1. Apple — App Privacy Details: https://developer.apple.com/app-store/app-privacy-details/
2. Apple — App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
3. Apple — Age Rating Values & Definitions: https://developer.apple.com/help/app-store-connect/reference/age-ratings-values-and-definitions/
4. Apple — Updated Age Ratings (July 2025): https://developer.apple.com/news/?id=ks775ehf
5. Apple — Set an App Age Rating: https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/
6. Apple — Upcoming Requirements: https://developer.apple.com/news/upcoming-requirements/
7. Apple — Privacy Labels: https://www.apple.com/privacy/labels/
8. iOS Submission Guide — Privacy Policy Requirements: https://iossubmissionguide.com/app-store-privacy-policy-requirements
9. Wikipedia — Mobile Software Content Rating System: https://en.wikipedia.org/wiki/Mobile_software_content_rating_system
