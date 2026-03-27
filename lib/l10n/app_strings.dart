import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_provider.dart';

/// Textes traduits (FR / EN / Lingala) pour toute l’UI.
final appStringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return AppStrings(locale.languageCode);
});

class AppStrings {
  AppStrings(this.code);
  final String code;

  String _t(String fr, String en, String ln) {
    switch (code) {
      case 'en':
        return en;
      case 'ln':
        return ln;
      default:
        return fr;
    }
  }

  // ——— Commun ———
  String get commonYou => _t('Vous', 'You', 'Yo');
  String get commonCancel => _t('Annuler', 'Cancel', 'Longola');
  String get commonSave => _t('Enregistrer', 'Save', 'Bakisa');
  String get commonUnderstood => _t('Compris', 'Got it', 'Nalingi');
  String get commonBackHome => _t('Retour à l’accueil', 'Back to home', 'Kozonga na ebandelo');

  // ——— Routeur erreur ———
  String get errorPageNotFound => _t('Cette page n’existe pas.', 'This page does not exist.', 'Page oyo ezali te.');

  // ——— Onglets ———
  String get tabHome => _t('Accueil', 'Home', 'Ebandelo');
  String get tabHistory => _t('Historique', 'History', 'Makambo ya kala');
  String get tabSecurity => _t('Sécurité', 'Security', 'Libateli');
  String get tabProfile => _t('Profil', 'Profile', 'Profil');

  // ——— Connexion ———
  String get loginTagline => _t('Votre banque, protégée par l’IA', 'Your bank, protected by AI', 'Banki na yo, eye bateli na AI');
  String get loginTitle => _t('Connexion', 'Sign in', 'Kokota');
  String get loginSubtitle => _t('Accédez à votre compte sécurisé', 'Access your secure account', 'Kokota na compte oyo eye bateli');
  String get loginEmailOrPhone => _t('EMAIL OU TÉLÉPHONE', 'EMAIL OR PHONE', 'EMAIL TO TELEFONE');
  String get loginEmailHint => _t('ex: jean.mutombo@email.cd', 'e.g. jean.mutombo@email.cd', 'ex: jean.mutombo@email.cd');
  String get loginPassword => _t('MOT DE PASSE', 'PASSWORD', 'MOT DE PASSE');
  String get loginForgotPassword => _t('Mot de passe oublié ?', 'Forgot password?', 'Olibili mot de passe?');
  String get loginConnecting => _t('Connexion...', 'Signing in...', 'Kokota...');
  String get loginSignIn => _t('Se connecter', 'Sign in', 'Kokota');
  String get loginBiometric => _t('Connexion biométrique', 'Biometric sign-in', 'Kokota na biométrie');
  String get loginBiometricDisabledBtn => _t('Biométrie désactivée (Sécurité)', 'Biometrics off (Security)', 'Biométrie eye longoli (Sécurité)');
  String get loginBiometricDisabledSnack =>
      _t('La connexion biométrique est désactivée. Réactivez-la dans l’onglet Sécurité.',
          'Biometric sign-in is disabled. Enable it in the Security tab.',
          'Kokota na biométrie eye longoli. Zongisa na onglet Sécurité.');
  String get loginNoAccount => _t("Vous n'avez pas de compte ?", "Don't have an account?", 'Ozali na compte te?');
  String get loginCreateAccount => _t('Créer un compte', 'Create account', 'Bongisa compte');
  String get loginProtectedBy => _t('Protégé par RAWShield AI', 'Protected by RAWShield AI', 'Eye bateli na RAWShield AI');

  // ——— Onboarding ———
  String get onboardingSkip => _t('Passer', 'Skip', 'Kata');
  String get onboardingNext => _t('Suivant', 'Next', 'Landá');
  String get onboardingStart => _t('Commencer', 'Get started', 'Bandá');
  String get onboardingLater => _t('Commencer plus tard', 'Maybe later', 'Bandá na nsima');
  String get ob1Title => _t('Bienvenue sur RAWShield', 'Welcome to RAWShield', 'Boyei na RAWShield');
  String get ob1Subtitle => _t('Votre banque, protégée par l’IA.', 'Your bank, protected by AI.', 'Banki na yo, eye bateli na AI.');
  String get ob2Title => _t('Détection de risque', 'Risk detection', 'Koyeba risque');
  String get ob2Subtitle =>
      _t('Nous analysons les transactions pour réduire la fraude.', 'We analyse transactions to reduce fraud.', 'Tozalati transactions mpo na kokitisa fraude.');
  String get ob3Title => _t('Transferts sécurisés', 'Secure transfers', 'Transferts oyo eye bateli');
  String get ob3Subtitle =>
      _t('PIN, OTP ou biométrie selon le score de risque.', 'PIN, OTP or biometrics depending on risk score.', 'PIN, OTP to biométrie selon risque.');

  // ——— Accueil ———
  String get homeHello => _t('Bonjour,', 'Hello,', 'Mbote,');
  String get homeUserName => _t('Jean', 'Jean', 'Jean');
  String accountLabel(String currency) => _t('Compte $currency', '$currency account', 'Compte $currency');
  String get homeAvailableBalance => _t('Solde disponible', 'Available balance', 'Mbongo oyo ezali');
  String get homeExpires => _t('Expire 12/27', 'Expires 12/27', 'Ekoki 12/27');
  String get homeSend => _t('Envoyer', 'Send', 'Tinda');
  String get homeWithdraw => _t('Retirer', 'Withdraw', 'Bimisa');
  String get homeFrequentContacts => _t('Contacts fréquents', 'Frequent contacts', 'Bato oyo mbala mingi');
  String get homeRecentTx => _t('Transactions récentes', 'Recent transactions', 'Transactions ya sika');
  String get homeSeeAll => _t('Voir tout', 'See all', 'Mona nyonso');

  // ——— Historique ———
  String get historyTitle => _t('Historique', 'History', 'Makambo ya kala');
  String get historySearchHint => _t('Rechercher une transaction...', 'Search a transaction...', 'Luka transaction...');
  String get historyFilterAll => _t('Tout', 'All', 'Nyonso');
  String get historyFilterSent => _t('Envoyé', 'Sent', 'Otindaki');
  String get historyFilterReceived => _t('Reçu', 'Received', 'Ozwi');
  String get historyFilterWithdrawal => _t('Retrait', 'Withdrawal', 'Kobimisa');
  String get historyFilterBill => _t('Facture', 'Bill', 'Facture');
  String get historyStatsIn => _t('Entrées', 'In', 'Kokota');
  String get historyStatsOut => _t('Sorties', 'Out', 'Kobima');
  String get historyAllTransactions => _t('Toutes les transactions', 'All transactions', 'Transactions nyonso');
  String get historyTimeAgo => _t('Il y a 2h', '2h ago', 'Ntango 2h');

  // ——— Notifications ———
  String get notifTitle => _t('Notifications', 'Notifications', 'Notifications');
  String get notifMarkAllRead => _t('Tout marquer comme lu', 'Mark all as read', 'Tia nyonso lokola oyei');
  String get notifUnreadBanner => _t('2 notifications non lues', '2 unread notifications', '2 notifications oyo oyei te');
  String get notifToday => _t("Aujourd'hui", 'Today', 'Lelo');
  String get notif1Title => _t('Transaction bloquée', 'Transaction blocked', 'Transaction eye longoli');
  String get notif1Msg =>
      _t('RAWShield AI a détecté une activité inhabituelle sur votre compte.', 'RAWShield AI detected unusual activity on your account.',
          'RAWShield AI amoni mosala oyo eye malamu te na compte na yo.');
  String get notif2Title => _t('Code OTP requis', 'OTP code required', 'Kode OTP esengeli');
  String get notif2Msg => _t('Validez votre transaction de 250,000 CDF avec le code reçu par SMS.',
      'Confirm your 250,000 CDF transaction with the SMS code.', 'Kondima transaction na 250 000 CDF na kode ya SMS.');
  String get notif3Title => _t('Retrait effectué', 'Withdrawal completed', 'Kobimisa esalemi');
  String get notif3Msg => _t('Vous avez retiré 100,000 CDF au distributeur Gare Centrale.',
      'You withdrew 100,000 CDF at Gare Centrale ATM.', 'Obimisaki 100 000 CDF na ATM Gare Centrale.');
  String get notifTime5m => _t('Il y a 5 min', '5 min ago', 'Ntango 5 min');
  String get notifTime1h => _t('Il y a 1h', '1h ago', 'Ntango 1h');
  String get notifTime5h => _t('Il y a 5h', '5h ago', 'Ntango 5h');

  // ——— Sécurité (écran) ———
  String get secTitle => _t('Sécurité', 'Security', 'Libateli');
  String get secLevelLabel => _t('Niveau de sécurité', 'Security level', 'Niveau ya libateli');
  String get secLevelHigh => _t('ÉLEVÉ', 'HIGH', 'MALAMU');
  String get secLevelSub => _t('Votre compte est protégé par RAWShield AI', 'Your account is protected by RAWShield AI', 'Compte na yo eye bateli na RAWShield AI');
  String get secTrustTitle => _t('Score de confiance RAWShield', 'RAWShield trust score', 'Score ya confiance RAWShield');
  String get secTrustValue => _t('92/100', '92/100', '92/100');
  String get secFeaturesTitle => _t('Fonctionnalités de sécurité', 'Security features', 'Makambo ya libateli');
  String get secRawTitle => _t('RAWShield AI', 'RAWShield AI', 'RAWShield AI');
  String get secRawSub =>
      _t('Protection intelligente activée · Appuyez pour en savoir plus', 'Smart protection on · Tap to learn more',
          'Eye bateli malamu · Finá mpo na koyeba mingi');
  String get secBioTitle => _t('Authentification biométrique', 'Biometric authentication', 'Kokota na biométrie');
  String get secBioOnSub =>
      _t('Empreinte & Face ID disponibles dans l’app', 'Fingerprint & Face ID available in the app', 'Empreinte & Face ID ezali na app');
  String get secBioOffSub =>
      _t('Désactivée : plus aucune proposition biométrique', 'Off: no biometric prompts', 'Eye longoli: biométrie te');
  String get secPinTitle => _t('Mon code PIN', 'My PIN code', 'Kode PIN na ngai');
  String get secPinSub => _t('Utilisé pour valider vos transactions', 'Used to confirm your transactions', 'Esalelami mpo na kondima transactions');
  String get secPasswordTitle => _t('Mot de passe', 'Password', 'Mot de passe');
  String get secPasswordSub =>
      _t('OTP ou biométrie requis pour le modifier', 'OTP or biometrics required to change it', 'OTP to biométrie esengeli mpo na kobongola');
  String get secAlertsTitle => _t('Alertes récentes', 'Recent alerts', 'Balerte ya sika');
  String get secRawDialogBody =>
      _t('RAWShield AI est le moteur d’analyse qui protège votre compte au quotidien. '
          'Il évalue le risque de chaque transaction (montant, habitudes, contexte), '
          'déclenche des contrôles renforcés (PIN, OTP, biométrie) selon le niveau de risque, '
          'et peut bloquer une opération suspecte ou la mettre en attente pour vérification. '
          'Ces décisions visent à réduire la fraude tout en vous gardant maître de vos transferts lorsque le risque est faible.',
          'RAWShield AI is the analysis engine that protects your account every day. '
          'It assesses risk for each transaction (amount, habits, context), '
          'triggers stronger checks (PIN, OTP, biometrics) based on risk level, '
          'and can block a suspicious operation or put it on hold for verification. '
          'These decisions aim to reduce fraud while keeping you in control when risk is low.',
          'RAWShield AI ezali moteur ya analyse oyo eye bateli compte na yo mokolo na mokolo. '
          'Ezali kotala risque ya transaction (mbongo, habitudes, contexte), '
          'kobongisa bosekisi makasi (PIN, OTP, biométrie) selon risque, '
          'mpe ekoki kolongola mosala oyo eye malamu te to kotia na ntango ya vérification.');
  String get secChangePasswordTitle => _t('Changer le mot de passe', 'Change password', 'Bobongola mot de passe');
  String get secChangePasswordMsg => _t(
      'Confirmez votre identité (OTP ou biométrie si activée) avant de modifier votre mot de passe.',
      'Confirm your identity (OTP or biometrics if enabled) before changing your password.',
      'Kondima identité na yo (OTP to biométrie soki eye longoli) liboso ya kobongola mot de passe.');
  String get secNewPassword => _t('Nouveau mot de passe', 'New password', 'Mot de passe ya sika');
  String get secConfirmPassword => _t('Confirmation', 'Confirmation', 'Kondima');
  String get secPasswordUpdated => _t('Mot de passe mis à jour (simulation).', 'Password updated (simulation).', 'Mot de passe ebongwani (simulation).');
  String get secPinFlowTitle => _t('Mon code PIN', 'My PIN code', 'Kode PIN na ngai');
  String get secPinFlowMsg => _t(
      'Ce PIN sert à valider vos transactions. Confirmez votre identité avant de le modifier.',
      'This PIN confirms your transactions. Verify your identity before changing it.',
      'PIN oyo esalelami mpo na kondima transactions. Kondima identité liboso ya kobongola.');
  String get secNewPinTitle => _t('Nouveau PIN (6 chiffres)', 'New PIN (6 digits)', 'PIN ya sika (6 chiffres)');
  String get secPinLabel => _t('PIN', 'PIN', 'PIN');
  String get secPinSaved => _t('PIN transactionnel enregistré.', 'Transaction PIN saved.', 'PIN ya transaction ebakisami.');

  // Alertes sécurité (titres / sous / détails)
  String get secAlert1Title => _t('Transaction bloquée', 'Transaction blocked', 'Transaction eye longoli');
  String get secAlert1Sub => _t('Montant inhabituel détecté : 250,000 CDF', 'Unusual amount detected: 250,000 CDF', 'Mbongo oyo eye malamu te: 250 000 CDF');
  String get secAlert1Time => _t('Il y a 2 heures', '2 hours ago', 'Ntango 2 heures');
  String get secAlert1Detail => _t(
      'RAWShield AI a classé cette tentative comme à haut risque (montant et habitudes atypiques). La transaction a été bloquée avant débit. Si vous êtes à l’origine de l’opération, contactez votre agence avec une pièce d’identité pour lever le blocage ou ajuster vos plafonds.',
      'RAWShield AI flagged this attempt as high risk (amount and unusual habits). The transaction was blocked before debit. If you initiated it, visit your branch with ID to lift the block or adjust limits.',
      'RAWShield AI amoni eteni oyo lokola risque makasi. Transaction eye longoli liboso ya kobima mbongo. Soki ozali yo, kende na agence na carte ya identité.');

  String get secAlert2Title => _t('Nouvelle connexion', 'New sign-in', 'Kokota ya sika');
  String get secAlert2Sub => _t('Connexion depuis un nouvel appareil', 'Sign-in from a new device', 'Kokota na appareil ya sika');
  String get secAlert2Time => _t('Il y a 1 jour', '1 day ago', 'Mokolo 1');
  String get secAlert2Detail => _t(
      'Une connexion a été enregistrée depuis un appareil non vu récemment. Si ce n’était pas vous, changez immédiatement votre mot de passe dans Sécurité et contactez le support. RAWShield surveille les connexions pour limiter les accès frauduleux.',
      'A sign-in was recorded from a device not seen recently. If it wasn’t you, change your password in Security immediately and contact support. RAWShield monitors sign-ins to limit fraud.',
      'Kokota ezalisami na appareil oyo eye mona te. Soki ozali te, bobongola mot de passe na Sécurité mpe benga support.');

  String get secAlert3Title => _t('Mise à jour de sécurité', 'Security update', 'Mise à jour ya libateli');
  String get secAlert3Sub => _t('RAWShield AI a été mis à jour', 'RAWShield AI was updated', 'RAWShield AI ebongwani');
  String get secAlert3Time => _t('Il y a 3 jours', '3 days ago', 'Mikolo 3');
  String get secAlert3Detail => _t(
      'Les modèles de détection de fraude et de scoring de risque ont été mis à jour. Aucune action n’est requise de votre part. Vous bénéficiez en continu d’une analyse renforcée des transactions et des connexions.',
      'Fraud detection and risk scoring models were updated. No action required. You benefit from stronger ongoing analysis of transactions and sign-ins.',
      'Modele ya koyeba fraude ebongwani. Eloko te oyo esengeli. Analyse eye malamu ezali kokoba.');

  // ——— Identité (sheet OTP / biométrie) ———
  String get idConfirmTitle => _t('Confirmer votre identité', 'Confirm your identity', 'Kondima identité na yo');
  String get idConfirmBody =>
      _t('Pour modifier ce paramètre, validez votre identité.', 'To change this setting, confirm your identity.', 'Mpo na kobongola, kondima identité na yo.');
  String get idValidateOtp => _t('Valider par OTP (e-mail)', 'Verify with OTP (email)', 'Kondima na OTP (email)');
  String get idValidateBio => _t('Valider par biométrie', 'Verify with biometrics', 'Kondima na biométrie');
  String get idOtpDialogTitle => _t('Code OTP', 'OTP code', 'Kode OTP');
  String get idOtpDialogHint => _t('Un code a été envoyé (simulation). Pour la démo, le code est 123456.',
      'A code was sent (simulation). For the demo, the code is 123456.', 'Kode etindami (simulation). Na démo, kode ezali 123456.');
  String get idSendCode => _t('Envoyer le code', 'Send code', 'Tinda kode');
  String get idOtpFieldHint => _t('Code à 6 chiffres', '6-digit code', 'Kode ya 6 chiffres');
  String get idValidate => _t('Valider', 'Verify', 'Kondima');

  // ——— Détails transaction ———
  String get txnDetailsTitle => _t('Détails transaction', 'Transaction details', 'Makambo ya transaction');
  String get txnSummary => _t('Résumé', 'Summary', 'Likambo ya mokuse');
  String get txnDetailsSection => _t('Détails', 'Details', 'Makambo');
  String get txnAmount => _t('Montant', 'Amount', 'Mbongo');
  String get txnStatus => _t('Statut', 'Status', 'Statu');
  String get txnRisk => _t('Risque', 'Risk', 'Risque');
  String get txnModelConfidence => _t('Confiance modèle', 'Model confidence', 'Confiance ya modèle');
  String get txnDecision => _t('Décision', 'Decision', 'Décision');
  String get txnDate => _t('Date', 'Date', 'Mokolo');
  String get txnLocation => _t('Lieu', 'Location', 'Esika');
  String get txnSender => _t('Expéditeur', 'Sender', 'Motindisi');
  String get txnReceiver => _t('Bénéficiaire', 'Recipient', 'Mopipi');

  // Décisions / statuts mock (affichage)
  String get decisionAuth => _t('Autorisation', 'Approved', 'Elongi');
  String get decisionVerify => _t('Vérification', 'Review', 'Kotala');
  String get mockWithdrawalSender => _t('Retrait ATM', 'ATM withdrawal', 'Kobimisa ATM');
  String get mockToday => _t('Aujourd’hui 09:14', 'Today 09:14', 'Lelo 09:14');
  String get mockYesterday => _t('Hier 18:42', 'Yesterday 18:42', 'Lobi 18:42');
  String get mockYesterday1105 => _t('Hier 11:05', 'Yesterday 11:05', 'Lobi 11:05');
  String get mockTxFriendly => _t('Transfert amical', 'Friendly transfer', 'Transfert ya bonsomi');
  String get mockTxInvoice => _t('Paiement facture #1234', 'Invoice payment #1234', 'Kofuta facture #1234');
  String get mockTxGoods => _t('Achat marchandise', 'Goods purchase', 'Kozwa biloko');
  String get mockTxElectricity => _t('Facture électricité', 'Electricity bill', 'Facture ya mokili');
  String get mockLocationGareCentrale => _t('Gare Centrale', 'Central Station', 'Gare Centrale');
  String get mockLocationGombe => _t('Gombe', 'Gombe', 'Gombe');
  String get mockCompanySnel => _t('SNEL', 'SNEL', 'SNEL');

  // ——— Assistant transfert (formulaire) ———
  String get tfWizStep1 => _t('Étape 1 sur 5 : Destinataire', 'Step 1 of 5: Recipient', 'Etape 1/5: Mopipi');
  String get tfWizStep2 => _t('Étape 2 sur 5 : Montant', 'Step 2 of 5: Amount', 'Etape 2/5: Mbongo');
  String get tfWizStep3 => _t('Étape 3 sur 5 : Confirmer', 'Step 3 of 5: Confirm', 'Etape 3/5: Kondima');
  String get tfNumOrAccount => _t('Numéro ou compte', 'Phone or account', 'Telefone to compte');
  String get tfPhoneHintEnter => _t('Entrez un numéro de téléphone', 'Enter a phone number', 'Tia nimero ya telefone');
  String get tfRecent => _t('Récents', 'Recent', 'Ya sika');
  String get tfNewChip => _t('Nouveau', 'New', 'Ya sika');
  String get tfSheetNewContact => _t('Nouveau contact', 'New contact', 'Contact ya sika');
  String get tfSheetNameHint => _t('Nom du contact', 'Contact name', 'Nkombo ya contact');
  String get tfSheetPhoneHint => _t('Numéro de téléphone', 'Phone number', 'Nimero ya telefone');
  String get tfAdd => _t('Ajouter', 'Add', 'Bakisa');
  String tfAmountLabel(String currency) => _t('Montant ($currency)', 'Amount ($currency)', 'Mbongo ($currency)');
  String get tfAmountHintEx => _t('ex: 250000', 'e.g. 250000', 'ex: 250000');
  String get tfNoteOptional => _t('Motif (optionnel)', 'Note (optional)', 'Mokano (eye te obligatoire)');
  String get tfNoteHintEx => _t('ex: Transfert amical', 'e.g. Friendly transfer', 'ex: Transfert ya bonsomi');
  String get tfRawShieldWillCheck =>
      _t('RAWShield AI vérifiera la transaction avant validation.', 'RAWShield AI will check the transaction before validation.', 'RAWShield AI akotala transaction liboso.');
  String get tfRecap => _t('Récapitulatif', 'Summary', 'Likambo ya mokuse');
  String get tfRowDebitAccount => _t('Compte à débiter', 'Debit account', 'Compte oyo ebimisi');
  String get tfRowMotif => _t('Motif', 'Note', 'Mokano');
  String get tfRowPhone => _t('Téléphone', 'Phone', 'Telefone');
  String get tfValider => _t('Valider', 'Confirm', 'Kondima');
  String get tfOtpHighRiskLine =>
      _t('RAWShield AI demande une vérification (OTP) pour ce montant.', 'RAWShield AI requires verification (OTP) for this amount.', 'RAWShield AI esengeli OTP mpo na mbongo oyo.');
  String get tfOtpLowRiskLine =>
      _t('RAWShield AI est actif — validation rapide.', 'RAWShield AI is on — quick validation.', 'RAWShield AI ezali — kondima ya mike.');
  String get tfResendMailSnack =>
      _t('Nouveau code envoyé par mail.', 'A new code was sent by email.', 'Kode ya sika etindami na mail.');

  // ——— Résultat transfert (détails) ———
  String get trNewTransfer => _t('Nouveau transfert', 'New transfer', 'Transfert ya sika');
  String get trOutcomeNotAllowed => _t('Non autorisé (plafond dépassé)', 'Not allowed (limit exceeded)', 'Eye longoli (plafond eleki)');
  String get trOutcomeAutoBlock => _t('Blocage automatique', 'Automatic block', 'Eye longoli automatique');
  String get trOutcomeAdvDelay => _t('Vérification avancée (retard)', 'Advanced verification (delay)', 'Kotala ya liboso (retard)');
  String get trOutcomeAuthOk => _t('Autorisation (vérification OK)', 'Approved (checks OK)', 'Elongi (kotala malamu)');

  // ——— Retrait (écran) ———
  String get wTitle => _t('Retrait', 'Withdrawal', 'Kobimisa');
  String get wChooseMode => _t('Choisir le mode de retrait', 'Choose withdrawal mode', 'Pona lolenge ya kobimisa');
  String get wModeAtm => _t('Distributeur (ATM)', 'ATM', 'ATM');
  String get wModeAgent => _t('Agent', 'Agent', 'Agent');
  String get wAmountToWithdraw => _t('Montant à retirer', 'Amount to withdraw', 'Mbongo oyo obimisa');
  String get wBannerNotAllowed => _t('Retrait non autorisé', 'Withdrawal not allowed', 'Kobimisa eye longoli te');
  String wBannerPlafondBody(String plafondLabel) => _t(
        'Le montant dépasse le plafond autorisé de votre compte ($plafondLabel). Pour un élargissement, rendez-vous auprès de nos agences.',
        'The amount exceeds your account limit ($plafondLabel). Visit our branches to increase it.',
        'Mbongo eleki plafond ($plafondLabel). Kende na agence.',
      );
  String get wBannerPendingTitle => _t('Retrait en attente', 'Withdrawal pending', 'Kobimisa ezali na ntango');
  String wBannerPendingBody(int score) => _t(
        'Risque élevé détecté ($score/100). RAWShield va alerter les admins et traiter après vérification. En cas de réclamation, rendez-vous à l’agence.',
        'High risk detected ($score/100). RAWShield will alert admins and process after verification. For claims, visit a branch.',
        'Risque makasi ($score/100). RAWShield akotala admins. Mpo na réclamation, kende na agence.',
      );
  String get wBannerBlockedTitle => _t('Retrait bloqué', 'Withdrawal blocked', 'Kobimisa eye longoli');
  String wBannerBlockedBody(int score) => _t(
        'Risque très élevé détecté ($score/100). Transaction bloquée. En cas de réclamation, rendez-vous à l’agence.',
        'Very high risk detected ($score/100). Transaction blocked. For claims, visit a branch.',
        'Risque makasi ($score/100). Transaction eye longoli. Mpo na réclamation, kende na agence.',
      );
  String get wGenerateCode => _t('Générer le code de retrait', 'Generate withdrawal code', 'Bongisa kode ya kobimisa');
  String get wAmountDash => _t('Montant : —', 'Amount: —', 'Mbongo: —');
  String wAmountUsd(String v) => _t('Montant : $v USD', 'Amount: $v USD', 'Mbongo: $v USD');
  String wAmountCdf(String v) => _t('Montant : $v CDF', 'Amount: $v CDF', 'Mbongo: $v CDF');
  String get wWithdrawalCodeLabel => _t('Code de retrait', 'Withdrawal code', 'Kode ya kobimisa');
  String get wCopied => _t('Copié !', 'Copied!', 'Ekoki!');
  String get wCopyCode => _t('Copier le code', 'Copy code', 'Kopia kode');
  String wExpiresIn(String time) => _t('Expire dans $time', 'Expires in $time', 'Ekoki na $time');
  String get wInstructions => _t('Instructions', 'Instructions', 'Bakonzi');
  String get wStepAtm1 => _t('Rendez-vous au distributeur le plus proche', 'Go to the nearest ATM', 'Kende na ATM oyo ezali pene');
  String get wStepAgent1 => _t('Rendez-vous au point agent le plus proche', 'Go to the nearest agent point', 'Kende na point agent oyo ezali pene');
  String get wStep2 => _t('Sélectionnez "Retrait sans carte"', 'Select “Cardless withdrawal”', 'Pona "Kobimisa sans carte"');
  String get wStep3 => _t('Saisissez le code de retrait', 'Enter the withdrawal code', 'Tia kode ya kobimisa');
  String get wStep4 => _t('Récupérez votre argent', 'Collect your cash', 'Zwa mbongo na yo');
  String get wGenerateNewCode => _t('Générer un nouveau code', 'Generate a new code', 'Bongisa kode ya sika');
  String get wNeverShareCode => _t('Ne partagez jamais ce code avec qui que ce soit.', 'Never share this code with anyone.', 'Kopesa te kode na bato.');

  // ——— Transfert (général) ———
  String get transferSendMoney => _t("Envoyer de l'argent", 'Send money', 'Tinda mbongo');
  String get transferAddContact => _t('Ajouter un contact', 'Add contact', 'Bakisa contact');
  String get transferContinue => _t('Continuer', 'Continue', 'Kokoba');
  String get transferRecipientTitle => _t('Destinataire', 'Recipient', 'Mopipi');
  String get transferConfirmation => _t('Confirmation', 'Confirmation', 'Kondima');
  String get transferVerification => _t('Vérification', 'Verification', 'Kotala');
  String get unknownHolder => _t('Titulaire non identifié', 'Unknown account holder', 'Moto ya compte eye yeba te');

  // ——— Profil (existant) ———
  String get profileTitle => _t('Profil', 'Profile', 'Profil');
  String get verified => _t('Vérifié', 'Verified', 'E ndimami');
  String get accountLimitsTitle => _t('Plafonds du compte', 'Account limits', 'Bandelo ya konti');
  String get dailyTransferLimit => _t('Transfert journalier', 'Daily transfer', 'Kotinda mokolo');
  String get usedToday => _t("utilisé aujourd'hui", 'used today', 'esalelaki lelo');
  String get monthlyWithdrawal => _t('Retrait mensuel', 'Monthly withdrawal', 'Kobimisa sanza');
  String get menuPersonalInfo => _t('Informations personnelles', 'Personal information', 'Bokutani ya moto');
  String get menuPersonalInfoSub => _t('Données enregistrées à la banque', 'Data held by the bank', 'Bakisi na banki');
  String get menuPin => _t('Mon code PIN', 'My PIN code', 'Kode na ngai PIN');
  String get menuPinSub => _t('Défini dans l’onglet Sécurité', 'Set in the Security tab', 'Elongi na Sécurité');
  String get menuSettings => _t('Paramètres', 'Settings', 'Baparamètres');
  String get menuSettingsSub => _t('Notifications, langue', 'Notifications, language', 'Notifications, monoko');
  String get menuHelp => _t('Aide & Support', 'Help & Support', 'Lisalisi');
  String get menuHelpSub => _t('FAQ, contact', 'FAQ, contact', 'FAQ, appele');
  String get logout => _t('Déconnexion', 'Log out', 'Kobima');
  String get appVersion => _t('RAWShield AI v1.0.0', 'RAWShield AI v1.0.0', 'RAWShield AI v1.0.0');

  String get personalInfoTitle => _t('Informations personnelles', 'Personal information', 'Bokutani ya moto');
  String get piFullName => _t('Nom complet', 'Full name', 'Nkombo mobimba');
  String get piBirthDate => _t('Date de naissance', 'Date of birth', 'Mokolo ya botama');
  String get piBirthPlace => _t('Lieu de naissance', 'Place of birth', 'Esika ya botama');
  String get piNationality => _t('Nationalité', 'Nationality', 'Mboka');
  String get piIdType => _t('Type de pièce', 'ID type', 'Lolenge ya mukanda');
  String get piIdNumber => _t('Numéro de pièce', 'ID number', 'Numéro ya mukanda');
  String get piAddress => _t('Adresse déclarée', 'Declared address', 'Adrese oyo elongi');
  String get piPhone => _t('Téléphone', 'Phone', 'Telefone');
  String get piEmail => _t('E-mail', 'Email', 'Email');
  String get piProfession => _t('Profession', 'Profession', 'Mosala');
  String get piEmployer => _t('Employeur / activité', 'Employer / activity', 'Mosali ya mosala');
  String get piBankNote =>
      _t('Ces informations correspondent au dossier ouvert lors de la création de votre compte à la banque.',
          'These details match the file opened when your account was created at the bank.',
          'Bakonzi oyo ezali lokola dossier oyo efungwami ntango obongisaki compte na banki.');

  String get settingsTitle => _t('Paramètres', 'Settings', 'Baparamètres');
  String get pushNotifications => _t('Notifications push', 'Push notifications', 'Notifications push');
  String get pushNotificationsSub =>
      _t('Alertes et rappels sur cet appareil', 'Alerts and reminders on this device', 'Balerte na téléfone');
  String get languageTitle => _t('Langue', 'Language', 'Monoko');
  String get languageFr => _t('Français', 'French', 'Falansé');
  String get languageEn => _t('Anglais', 'English', 'Anglé');
  String get languageLn => _t('Lingala', 'Lingala', 'Lingala');

  String get helpTitle => _t('Aide & Support', 'Help & Support', 'Lisalisi');
  String get faqTitle => _t('Questions fréquentes', 'Frequently asked questions', 'Mituna mya mbala mingi');
  String get faq1q => _t('Comment sécuriser mon compte ?', 'How do I secure my account?', 'Ndenge nini nakobatela compte na ngai?');
  String get faq1a => _t(
        'Utilisez un mot de passe fort, activez la biométrie dans Sécurité et ne partagez jamais votre PIN.',
        'Use a strong password, enable biometrics in Security, and never share your PIN.',
        'Salela mot de passe makasi, tia biométrie na Sécurité mpe kopesa te PIN na bato.',
      );
  String get faq2q => _t('Que fait RAWShield AI ?', 'What does RAWShield AI do?', 'RAWShield AI esali nini?');
  String get faq2a => _t(
        'L’IA analyse le risque des transactions et adapte les contrôles (PIN, OTP, biométrie).',
        'The AI analyses transaction risk and adapts controls (PIN, OTP, biometrics).',
        'IA ezali kotala risque ya transactions mpe kobongisa controle (PIN, OTP, biométrie).',
      );
  String get callService => _t('Appeler le service', 'Call support', 'Benga service');
  String get callServiceHint => _t('Ouvre l’application téléphone avec le numéro prérempli.',
      'Opens the phone app with the number prefilled.', 'Efungola téléfone na nimero oyo ezali.');
  String get phoneLaunchError => _t('Impossible d’ouvrir l’application téléphone.', 'Could not open the phone app.', 'Efungola téléfone ezali te.');

  // ——— Retrait / snackbars (extraits) ———
  String get wPlafondSnack => _t(
      'Montant non autorisé : plafond dépassé. Pour élargissement, rendez-vous auprès des agences.',
      'Amount not allowed: limit exceeded. Visit a branch to increase limits.',
      'Mbongo eye longoli: plafond eleki. Kende na agence.');
  String get wPendingSnack => _t(
      'Retrait en attente : contrôle supplémentaire. En cas de réclamation, rendez-vous à l’agence.',
      'Withdrawal pending: extra checks. For claims, visit a branch.',
      'Kobimisa ezali na ntango: bosekisi mingi. Mpo na réclamation, kende na agence.');
  String get wBlockedSnack => _t(
      'Retrait bloqué : risque très élevé. En cas de réclamation, rendez-vous à l’agence.',
      'Withdrawal blocked: very high risk. For claims, visit a branch.',
      'Kobimisa eye longoli: risque makasi. Mpo na réclamation, kende na agence.');

  // ——— Transfert OTP / vérification ———
  String tfStepLabel(String part) => _t('Étape 4 sur 5 : $part', 'Step 4 of 5: $part', 'Etape 4/5: $part');
  String get tfStepPlafond => _t('Plafond', 'Limit', 'Plafond');
  String get tfStepBlocage => _t('Blocage', 'Blocked', 'Eye longoli');
  String get tfStepPending => _t('En attente', 'Pending', 'Na ntango');
  String get tfStepPin => _t('PIN', 'PIN', 'PIN');
  String get tfStepVerify => _t('Vérification', 'Verification', 'Kotala');
  String get tfTxNotAllowed => _t('Transaction non autorisée', 'Transaction not allowed', 'Transaction eye longoli te');
  String tfPlafondBody(String plafondLabel) => _t(
        'Votre transaction dépasse le plafond autorisé de votre compte ($plafondLabel). Pour un élargissement, rendez-vous auprès de nos agences.',
        'Your transaction exceeds your account limit ($plafondLabel). Visit our branches to increase it.',
        'Transaction na yo eleki plafond ($plafondLabel). Kende na agence mpo na kobakisa.',
      );
  String tfBlockedBody(int score) => _t(
        'RAWShield a bloqué cette transaction (risque très élevé: $score/100). En cas de réclamation, rendez-vous à l’agence.',
        'RAWShield blocked this transaction (very high risk: $score/100). For claims, visit a branch.',
        'RAWShield alongoli transaction oyo (risque makasi: $score/100). Mpo na réclamation, kende na agence.',
      );
  String get tfLabelOtp => _t('OTP', 'OTP', 'OTP');
  String get tfLabelBio => _t('Biométrie', 'Biometrics', 'Biométrie');
  String get tfPendingTitle => _t('Transaction en attente', 'Transaction pending', 'Transaction na ntango');
  String tfPendingBody(int score) => _t(
        'Risque élevé ($score/100). RAWShield va alerter les admins et traiter la transaction après vérification. En cas de réclamation, rendez-vous à l’agence.',
        'High risk ($score/100). RAWShield will alert admins and process after verification. For claims, visit a branch.',
        'Risque makasi ($score/100). RAWShield akotala admins. Mpo na réclamation, kende na agence.',
      );
  String get tfPinOnly => _t('Pour un risque faible, seul le PIN est requis.', 'For low risk, only PIN is required.', 'Mpo na risque ya mike, kaka PIN esengeli.');
  String get tfPinHint => _t('Entrez votre PIN', 'Enter your PIN', 'Tia PIN na yo');
  String get tfVerifyCodeTitle => _t('Code de vérification', 'Verification code', 'Kode ya kotala');
  String get tfVerifyCodeSub =>
      _t('Une vérification supplémentaire est requise selon le score de risque.', 'Extra verification is required based on risk score.', 'Bosekisi mingi esengeli selon risque.');
  String get tfSnackSentSms => _t('Code envoyé. Vérifiez votre SMS.', 'Code sent. Check your SMS.', 'Kode etindami. Tala SMS.');
  String get tfSendCode => _t('Envoyer le code', 'Send code', 'Tinda kode');
  String get tfResendMail => _t('Renvoyer le code (mail)', 'Resend code (email)', 'Tinda lisusu (mail)');
  String get tfTapSendFirst => _t('Appuyez d’abord sur "Envoyer le code".', 'Tap "Send code" first.', 'Finá liboso "Tinda kode".');
  String tfNeverShare(String name) => _t('Ne partagez jamais ce code/PIN. Destinataire: $name',
      'Never share this code/PIN. Recipient: $name', 'Kopesa te kode/PIN. Mopipi: $name');
  String get tfBioTitle => _t('Identification biométrique', 'Biometric verification', 'Koyeba na biométrie');
  String get tfBioSub =>
      _t('Confirmez votre identité avec votre empreinte ou Face ID.', 'Confirm with fingerprint or Face ID.', 'Kondima na empreinte to Face ID.');
  String tfRecipientLine(String name) => _t('Destinataire: $name', 'Recipient: $name', 'Mopipi: $name');
  String get tfPinWrongSnack => _t(
      'PIN incorrect. Vérifiez ou modifiez votre PIN dans Sécurité.',
      'Incorrect PIN. Check or change your PIN in Security.',
      'PIN eye malamu te. Tala to bobongola na Sécurité.');
  String get tfSnackAdminOtp => _t(
      'Alerte admin : propriétaire confirmé (OTP). Vérification en cours...',
      'Admin alert: owner confirmed (OTP). Verification in progress...',
      'Alerte admin: mokonzi eye kondi (OTP). Kotala ezali...');
  String get tfSnackBioDenied => _t('Biométrie refusée.', 'Biometrics rejected.', 'Biométrie eye longoli.');
  String get tfSnackAdminBio => _t(
      'Alerte admin : propriétaire confirmé (biométrie). Vérification en cours...',
      'Admin alert: owner confirmed (biometrics). Verification in progress...',
      'Alerte admin: mokonzi eye kondi (biométrie). Kotala ezali...');
  String get tfConfirm => _t('Confirmer', 'Confirm', 'Kondima');

  // ——— Transfert résultat ———
  String get trTitlePlafond => _t('Plafond dépassé', 'Limit exceeded', 'Plafond eleki');
  String get trTitleBlocked => _t('Transfert bloqué', 'Transfer blocked', 'Transfert eye longoli');
  String get trTitlePending => _t('Transfert en attente', 'Transfer pending', 'Transfert na ntango');
  String get trTitleOk => _t('Transfert validé', 'Transfer approved', 'Transfert eye longoli');
  String get trBodyPlafond => _t(
      'Votre transaction n\'a pas été autorisée : elle dépasse le plafond autorisé de votre compte. Pour un élargissement, rendez-vous auprès de nos agences.',
      'Your transaction was not authorised: it exceeds your account limit. Visit our branches to increase it.',
      'Transaction eye longoli te: eleki plafond. Kende na agence.');
  String get trBodyBlocked => _t(
      'RAWShield a bloqué ce transfert (risque très élevé). En cas de réclamation, rendez-vous à l\'agence.',
      'RAWShield blocked this transfer (very high risk). For claims, visit a branch.',
      'RAWShield alongoli transfert (risque makasi). Mpo na réclamation, kende na agence.');
  String get trBodyPending => _t(
      'Vérification avancée en cours. Un délai de traitement est appliqué et l\'admin est alerté. En cas de réclamation, rendez-vous à l\'agence.',
      'Advanced verification in progress. Processing delay applies and admin is alerted. For claims, visit a branch.',
      'Kotala ya liboso ezali. Admin eye alerte. Mpo na réclamation, kende na agence.');
  String get trBodyOk => _t('Votre transfert a été traité avec succès.', 'Your transfer was completed successfully.', 'Transfert na yo esalemi malamu.');
  String get trBackHome => _t('Retour à l’accueil', 'Back to home', 'Kozonga na ebandelo');
}
