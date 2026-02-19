# Bisphosphonate Hepatobiliary Safety Analysis Using FAERS

## Introduction
This repository contains **R code** for a pharmacovigilance analysis evaluating whether bisphosphonate medications are associated with increased hepatobiliary adverse events compared with other drug classes using the FDA Adverse Event Reporting System (FAERS).

Bisphosphonates are typically the first-line treatment for osteoporosis. Nitrogen-containing bisphosphonates include alendronate, risedronate, ibandronate, pamidronate, and zoledronic acid, while non-nitrogen bisphosphonates include etidronate, clodronate, and tiludronate. Evidence regarding liver toxicity associated with bisphosphonate use remains limited, motivating this study.

---

## Data
The analysis uses FAERS data from **2013–2022** for individuals aged **18–85 years**.

FAERS is a post-marketing safety surveillance database maintained by the FDA to collect adverse event reports for approved drugs and biologic products. Reports are submitted by:
- Drug manufacturers (mandatory)
- Healthcare professionals (voluntary)
- Consumers (voluntary)

The FDA routinely evaluates FAERS data for potential safety signals that may require further regulatory assessment.

---

## Methods

### Cohort Selection
- Age group: 18–85 years
- Reports where bisphosphonate drugs were designated as **primary suspect**
- Removal of duplicate reports based on case ID

### Bias Reduction
- Exclusion of reports where the **reason for drug use** included liver-related conditions
- Removal of cases with concomitant hepatotoxic medications
- Screening for other adverse reactions and indications contributing to liver toxicity

### Comparator Groups
To contextualize hepatotoxic risk, bisphosphonate users were compared with:
1. NSAID users
2. Antibiotic users with known hepatotoxicity
3. Other osteoporosis medication users

### Pipeline Workflow
1. Select FAERS reports meeting inclusion criteria
2. Remove duplicate case IDs
3. Exclude liver-related indications in “reason for use”
4. Remove cases with concomitant hepatotoxic medications
5. Identify hepatobiliary adverse events using keyword dictionary
6. Count hepatobiliary vs non-hepatobiliary reactions
7. Construct contingency tables
8. Perform disproportionality analysis using Reporting Odds Ratio (ROR)
9. Estimate confidence intervals
10. Conduct subgroup hepatobiliary event analysis

---

## Disproportionality Analysis

The Reporting Odds Ratio (ROR) was calculated using a 2×2 contingency table:

|                      | Interested drug | Comparator drugs | Total |
|----------------------|----------------|------------------|-------|
| Adverse event (P)    | a              | b                | a+b   |
| Other adverse events | c              | d                | c+d   |
| Total                | a+c            | b+d              | N     |

**Definitions**
- a: Reports of bisphosphonate with hepatobiliary event
- b: Reports of comparator drugs with hepatobiliary event
- c: Reports of bisphosphonate with other events
- d: Reports of comparator drugs with other events

\[
ROR = \frac{a/c}{b/d}
\]

---

## Results

### Result 1: Bisphosphonate vs NSAID
|                      | Bisphosphonate | NSAID | Total |
|----------------------|----------------|-------|-------|
| Hepatobiliary reaction | 1370 | 13608 | 14978 |
| All other AE | 29117 | 168712 | 197829 |
| Total | 30487 | 182320 | 212807 |

**ROR = 0.58**

---

### Result 2: Bisphosphonate vs Antibiotics
|                      | Bisphosphonate | Antibiotics | Total |
|----------------------|----------------|-------------|-------|
| Hepatobiliary reaction | 1405 | 7059 | 8464 |
| All other AE | 29631 | 81006 | 110637 |
| Total | 31036 | 88065 | 119101 |

**ROR = 0.54**

---

### Result 3: Bisphosphonate vs Other Osteoporosis Drugs
|                      | Bisphosphonate | Other Osteoporosis | Total |
|----------------------|----------------|--------------------|-------|
| Hepatobiliary reaction | 1674 | 1393 | 3067 |
| All other AE | 28770 | 111583 | 140353 |
| Total | 30444 | 112976 | 143420 |

**ROR = 4.66**

---

### Result 4: Confidence Intervals
| Group | ROR | CI_low | CI_high |
|------|-----|--------|--------|
| Bisphosphonate vs NSAID | 0.583 | 0.551 | 0.618 |
| Bisphosphonate vs Other Osteoporosis | 4.661 | 4.336 | 5.010 |
| Bisphosphonate vs Antibiotic | 0.544 | 0.513 | 0.577 |

---

### Result 5: Subgroup Hepatobiliary Signals
| Category | ROR |
|----------|-----|
| Drug-induced liver injury | 12.52 |
| Liver disorder | 3.82 |
| Liver injury | 16.93 |
| Cirrhosis | 4.58 |
| Hepatitis | 7.61 |
| Jaundice | 6.16 |
| Hepatocellular carcinoma | 2.97 |
| Metastases to liver | 4.96 |
| Hepatic events | 6.24 |

---

## Repository Structure
├── data/ # Raw and processed FAERS data
├── scripts/ # R preprocessing scripts
├── pipeline/ # Workflow implementation
├── results/ # Tables and outputs
├── figures/ # Visualizations
└── README.md


---

## Requirements
- R ≥ 4.0
- dplyr
- data.table
- tidyr
- stringr
- ggplot2
- epitools / stats

---

## Limitations
FAERS is a spontaneous reporting system and is subject to:
- Reporting bias
- Under-reporting
- Missing data
- Lack of causal inference

Therefore, findings represent **signal detection** rather than confirmed causality.

---

## Conclusion
This FAERS pharmacovigilance analysis indicates:
- Lower hepatobiliary reporting odds for bisphosphonates compared with NSAIDs and antibiotics
- Higher reporting odds compared with other osteoporosis medications
- Strong signals for specific hepatobiliary subcategories

Further pharmacoepidemiologic studies are needed to confirm these findings.

---

## Author
Nabasmita Talukdar
