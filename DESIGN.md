# ReFind design

A mobile-first community lost-and-found app based on the supplied 23-screen reference. Flutter/Dart powers the interface; Python is a suitable later backend choice, particularly for image processing.

## Visual system

- Indigo primary #6055F5; navy text #191B43; cool off-white canvas #F8F9FF.
- Mint for found reports and coral for lost reports, always accompanied by text.
- Rounded cards, generous spacing, Material icons, restrained illustrations.
- Dark welcome screen; light task screens; four persistent destinations: Home, Reports, Explore, Profile.
- Forms and lists scroll; content is capped at 540 logical pixels on larger screens.

## Screen flow

Welcome → three onboarding pages → login/registration demo → permissions explanation → Home.

Home → lost/found report → details → location → review → My Reports → item details → recovery confirmation.

Home → sample image matching → sample result → details → contact explanation.

Explore → illustrative map → manual route → route summary.

Profile → My Reports / Settings / Help and safety.

Validation, empty search/report states, and matching loading state are implemented. A network error/retry state belongs with the future API integration; this local prototype does not simulate a real connection failure.

## Integration boundary

Reports are session-only. Account forms validate locally, without authenticating or storing credentials. Location permissions, uploads, real maps, messaging, push notifications, persistence and AI matching are not implemented. These limits are stated in the interface. Sample reports are fictional and contain no real contact details.

## Next production work

1. Choose backend and authentication provider; define report ownership and access rules.
2. Persist reports and photos; add moderation and private ownership-verification details.
3. Connect maps, user-triggered permissions and location search.
4. Add private messaging and recovery confirmation for both parties.
5. Evaluate image matching with real test data before presenting match scores.
6. Add account deletion, privacy controls, localization and device accessibility checks.
