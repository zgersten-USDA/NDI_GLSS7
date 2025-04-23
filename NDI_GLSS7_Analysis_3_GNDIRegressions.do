//*Zachary Gersten, PhD, MPH
//*Western Human Nutrition Research Center
//*United States Department of Agriculture, Agricultural Research Service
//*Description: This program cleans GLSS 7 household food expenditure data (g7sec9b) to create food groups, sum food group expenditures, and create binary household variables
	
	
//	*1. Read in data
		//* Import CSV file of the raw household NDI scores
			import delimited "C...\rawhhNDIscore.csv", numericcols(2)
		
		//* Rename variables
			rename v1 hid		
			rename v2 rawhhgndi
		
		//* Merge with the GLSS 7 socioeconomic data
			merge 1:1 hid using glss7socio
	

//	*2. Generate scaled GNDI score
		//* Generate household NDI score
			scalar totalgndi = X /*Replace X with total NDI score*/
			gen hhgndiscore = rawhhgndi / totalgndi
		
		//* Multiply by 100
			gen hhgndiscore100 = hhgndiscore * 100
	
		//* Create household GNDI score quintiles using survey weights
			xtile hhgndiscore5w = hhgndiscore [w=WTA_S], nq(5) /*With survey weights*/
			label variable hhgndiscore5w "household GNDI quintile (with weights)"
			
			
//	*3. Univariate analysis, weighted means and proportions for all variables
		{
		//* Set survey weights
			svyset clust [pweight = WTA_S], strata(regrurstr) || _n /*WTA_S_HHSIZE multiplies WTA_S by HHSIZE, WTA_S uses original codes for regions*/
		
		//* Household-level sociodemographic variables
			//* Household GNDI score
				histogram hhgndiscore [fw = int_WTA_S], fraction normal width(1) /*Assess normality*/
				svy: mean hhgndiscore /*Histogram looks fairly normal*/
				estat sd
				
				svy: mean hhgndiscore if hhgndiscore5w == 1
				estat sd
				
				svy: mean hhgndiscore if hhgndiscore5w != 1
				estat sd	
		
			//* Head of household age
				histogram hohage [fw = int_WTA_S], freq normal /*Assess normality*/
				svy: mean hohage /*Histogram looks fairly normal*/
				estat sd
				
			//* Head of household age quartiles
				svy: proportion hohage4_w
				svy: proportion hohage4_nw
			
			//* Head of household sex
				svy: proportion hohsex
		
			//* Head of household religion
				svy: proportion hohrelig_cat
				
			//* Household pregnancy or children under 5y
				svy: proportion hmcn
		
			//* Number of adult male equivalents	
				histogram eqsc [fw = int_WTA_S], freq normal /*Assess normality*/
				svy: mean eqsc /*Histogram is extremely right-skewed, but sample size is sufficient*/
				estat sd
	
		//*Household-level economic variables
			//*Head of household education level
				svy: proportion hoheduc_bin
			
			//*Any household member participated in agriculture (fisheries, livestock, or crop harvest) past 12 months
				svy: proportion hagric
		
		//*Environmental variables
			//*Urban/rural status
				svy: proportion urbrur
		
			//*Agroecological zone
				svy: proportion region_cat
		
			//*Survey quarter
				svy: proportion survquart
		


//	*4. Bivariate analysis, weighted means and proportions for all variables by household GNDI score quintiles
		{		
		//* Household-level sociodemographic variables
			//* Head of household age, continuous
				svy: regress hohage i.hhgndiscore5w	/*ANOVA using regress*/
				mat list e(b)
				test 1b.hhgndiscore5w=2.hhgndiscore5w=3.hhgndiscore5w=4.hhgndiscore5w=5.hhgndiscore5w /*Wald Test*/
				svy, over(hhgndiscore5w): mean hohage
				estat sd
	
			//* Head of household sex, binary
				svy: tabulate hohsex hhgndiscore5w
				
			//* Head of household religion
				svy: tabulate hohrelig_cat hhgndiscore5w      
			
			//* Household pregnancy or children under 5y
				svy: tabulate hmcn hhgndiscore5w       
	
			//* Number of adult male equivalents
				svy: regress eqsc i.hhgndiscore5w	/*ANOVA using regress*/
				mat list e(b)
				test 1b.hhgndiscore5w=2.hhgndiscore5w=3.hhgndiscore5w=4.hhgndiscore5w=5.hhgndiscore5w /*Wald Test*/
				svy, over(hhgndiscore5w): mean eqsc
				estat sd
				
		//* Household-level economic variables
			//* Head of household education level
				svy: tabulate hoheduc_bin hhgndiscore5w
				
			//*Any household member participated in agriculture (fisheries, livestock, or crop harvest) past 12 months
				svy: tabulate hagric hhgndiscore5w
				
		//* Environmental variables
			//* Urban/rural status					
				svy: tabulate urbrur hhgndiscore5w 
	
			//* Region
				svy: tabulate region_cat hhgndiscore5w
		
			//* Survey quarter
				svy: tabulate survquart hhgndiscore5w
		}					
					

//	*5. Regress household GNDI scores on sociodemographic, economic, and environmental variables in separate simple linear regression models
		{
		//* Household-level sociodemographic variables
			//* Head of household age, continuous
				svy: regress hhgndiscore hohage

			//* Head of household sex, binary
				svy: regress hhgndiscore hohsex

			//* Head of household religion
				svy: regress hhgndiscore i.hohrelig_cat
					
			//* Pregnant female in household
				svy: regress hhgndiscore hmcn 
					
			//* Number of adult male equivalents
				svy: regress hhgndiscore eqsc 
																
		//* Household-level economic variables
			//* Head of household education level
				svy: regress hhgndiscore hoheduc_bin 

			//* Any household member participated in agriculture (fisheries, livestock, or crop harvest) past 12 months
				svy: regress hhgndiscore hagric
					
		//* Environmental variables
			//* Urban/rural status					
				svy: regress hhgndiscore urbrur
				
			//* Region
				svy: regress hhgndiscore i.region_cat

			//* Survey quarter
				svy: regress hhgndiscore i.survquart
		}
		
//	*5. Regress household GNDI scores on sociodemographic, economic, and environmental variables as covariates in a multivariable linear regression model
		{
		//*	Full model
			svy: regress hhgndiscore hohage hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
	
			//* Head of household religion
				mat list e(b)
				test 1b.hohrelig_cat=2.hohrelig_cat=3.hohrelig_cat /*Wald Test*/
				svy, over(hohrelig_cat): mean hhgndiscore
				estat sd
				
			//* Region
				mat list e(b)
				test 0b.region_cat=1.region_cat=2.region_cat=3.region_cat=4.region_cat=4.region_cat=4.region_cat=4.region_cat=4.region_cat=4.region_cat /*Wald Test*/
				svy, over(region_cat): mean hhgndiscore
				estat sd
				
			//* Survey quarter
				mat list e(b)
				test 1b.survquart=2.survquart=3.survquart=4.survquart /*Wald Test*/
				svy, over(survquart): mean hhgndiscore /*PC1*/
				estat sd
			
		//*Regression diagnostics
			//*Calculate residuals
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
			
				predict r_hhgndiscore, residuals
	
				list hid r_hhgndiscore if r_hhgndiscore >= 2 & !missing(r_hhgndiscore) //*List households with residual above 2.00 cutoff
				count if r_hhgndiscore >= 2
			
			//*Calculatate studentized residuals
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
		
				predict rs_hhgndiscore, rstudent
		
				list hid rs_hhgndiscore if rs_hhgndiscore >= 2 & !missing(rs_hhgndiscore) //*List households with residual above 2.00 cutoff
				count if rs_hhgndiscore >= 2
	
			//*Calculate leverage values
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
			
				predict lev_hhgndiscore, leverage
				
				scalar levcutoff = ((2*22)+2)/13679 /*(2k+2)/n, where k = number of predictors and n = sample size*/
		
				list hid lev_hhgndiscore if lev_hhgndiscore >= levcutoff & !missing(lev_hhgndiscore) //*List all households with leverages > (2k+2)/n, where k = number of predictors and n = sample size*/
				count if lev_hhgndiscore >= levcutoff

			//*Calculate Cook's D
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
			
				predict cd_hhgndiscore, cooksd
				
				scalar cdcutoff = 4/13679 /*4/n where n = sample size*/
			
				list hid cd_hhgndiscore if cd_hhgndiscore >= cdcutoff & !missing(cd_hhgndiscore) //*List all households with Cook's D above cutoff of 4/n where n = sample size
				count if cd_hhgndiscore >= cdcutoff
			
			//*Calculate DFITS
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
		
				predict dfits_hhgndiscore, dfits
				
				scalar dfitscutoff = 2*sqrt(22/13679) /*4/n where n = sample size*/
		
				list hid dfits_hhgndiscore if dfits_hhgndiscore >= dfitscutoff & !missing(dfits_hhgndiscore) //*List all households with Cook's D above cutoff of 4/n where n = sample size
			count if dfits_hhgndiscore >= dfitscutoff
		
			//*Check normalist of residuals
				//*Kernal density plot
					kdensity r_hhgndiscore, normal
		
				//*Graph a standardized normal probability plot (P-P), normality in the middle range of data
					pnorm r_hhgndiscore
		
				//*Graph a quantiles of variable against quantiles of normal distribution plot (Q-Q), normality near the tails
					qnorm r_hhgndiscore
		
				//*Shapiro-Wilk test for normality
					swilk r_hhgndiscore

			//*Check homoscedasticity of residuals
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
			
				rvfplot, yline(0) //*Plot residuals versus fitted (predicted) values
		
				estat imtest //*White's test for homogeneous variance of the residuals
	
				estat hettest //*Breusch-Pagan test for homogeneous variance of the residuals
	
			//*Check for multicollinearity 
				xi: collin hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
	
			//*Check linearity
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
		
				acprplot hohage10, lowess 		//*Graph augmented component-plus-residual plot with lowess smoothing*/
				acprplot eqsc, lowess	 		//*Graph augmented component-plus-residual plot with lowess smoothing*/

			//*Model specification
				regress hhgndiscore hohage10 hohsex i.hohrelig_cat hmcn eqsc hoheduc_bin hagric urbrur i.region_cat i.survquart
				
				linktest	//*Linktest
				
				ovtest		//*Ramsey RESET test
		}