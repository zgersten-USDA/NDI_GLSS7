# READ ME

Zachary P. Gersten, April 2025

## Summary

This directory includes scripts for the analysis of the Nutrient Diversity Index (NDI) using household food expenditure data collected as part of the seventh round of the Ghana Living Standards Survey (GLSS 7). Covariates include sociodemographic, economic, and environmental characteristics. 
The analysis has four main focus points:

1) Creating binary variables for household expenditures on 100 food groups that were developed using the GLSS 7 food list.
2) Generating the total NDI score.
3) Generating the household NDI scores.
4) Using linear regression models to assess relationships between household NDI scores and household sociodemographic, economic, and environmental characteristics.
   
## Required Software

-   StataSE 17 (or newer)
-   R 4.4.1 (or newer)
-   RStudio '2024.09.0+494' (or newer)

## Required Files

GLSS 7  
- g7sec9b (household food consumption expenditure module)
- cleaned household characteristics (available on request)

Nutrient trait matrix  
- nutrienttraitmatrix.csv

## Suggested Order of Scripts

Scripts in each set are intended to be run sequentially.

**Merging food items into food groups and creating binary food expenditure variables**  
1) NDI_GLSS7_Analysis_1_CleanFoodExpGroups

**Calculate distances, cluster in food dendrogram, and generate the total and household NDI scores**  
2) NDI_GLSS7_Analysis_2_DendrogramScore

**Assess relationships between NDI scores and household covariates**   
3) NDI_GLSS7_Analysis_3_GNDIRegressions
