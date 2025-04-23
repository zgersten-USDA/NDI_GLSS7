//*Zachary Gersten, PhD, MPH
//*Western Human Nutrition Research Center
//*United States Department of Agriculture, Agricultural Research Service
//*Description: This program cleans GLSS 7 household food expenditure data (g7sec9b) to create food groups, sum food group expenditures, and create binary household variables
 
//	*0. Administration
		clear all
		set more off
		set varabbrev off
 
 
//	*1. Read in data
		use g7sec9b
 
 
//	*2. Correct zeros in consumption and expenditure data
		{
		//*Correct to true zero expenditure
			gen exp_v1_0 = s9bq1a if s9bq1a > 0		/*Transfers expenditure after conversion*/
			replace exp_v1_0 = 0 if s9bq1a == .		/*If expenditure is 0, then expenditure is 0*/	
	
			gen exp_v2_0 = s9bq2a if s9bq2a > 0		/*Transfers expenditure after conversion*/
			replace exp_v2_0 = 0 if s9bq2a == .		/*If expenditure is 0, then expenditure is 0*/	
			
			gen exp_v3_0 = s9bq3a if s9bq3a > 0		/*Transfers expenditure after conversion*/
			replace exp_v3_0 = 0 if s9bq3a == .		/*If expenditure is 0, then expenditure is 0*/	
			
			gen exp_v4_0 = s9bq4a if s9bq4a > 0		/*Transfers expenditure after conversion*/
			replace exp_v4_0 = 0 if s9bq4a == .		/*If expenditure is 0, then expenditure is 0*/	
			
			gen exp_v5_0 = s9bq5a if s9bq5a > 0		/*Transfers expenditure after conversion*/
			replace exp_v5_0 = 0 if s9bq5a == .		/*If expenditure is 0, then expenditure is 0*/	
			
			gen exp_v6_0 = s9bq6a if s9bq6a > 0		/*Transfers expenditure after conversion*/
			replace exp_v6_0 = 0 if s9bq6a == .		/*If expenditure is 0, then expenditure is 0*/	
 		
		//*Sum expenditure across six visits
			gen totexp_item = exp_v1_0 + exp_v2_0 + exp_v3_0 + exp_v4_0 + exp_v5_0 + exp_v6_0
			replace totexp_item = . if exp_v1_0 == . | exp_v2_0 == . | exp_v3_0 == . | exp_v4_0 == . | exp_v5_0 == . | exp_v6_0 == .
			label variable totexp_item "Total food expenditure across six visits"
 
		//*Mark visits with missing expenditure
			gen exp_v1_mis = 1 if exp_v1_0 == .
			replace exp_v1_mis = 0 if exp_v1_mis == .
			
			gen exp_v2_mis = 1 if exp_v2_0 == .
			replace exp_v2_mis = 0 if exp_v2_mis == .
			
			gen exp_v3_mis = 1 if exp_v3_0 == .
			replace exp_v3_mis = 0 if exp_v3_mis == .
			
			gen exp_v4_mis = 1 if exp_v4_0 == .
			replace exp_v4_mis = 0 if exp_v4_mis == .
			
			gen exp_v5_mis = 1 if exp_v5_0 == .
			replace exp_v5_mis = 0 if exp_v5_mis == .
			
			gen exp_v6_mis = 1 if exp_v6_0 == .
			replace exp_v6_mis = 0 if exp_v6_mis == .
			
			gen exp_vtot_mis = exp_v1_mis + exp_v2_mis + exp_v3_mis + exp_v4_mis + exp_v5_mis + exp_v6_mis
		
		//*Replace total expenditure despite visits with missing values
			gen exp_v1_rep = exp_v1_0
			replace exp_v1_rep = 0 if exp_v1_mis == 1
	
			gen exp_v2_rep = exp_v2_0
			replace exp_v2_rep = 0 if exp_v2_mis == 1		
			
			gen exp_v3_rep = exp_v3_0
			replace exp_v3_rep = 0 if exp_v3_mis == 1				
	
			gen exp_v4_rep = exp_v4_0
			replace exp_v4_rep = 0 if exp_v4_mis == 1				
			
			gen exp_v5_rep = exp_v5_0
			replace exp_v5_rep = 0 if exp_v5_mis == 1				
			
			gen exp_v6_rep = exp_v6_0
			replace exp_v6_rep = 0 if exp_v6_mis == 1
			
			gen totexp_item_rep = exp_v1_rep + exp_v2_rep + exp_v3_rep + exp_v4_rep + exp_v5_rep + exp_v6_rep
		}
 		
		
//	*3. Create food group number to combine food items linked with the same food composition data
		{
		//*Non-food items
			gen foodnum = 0 if inrange(freqcd, 645, 906)
			replace foodnum = 0 if inrange(freqcd, 503, 505)
			replace foodnum = 0 if inrange(freqcd, 511, 518)
			replace foodnum = 0 if inrange(freqcd, 523, 529)
			replace foodnum = 0 if inrange(freqcd, 535, 540)
			replace foodnum = 0 if inrange(freqcd, 545, 547)
			replace foodnum = 0 if inrange(freqcd, 550, 552)
			replace foodnum = 0 if inrange(freqcd, 554, 561)
			replace foodnum = 0 if inrange(freqcd, 565, 570)
			replace foodnum = 0 if inrange(freqcd, 575, 583)
			replace foodnum = 0 if inrange(freqcd, 587, 594)
			replace foodnum = 0 if inrange(freqcd, 618, 623)
			replace foodnum = 0 if inrange(freqcd, 629, 631)
			replace foodnum = 0 if inrange(freqcd, 635, 638)
			replace foodnum = 0 if inrange(freqcd, 907, 911)
			replace foodnum = 0 if inrange(freqcd, 915, 921)
			replace foodnum = 0 if inrange(freqcd, 923, 990)
	
		//*Local rice
			replace foodnum = 1 if inrange(freqcd, 1, 6)
			
		//*Imported rice
			replace foodnum = 2 if inrange(freqcd, 10, 23)
		
		//*Guinea corn/sorghum
			replace foodnum = 3 if freqcd == 27
			
		//*White maize grains
			replace foodnum = 4 if freqcd == 28
			
		//*Yellow maize grains
			replace foodnum = 5 if freqcd == 29
			
		//*Millet grain
			replace foodnum = 6 if freqcd == 30
			
		//*Millet flour
			replace foodnum = 7 if freqcd == 31
			
		//*Wheat flour
			replace foodnum = 8 if inrange(freqcd, 32, 33)
			
		//*Wheat semolina
			replace foodnum = 9 if freqcd == 34
			
		//*Corn dough
			replace foodnum = 10 if freqcd == 35
	
		//*Cerelac baby food
			replace foodnum	= 11 if inrange(freqcd, 36, 42)
			
		//*Rolled white oats
			replace foodnum	= 12 if inrange(freqcd, 47, 49)	
			
		//*Cassava paste
			replace foodnum	= 13 if inrange(freqcd, 53, 54)
			
		//*White gari
			replace foodnum	= 14 if inrange(freqcd, 55, 56)
			
		//*White bread
			replace foodnum	= 15 if freqcd == 58
			replace foodnum = 15 if inrange(freqcd, 60, 62)
			
		//*Wheat bread
			replace foodnum	= 16 if freqcd == 59
			
		//*Sweetened biscuits
			replace foodnum	= 17 if inrange(freqcd, 67, 78)	
			
		//*Instant noodles
			replace foodnum	= 18 if freqcd == 83
			
		//*Cornflakes
			replace foodnum	= 19 if freqcd == 84
			replace foodnum = 19 if freqcd == 89
			
		//*Pasta
			replace foodnum = 20 if inrange(freqcd, 85, 86)
			replace foodnum = 20 if freqcd == 88
			
		//*Maizena
			replace foodnum = 21 if freqcd == 87
			
		//*Beef meat
			replace foodnum = 22 if inrange(freqcd, 95, 99)
			replace foodnum = 22 if freqcd == 101
			
		//*Beef tripe
			replace foodnum = 23 if freqcd == 100
			
		//*Pork meat
			replace foodnum = 24 if inrange(freqcd, 105, 108)
			replace foodnum = 24 if freqcd == 110
			
		//*Pork feet
			replace foodnum = 25 if freqcd == 109
			
		//*Mutton meat
			replace foodnum = 26 if freqcd == 115
			
		//*Goat meat
			replace foodnum = 27 if inrange(freqcd, 116, 117)
			
		//*Chicken dark meat
			replace foodnum = 28 if inrange(freqcd, 118, 122)
			replace foodnum = 28 if freqcd == 126
			
		//*Chicken gizzards
			replace foodnum = 29 if freqcd == 123
			
		//*Chicken light meat
			replace foodnum = 30 if inrange(freqcd, 124, 125)
			
		//*Guinea fowl meat
			replace foodnum = 31 if freqcd == 127
			replace foodnum = 31 if freqcd == 143
			
		//*Canned corned beef
			replace foodnum = 32 if inrange(freqcd, 131, 134)
			
		//*Sausage
			replace foodnum = 33 if inrange(freqcd, 139, 141)
			
		//*Bushmeat
			replace foodnum = 34 if freqcd == 142
			replace foodnum = 34 if freqcd == 144
			
		//*Atlantic horse mackerel
			replace foodnum = 35 if freqcd == 149
			replace foodnum = 35 if freqcd == 161
			
		//*Shrimp
			replace foodnum = 36 if freqcd == 150
			
		//*Snails
			replace foodnum = 37 if freqcd == 151
			
		//*Crab
			replace foodnum = 38 if freqcd == 152
			
		//*Smoked freshwater fish
			replace foodnum = 39 if freqcd == 153
			
		//*Smoked mackerel
			replace foodnum = 40 if freqcd == 154
			replace foodnum = 40 if freqcd == 156
			
		//*Smoked herring
			replace foodnum = 41 if freqcd == 155
			
		//*Fried white fish
			replace foodnum = 42 if freqcd == 157
			
		//*Whole dried fish
			replace foodnum = 43 if inrange(freqcd, 158, 159)
			
		//*Tilapia
			replace foodnum = 44 if freqcd == 160
			
		//*Canned sardines in oil
			replace foodnum = 45 if inrange(freqcd, 165, 172)
			
		//*Canned tuna in oil
			replace foodnum = 46 if inrange(freqcd, 176, 181)
			
		//*Mackerel in tomato sauce
			replace foodnum = 47 if inrange(freqcd, 185, 192)
			
		//*Fresh milk
			replace foodnum = 48 if freqcd == 197
			
		//*Powdered milk
			replace foodnum = 49 if inrange(freqcd, 198, 207)
			
		//*Evaporated milk
			replace foodnum = 50 if inrange(freqcd, 301, 306)
			
		//*Condensed milk
			replace foodnum = 51 if inrange(freqcd, 401, 402)
			
		//*Ice cream
			replace foodnum = 52 if inrange(freqcd, 407, 411)
			
		//*Chicken eggs
			replace foodnum = 53 if freqcd == 416
			
		//*Guinea fowl eggs
			replace foodnum = 54 if freqcd == 417
			
		//*Margarine
			replace foodnum = 55 if freqcd == 421
			
		//*Coconut oil
			replace foodnum = 56 if freqcd == 422
			
		//*Groundnut oil
			replace foodnum = 57 if freqcd == 423
			
		//*Red palm oil
			replace foodnum = 58 if freqcd == 424
			
		//*Vegetable oil
			replace foodnum = 59 if freqcd == 425
			replace foodnum = 59 if freqcd == 428
	
		//*Shea butter
			replace foodnum = 60 if freqcd == 426
			
		//*Palm kernel oil
			replace foodnum = 61 if freqcd == 427
			
		//*Fresh coconut
			replace foodnum = 62 if freqcd == 432
			
		//*Dried coconut
			replace foodnum = 63 if freqcd == 433
			
		//*Banana
			replace foodnum = 64 if freqcd == 434
			replace foodnum = 64 if freqcd == 446
			
		//*Orange
			replace foodnum = 65 if freqcd == 435
		
		//*Pineapple
			replace foodnum = 66 if freqcd == 436
			
		//*Mango
			replace foodnum = 67 if freqcd == 437
			
		//*Watermelon
			replace foodnum = 68 if freqcd == 438
			
		//*Avocado
			replace foodnum = 69 if freqcd == 439
			
		//*Apples
			replace foodnum = 70 if freqcd == 440
			
		//*Grapes
			replace foodnum = 71 if freqcd == 441
			
		//*Sweet apples
			replace foodnum = 72 if freqcd == 442
			
		//*Lime
			replace foodnum = 73 if freqcd == 443
			
		//*Cashew apple
			replace foodnum = 74 if freqcd == 444
			
		//*Papaya
			replace foodnum = 75 if freqcd == 445
			
		//*Canned fruit
			replace foodnum = 76 if freqcd == 452
			
		//*Cocoyam
			replace foodnum = 77 if freqcd == 453
			
		//*Red pepper
			replace foodnum = 78 if freqcd == 454
			
		//*Carrot
			replace foodnum = 79 if freqcd == 455
			
		//*Eggplant
			replace foodnum = 80 if freqcd == 456
			
		//*Okra
			replace foodnum = 81 if freqcd == 457
			
		//*Green pepper
			replace foodnum = 82 if freqcd == 458
			
		//*Chilli pepper
			replace foodnum = 83 if inrange(freqcd, 459, 460)
			
		//*Onion
			replace foodnum = 84 if inrange(freqcd, 461, 462)
			replace foodnum = 84 if freqcd == 464
			
		//*Tomatoes
			replace foodnum = 85 if freqcd == 463
			
		//*Tomato paste
			replace foodnum = 86 if inrange(freqcd, 473, 480)
			
		//*Cowpeas
			replace foodnum = 87 if freqcd == 485
			
		//*Oil palm fruit
			replace foodnum = 88 if freqcd == 486
			
		//*Shelled groundnuts
			replace foodnum = 89 if freqcd == 487
			
		//*Groundnut paste
			replace foodnum = 90 if freqcd == 488
			
		//*Agushie melon seeds
			replace foodnum = 91 if freqcd == 489
			
		//*Plantain
			replace foodnum = 92 if freqcd == 491
			
		//*Fresh cassava
			replace foodnum = 93 if freqcd == 492
			replace foodnum = 93 if freqcd == 498
			
		//*Cocoyam
			replace foodnum = 94 if freqcd == 493
			
		//*Yam
			replace foodnum = 95 if freqcd == 494
			
		//*Water yam
			replace foodnum = 96 if freqcd == 495
			
		//*Taro
			replace foodnum = 97 if freqcd == 496
			
		//*Potato
			replace foodnum = 98 if freqcd == 497
			
		//*Soda pop
			replace foodnum = 99 if inrange(freqcd, 567, 570)
			
		//*Sweetened fruit juice
			replace foodnum = 100 if inrange(freqcd, 605, 613)
		}	
 
//	*4. Total food expenditure by food item marked by food group number
		quietly forval j = 1/100 {
			bysort hid: egen totexp`j'_0 = total(totexp_item_rep) if (foodnum == `j')
			bysort hid: egen totexp`j' = mean(totexp`j'_0)
			drop totexp`j'_0
			}
 	
 	
//	*5. Create binary variables for household food item expenditure
		quietly forval j = 1/100 {
			bysort hid: gen fdexpi`j'_0 = 1 if totexp`j' > 0
			bysort hid: egen fdexpi`j' = mean(fdexpi`j'_0)
			drop fdexpi`j'_0
			replace fdexpi`j' = 0 if fdexpi`j' == .
			replace fdexpi`j' = . if totexp`j' == .
			}
 
 
//	*6. Keep household-level variables
		bysort hid: gen line_n = _n
		keep if line_n == 1
		drop line_n
	
		quietly forval j = 1/100 {
			drop if fdexpi`j' == .
			}
 			
		keep hid clust nh fdexpi1-fdexpi100
 
 
// *7. Save file
 		save "hhfoodexp", replace
 		
 		export delimited using hhfoodexp, replace