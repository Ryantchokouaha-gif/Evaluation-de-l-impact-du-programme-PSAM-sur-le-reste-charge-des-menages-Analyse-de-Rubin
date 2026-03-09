# 📊 Évaluation de l'Impact du Programme PSAM sur les Dépenses de Santé des Ménages Ruraux

> TD2 — La Causalité · Master 1 Économie Appliquée · Université Paris Cité  
> Auteur : Ryan Jordan TCHOKOUAHA TCHAHA · Année académique 2025–2026  
> Source des données : `evaluation.dta` (IRDES)

---

## 📌 Question de recherche

> *Quel est l'impact du programme PSAM sur le reste à charge des ménages défavorisés ruraux ?*

Le **Programme de Protection Sociale et d'Assurance Maladie (PSAM)** est un dispositif d'assurance santé ciblant les ménages défavorisés en milieu rural. L'évaluation de son impact sur les dépenses de santé (reste à charge) mobilise des méthodes d'économétrie appliquée et s'inscrit dans le cadre de l'évaluation causale des politiques publiques.

---

## 🗂️ Base de données

La base `evaluation.dta` est importée sous R via le package `haven`. Elle contient **22 variables** organisées en trois blocs :

| Type | Variables clés | Description |
|:---|:---|:---|
| **Variable de résultat** | `health_expenditures` | Dépenses de santé out-of-pocket (per capita/an) |
| **Variables de contrôle** | `age_hh`, `educ_hh`, `hhsize`, `dirtfloor`, `bathroom`, `land`, `hospital_dist`... | Caractéristiques socio-démographiques du ménage à la baseline |
| **Variables d'identification** | `round`, `enrolled`, `treatment_locality`, `eligible`, `poverty_index` | Indicateurs de traitement et d'éligibilité |

- `round` : 0 = baseline (avant PSAM), 1 = suivi (2 ans après)  
- `treatment_locality` : 1 si le ménage est dans un village pilote  
- `enrolled` : 1 si le ménage a demandé à bénéficier du programme  
- `poverty_index` : indice 1–100 ; éligibilité si ≤ 58

```r
install.packages("haven")
library(haven)
hisp <- read_dta("evaluation.dta")
```

---

## 🔬 Méthodologie & Résultats

### Question 4 — Comparaison avant/après chez les bénéficiaires

**Stratégie :** On isole les ménages traités (villages pilotes + inscrits au PSAM) et on compare leurs dépenses de santé avant et après la mise en place du programme.

```r
hisp_T <- subset(hisp, hisp$treatment_locality == 1 & hisp$enrolled == 1)
# 5 929 observations : 2 964 avant (round=0) et 2 965 après (round=1)
```

**Résultats :**

| Période | Dépenses moyennes (RAC) |
|:---|:---:|
| Avant le PSAM (baseline) | 14,4 $ |
| Après le PSAM (suivi, +2 ans) | 7,8 $ |
| **Variation** | **−6,64 $ (−45%)** |

La baisse est **statistiquement significative** (p-value < 2,2e-16). Elle est confirmée par une régression linéaire simple de `health_expenditures` sur `round`.

**⚠️ Limite méthodologique — biais de la comparaison avant/après :**

> La comparaison avant/après sur le même groupe ne constitue **quasiment jamais** un bon contrefactuel pour identifier l'effet causal d'une politique publique (ΔATT).

D'autres facteurs évoluant simultanément dans le temps peuvent expliquer la baisse des dépenses indépendamment du programme : le contexte économique, le climat, l'occurrence d'épidémies, etc. L'hypothèse d'indépendance conditionnelle des erreurs est très probablement violée en raison de variables omises.

---

### Question 5 — Comparaison traités / non-traités après la mise en place du programme

**Stratégie :** On se restreint aux ménages des villages pilotes après la mise en œuvre du PSAM, et on compare ceux qui ont demandé à bénéficier du programme à ceux qui ne l'ont pas fait.

```r
hisp_E <- subset(hisp, hisp$treatment_locality == 1 & hisp$round == 1)
# 4 960 ménages : 1 995 non-inscrits (enrolled=0) et 2 965 inscrits (enrolled=1)
```

**Résultats :**

| Groupe | Dépenses moyennes (RAC) |
|:---|:---:|
| Non-bénéficiaires (enrolled = 0) | 22,30 $ |
| Bénéficiaires (enrolled = 1) | 7,84 $ |
| **Écart** | **−14,46 $ (×2,85)** |

L'écart est **statistiquement significatif** (p-value < 2,2e-16) et peut être retrouvé par régression linéaire simple de `health_expenditures` sur `enrolled`.

**⚠️ Limite méthodologique — biais de sélection :**

> La comparaison naïve traités/non-traités ne constitue **quasiment jamais** un bon contrefactuel pour mesurer l'effet causal d'une politique publique (ΔATT).

Les ménages qui ont choisi de s'inscrire au PSAM ne sont **pas comparables** aux non-inscrits sur des caractéristiques non observées (niveau de vie, état de santé initial, aversion au risque...) qui influencent à la fois la participation au programme et le niveau des dépenses. L'hypothèse d'indépendance conditionnelle reste violée même après contrôle des variables observables via une régression multiple.

---

## 💡 Enseignement central

Ces deux approches — comparaison avant/après et comparaison traités/non-traités — montrent toutes les deux **une association** entre la participation au PSAM et la baisse des dépenses de santé. Elles ne permettent cependant **pas d'établir un lien causal** en raison de biais inhérents à ces designs.

Pour identifier l'effet causal du PSAM, il faudrait mobiliser des **méthodes quasi-expérimentales** robustes :

| Méthode | Principe |
|:---|:---|
| **Expérience contrôlée randomisée (RCT)** | Assignation aléatoire au traitement |
| **Différence-en-différences (DiD)** | Comparer l'évolution traités vs témoins dans le temps |
| **Variables instrumentales (IV)** | Exploiter une source de variation exogène à la participation |
| **Regression Discontinuity Design (RDD)** | Exploiter un seuil d'éligibilité (ex. poverty_index ≤ 58) |

---

## 🛠️ Outils & Méthodes

`R Studio` · `haven` · `Régression linéaire simple` · `Régression linéaire multiple` · `Test de Student` · `Boxplot`

`Comparaison avant/après` · `Comparaison traités/non-traités` · `Évaluation d'impact` · `Biais de sélection` · `Contrefactuel` · `ΔATT`

---

## 👤 Auteur

**Ryan Jordan TCHOKOUAHA TCHAHA**  
M1 Économie Appliquée — Université Paris Cité  
📧 [ryantchokouaha@gmail.com](mailto:ryantchokouaha@gmail.com)  
🔗 [LinkedIn](https://www.linkedin.com/in/ryan-tchokouaha)

---

<div align="center">

*"Turning data into decisions."*

</div>
