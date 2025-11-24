import 'dart:io';

// CLASSE Joueur (Mariel)
class Joueur {
  String nom;
  int score;
  List<String> motsProposes;
  List<String> lettresDejaProposees;

  Joueur(this.nom)
      : score = 0,
        motsProposes = [],
        lettresDejaProposees = [];

  void incrementerScore() {
    score++;
    print("$nom marque un point! Score: $score");
  }

  String saisirMot() {
    print("$nom, veuillez saisir un mot à faire deviner:");
    String mot = _lireEntree();
    
    while (mot.length < 2 || !_estMotValide(mot)) {
      print("Mot invalide. Doit contenir au moins 2 lettres (a-z seulement):");
      mot = _lireEntree();
    }
    
    motsProposes.add(mot);
    return mot;
  }

  String proposerLettre() {
    print("$nom, proposez une lettre:");
    String lettre = _lireEntree();
    
    while (!_estLettreValide(lettre)) {
      print("Veuillez saisir une seule lettre valide (a-z):");
      lettre = _lireEntree();
    }
    
    return lettre;
  }

  String _lireEntree() {
    String? entree = stdin.readLineSync();
    return entree?.toLowerCase().trim() ?? '';
  }

  bool _estMotValide(String mot) {
    return RegExp(r'^[a-z]+$').hasMatch(mot);
  }

  bool _estLettreValide(String lettre) {
    return lettre.length == 1 && RegExp(r'[a-z]').hasMatch(lettre);
  }

  void reinitialiserLettres() {
    lettresDejaProposees.clear();
  }
}

// CLASSE GestionMot (Jose)
class GestionMot {
  String motADeviner;
  List<String> lettresTrouvees;
  List<String> lettresProposees;
  int chancesRestantes;
  List<String> motMasque;

  GestionMot(this.motADeviner)
      : lettresTrouvees = [],
        lettresProposees = [],
        chancesRestantes = 0,
        motMasque = [] {
    chancesRestantes = calculerChances();
    genererMasque();
  }

  void genererMasque() {
    motMasque = List.filled(motADeviner.length, "_");
  }

  bool verifierLettre(String lettre) {
    // Vérifier si la lettre a déjà été proposée
    if (lettresProposees.contains(lettre)) {
      print("⚠️ Vous avez déjà proposé cette lettre!");
      return true; // Retourne true mais ne diminue pas les chances
    }
    
    lettresProposees.add(lettre);
    
    if (motADeviner.contains(lettre)) {
      for (int i = 0; i < motADeviner.length; i++) {
        if (motADeviner[i] == lettre) {
          if (!lettresTrouvees.contains(lettre)) {
            lettresTrouvees.add(lettre);
          }
          motMasque[i] = lettre;
        }
      }
      return true;
    } else {
      chancesRestantes--;
      return false;
    }
  }

  bool motComplet() {
    return !motMasque.contains("_");
  }

  void afficherProgression() {
    print("\n📝 Mot: ${motMasque.join(' ')}");
    print("🔤 Lettres proposées: ${lettresProposees.join(', ')}");
    print("❤️  Chances restantes: $chancesRestantes");
  }

  int calculerChances() {
    return motADeviner.length + 3;
  }

  void reinitialiser() {
    lettresTrouvees.clear();
    lettresProposees.clear();
    chancesRestantes = calculerChances();
    motMasque.clear();
    genererMasque();
  }
}

// CLASSE GestionPartie (Espoir)
class GestionPartie {
  int toursJoues;
  List<String> historiqueMots;
  List<String> reglesJeu;

  GestionPartie()
      : toursJoues = 0,
        historiqueMots = [],
        reglesJeu = [
          "=== RÈGLES DU PANDU ===",
          "- 2 joueurs, 4 rounds",
          "- Chaque round: les deux joueurs jouent",
          "- Le joueur A donne un mot, le joueur B devine",
          "- Puis le joueur B donne un mot, le joueur A devine",
          "- Chances = longueur du mot + 3",
          "- Si égalité 2-2 après 4 rounds: round supplémentaire!",
          "- Seules les lettres de a à z sont autorisées"
        ];

  void afficherRegles() {
    print("\n" + reglesJeu.join("\n"));
  }

  void afficherGagnant(Joueur gagnant) {
    print("\n🎉 FÉLICITATIONS ${gagnant.nom.toUpperCase()} !");
    print("🏆 Vous remportez la partie avec ${gagnant.score} points!");
  }

  void sauvegarderMot(String mot) {
    historiqueMots.add(mot);
  }

  void afficherHistorique() {
    if (historiqueMots.isNotEmpty) {
      print("\n📋 Mots déjà proposés: ${historiqueMots.join(', ')}");
    }
  }

  void afficherScoreActuel(Joueur joueur1, Joueur joueur2) {
    print("\n=== SCORE ACTUEL ===");
    print("${joueur1.nom}: ${joueur1.score} points");
    print("${joueur2.nom}: ${joueur2.score} points");
  }

  void incrementerTours() {
    toursJoues++;
  }
}

// CLASSE JeuPandu (Lionel)
class JeuPandu {
  List<Joueur> joueurs;
  int roundActuel;
  int roundsTotaux;
  bool partieTerminee;
  Joueur? joueurActuel;
  GestionPartie gestionnairePartie;

  JeuPandu()
      : joueurs = [],
        roundActuel = 1,
        roundsTotaux = 4,
        partieTerminee = false,
        gestionnairePartie = GestionPartie();

  void _nettoyerEcran() {
    print('\x1B[2J\x1B[0;0H');
  }

  void demarrerJeu() {
    _nettoyerEcran();
    print("🎮 === BIENVENUE DANS LE JEU DE PANDU === 🎮");
    gestionnairePartie.afficherRegles();
    
    // Création des joueurs
    print("\nEntrez le nom du Joueur 1:");
    String nom1 = _lireNom("Joueur1");
    
    print("Entrez le nom du Joueur 2:");
    String nom2 = _lireNom("Joueur2");
    
    joueurs.add(Joueur(nom1));
    joueurs.add(Joueur(nom2));
    joueurActuel = joueurs[0];
    
    _nettoyerEcran();
    print("\n🎯 La partie commence! Bonne chance à ${joueurs[0].nom} et ${joueurs[1].nom}!");
  }

  String _lireNom(String defaut) {
    String? nom = stdin.readLineSync()?.trim();
    return (nom == null || nom.isEmpty) ? defaut : nom;
  }

  void gererRound() {
    _nettoyerEcran();
    print("\n🎲 === ROUND $roundActuel === 🎲");
    
    // Tour du joueur 1 qui donne le mot, joueur 2 devine
    print("\n--- Tour de ${joueurs[0].nom} ---");
    _gererTour(joueurs[0], joueurs[1]);
    
    // Tour du joueur 2 qui donne le mot, joueur 1 devine
    print("\n--- Tour de ${joueurs[1].nom} ---");
    _gererTour(joueurs[1], joueurs[0]);
    
    gestionnairePartie.afficherScoreActuel(joueurs[0], joueurs[1]);
    roundActuel++;
    gestionnairePartie.incrementerTours();
    
    print("\n⏳ Appuyez sur Entrée pour continuer...");
    stdin.readLineSync();
  }

  void _gererTour(Joueur donneur, Joueur devineur) {
    devineur.reinitialiserLettres();
    
    // Le donneur saisit un mot
    String mot = donneur.saisirMot();
    gestionnairePartie.sauvegarderMot(mot);
    
    // Initialisation de la gestion du mot
    GestionMot gestionMot = GestionMot(mot);
    
    _nettoyerEcran();
    print("\n🔍 ${devineur.nom}, à vous de deviner le mot!");
    print("💡 Vous avez ${gestionMot.chancesRestantes} chances.");
    
    // Boucle de devinette
    while (gestionMot.chancesRestantes > 0 && !gestionMot.motComplet()) {
      gestionMot.afficherProgression();
      
      String lettre = devineur.proposerLettre();
      
      bool estCorrecte = gestionMot.verifierLettre(lettre);
      
      if (estCorrecte && !gestionMot.lettresProposees.contains(lettre)) {
        print("✅ Bonne lettre!");
      } else if (!estCorrecte) {
        print("❌ Lettre incorrecte!");
      }
      // Si la lettre était déjà proposée, le message est géré dans verifierLettre()
      
      if (gestionMot.motComplet()) {
        _nettoyerEcran();
        print("\n🎉 BRAVO ${devineur.nom}! Vous avez trouvé le mot: '$mot'");
        devineur.incrementerScore();
        break;
      }
      
      _nettoyerEcran();
      print("\n🔍 ${devineur.nom}, continuez à deviner le mot!");
      print("💡 Chances restantes: ${gestionMot.chancesRestantes}");
    }
    
    if (!gestionMot.motComplet()) {
      _nettoyerEcran();
      print("\n💔 Dommage ${devineur.nom}! Le mot était: '$mot'");
      print("⏰ Il restait ${gestionMot.chancesRestantes} chances.");
    }
  }

  void verifierScore() {
    if (roundActuel > roundsTotaux) {
      if (joueurs[0].score == joueurs[1].score && joueurs[0].score == 2) {
        print("\n🤝 ÉGALITÉ 2-2! Round supplémentaire!");
        roundSupplementaire();
      } else {
        partieTerminee = true;
        Joueur gagnant = joueurs[0].score > joueurs[1].score ? joueurs[0] : joueurs[1];
        gestionnairePartie.afficherGagnant(gagnant);
      }
    }
  }

  void roundSupplementaire() {
    print("\n⚡⚡ ROUND SUPPLEMENTAIRE ⚡⚡");
    roundsTotaux++;
    gererRound();
  }

  void jouer() {
    demarrerJeu();
    
    while (roundActuel <= roundsTotaux && !partieTerminee) {
      gererRound();
      verifierScore();
    }
    
    print("\n=== PARTIE TERMINÉE ===");
    gestionnairePartie.afficherHistorique();
  }
}

// TEST du déroulement du jeu
void main() {
  JeuPandu jeu = JeuPandu();
  jeu.jouer();
}