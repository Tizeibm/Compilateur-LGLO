# Compilateur LGLO

Compilateur développé en Lex et Yacc/Bison pour le langage de programmation LGLO.

## 🎯 Vue d'ensemble

Ce projet implémente un compilateur complet pour le langage LGLO, un langage de programmation moderne supportant des structures de données avancées, des fonctions, des procédures et des boucles. Le compilateur est construit avec :
- **Lex** : pour l'analyse lexicale (tokenization)
- **Yacc/Bison** : pour l'analyse syntaxique (parsing)
- **Gcc** : pour la compilation C

## 📋 Caractéristiques du langage LGLO

Le langage LGLO supporte :

### Variables et Constantes
```
var age <--
const PI <-- 3.14159
```

### Types de données
- **Nombres** : entiers et décimaux
- **Chaînes de caractères** : `"texte"`
- **Listes** : collections ordonnées `list`
- **Dictionnaires** : collections clé-valeur `dict`

### Opérations
- **Arithmétiques** : `+`, `-`, `*`, `/`, `%`, `^` (puissance)
- **Comparaison** : `==`, `<>`, `>`, `>=`, `<`, `<=`
- **Logiques** : `&&`/`et`, `||`/`ou`
- **Incrémentation/Décrémentation** : `++`, `--`

### Contrôle de flux
- **Conditionnelles** : `si`, `sinon`, `sinonsi`
- **Boucles** : `tantque`, `pour`
- **Fonctions et procédures** : `fonction`, `procedure`
- **Retour de valeur** : `retourner`

### Entrée/Sortie
- `lire` : lecture depuis l'entrée standard
- `ecrire` : écriture vers la sortie standard

## 🚀 Installation et Utilisation

### Prérequis
- `gcc` : compilateur C
- `bison` : générateur d'analyseur syntaxique
- `flex` : générateur d'analyseur lexical

Sur Ubuntu/Debian :
```bash
sudo apt-get install build-essential bison flex
```

### Compilation du compilateur
```bash
./build&test.sh test/
```

ou manuellement :
```bash
bison -d LGLO.y
flex LGLO.l
gcc -o compilateur LGLO.tab.c lex.yy.c
```

### Exécution
Pour compiler un programme LGLO :
```bash
./compilateur < programme.lglo
```

ou avec le script de test :
```bash
./build&test.sh test/
```

Cela testera tous les fichiers `.lglo` du répertoire `test/`.

## 📂 Structure du projet

```
Compilateur-LGLO/
├── README.md              # Ce fichier
├── LGLO.l                 # Définition lexicale (Lex)
├── LGLO.y                 # Définition syntaxique (Bison)
├── lex.yy.c              # Analyseur lexical généré
├── LGLO.tab.c            # Analyseur syntaxique généré
├── LGLO.tab.h            # En-tête généré
├── compilateur           # Exécutable du compilateur
├── build&test.sh         # Script de build et test
├── test/                 # Exemples et tests
│   ├── test.lglo
│   ├── test.LGLO
│   ├── test_complet.LGLO
│   ├── test_avancer.LGLO
│   └── DictionaireAndListTest.lglo
└── LICENSE

```

## 📝 Exemple de programme LGLO

```
var x <-- 10 #
var y <-- 20 #
var resultat <-- x + y #
ecrire resultat #

si resultat > 25 sinon
  ecrire "La somme est grande" #
finsi #

var compteur <-- 0 #
tantque compteur < 5
  compteur ++ #
  ecrire compteur #
fintantque #
```

## 🧪 Tests

Des fichiers de test sont disponibles dans le répertoire `test/` :
- `test.lglo` : test basique
- `test_complet.LGLO` : test complet du compilateur
- `test_avancer.LGLO` : tests avancés
- `DictionaireAndListTest.lglo` : tests de listes et dictionnaires

Pour lancer les tests :
```bash
./build&test.sh test/
```

## 🛠️ Fichiers clés

- **LGLO.l** : Définition des tokens et des règles lexicales
- **LGLO.y** : Définition de la grammaire et des règles syntaxiques
- **build&test.sh** : Automatise la compilation et l'exécution des tests

## 📄 Licence

Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👤 Auteur

Compilateur LGLO - Projet de compilateur