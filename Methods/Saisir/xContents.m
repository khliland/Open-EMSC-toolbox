% SAISIR Environment
% 'Statistic Applied to the Interpretation of Spectra in the InfraRed'  
% 18 march 2004
% The complete official manual (in French) is in 'saisir.doc'. 
% bertrand@nantes.inra.fr
%toolbox\stats        -  Statistics Toolbox
% Loading and saving files 
% ========================
% EXCEL2BAG         	- Read an excel file and creates the corresponding text bag
% EXCEL2SAISIR 	        - Read an excel file
% ISI2SAISIR			- Load NIR data form isi software from disk
% ISI2SAISIR			- Load NIR data form isi software from disk
% ISI2SAISIR2			- Load NIR data obtained with ISI software from disk
% ISI2SAISIR3			- Load NIR data obtained with ISI software from disk
% ISI2SAISIR4			- Load NIR data form isi software from disk
% MATRIX2SAISIR 	    - Transform a Matlab matrix in a saisir structure
% READEXCEL             - Read an excel file saved in the .CSV format
% READEXCEL1			- Read an excel file in the .CSV format (create a 3way character matrix).
% READIDENT 			- Load a file of strings
% READMATRIX 		    - Read a data matrix from file 
% SAISIR2EXCEL 	        - Saves a saisir file in a format compatible with Excel
% SAISIR_CHECK          - Check if the data respect the saisir stucture
% STRING2SAISIR         - Creation of a saisir file from a string table (first column=name)
% STRING2SAISIRa        - Creation of a saisir file from a string table (with name coding)
% STRING2TEXT 	        - Save a vector of string in a .txt format 

% Elementary manipulation of SAISIR files 
% =======================================
% APPENDROW1    		 - Merge an arbitrary number of files according to rows
% APPENDCOL 		     - Merge two files according to columns 
% APPENDCOL1 		     - Merge an arbitrary number of files according to columns 
% APPENDROW		         - Merge two files according to rows
% APPENDROW1		     - Merge an arbitrary number of files according to rows
% BAG2GROUP   			 - Use the identifiers in bag to create groups
% BAG_APPENDROW1		 - Merge an arbitrary number of bagq according to rows
% ALPHABETIC_SORT        - Sort the rows of s according to the alphabetic order of rows identifiers
% DELETECOL              - Delete columns of saisir files 
% DELETEROW              - Delete rows 
% ELIMINATE_NAN1		 - Suppress "not a number" data in a saisir structure
% RANDOM_SPLITROW        - Random selection of samples
% RANDOM_SAISIR			 - Creation of a random matrix
% REORDER 			     - Reorder the data of files s1 and s2 according to their identifiers
% SURFACE_STD 			 - Divide each row by the sum of the corresponding columns
% SAISIR_TRANSPOSE 		 - Transpose a data matrix following the saisir format
% SEEKSTRING		     - Return a vector giving the indices of string in matrix of char x in which 'str' is present 
% SELECTCOL 		     - Create a new data matrix with the selected columns
% SELECTROW 	    	 - Create a new data matrix with the selected rows
% SELECT_FROM_IDENTIFIER - Use identifier of rows for selecting samples
% SPLITROW		         - Split a data matrix into 2 resulting matrices  		
% SPLIT_AVERAGE 	     - Average observations according to the identifiers
% SUBGROUP		         - Extract a subgroup corresponding to a given code

% Elementary data transformations and pre-treatments 
% ================================================
% CENTER				 - Subtract the average row to each row
% CURVE_DILATATION       - Dilatation of a curve
% CURVE_EROSION 		 - Erosion of a curve
% DERIVATIVE2            - Simple computation of second derivative
% ELIMINATE_NAN1		 - Suppress "not a number" data in a saisir structure
% MOVING_MAX             - Replace the central point of a moving window by the maximum value 
% MOVING_MIN             - Replace the central point of a moving window by the minimum value 
% MSC                    - Apply a multiplicative scatter correction on spectra
% NORMC                  - Normalize columns of a matrix.
% NORM_COL		         - Divides each column by the corresponding standard deviation
% RANDOMIZE              - Build a file of randomly attributed vector in s
% RANDOM_SAISIR			 - Creation of a random matrix
% RANDOM_SELECT          - Random selection of samples
% RANDOM_SPLITROW        - Random selection of samples
% REDUCE_NVARIABLE       - Reduce variable number with averaging
% SHIFT_CORRECT 		 - Correction of chromatograms from their shifts
% SNV 			         - Apply standard normal variate correction on spectra
% STANDARDISE     	     - Divide each column of a matrix with the corresponding standard deviation
% SUBTRACT_VARIABLE 	 - Subtract a given variable to all the others
% SURFACE_STD 			 - Divide each row by the sum of the corresponding columns

% Graphical display 
% ========================
% BOXPLOT1		         - Creation of boxplot on a column of a saisir file
% BROWSE			     - Browse a series of curves
% CARTE			         -('map' in french) 	Graph of map of data using identifiers as names
% CARTE1				 - Represent only the obs then name contains the string xstring
% CARTE2			     - Black and white map : using a portion of the identifiers as labels 
% CARTE3D			     - Draw a 3D map 
% CARTE3D_COULEUR1		 - Draw a colored 3D map from a Saisir file
% CARTE_BARYCENTRE 		 -('map' in french) Graph of map of barycentre
% CARTE_COULEUR			 - Colored map : using the identifiers as labels 
% CARTE_COULEUR1		 - Colored map : using a portion of the identifiers as labels 
% CARTE_COULEUR2		 - Colored map : using a portion of the identifiers as labels 
% CARTE_COULEUR3		 - Colored map : using a portion of the identifiers as labels 
% CARTE_SYMBOLE			 - Map with symbols : using a portion of the identifiers as labels
% COURBE				 - Represent a row of a matrix as a curve
% COURBES 			     - Represents several rows of a matrix as curves
% ELLIPSE_MAP            - Plot the ellipse confidence interval of groups
% IMAGE1 			     - Represent a surface in false color
% KCARTE                 - Representation  of a cube of data
% LABELLED_HIST			 - Draw an histogram in which each name is considered as a label
% LIST			         - List rows (only with a small number of columns)
% SENSORY_PROFILE        - Graphical representation of sensory profile 
% SHOW_VECTOR			 - Represent a row of a matrix as a succession identifiers
% SUBMAP				 - Represent only the observations whose indentifiers contains the string xstring
% SURFACE1			     - Represent a surface in three dimensions
% TCOURBE			     - Representation of a column of a given matrix 
% TCOURBES 			     - Represent several columns of a matrix as curves

% Statistical methods 
% ===================
% - Usual statistics and Analysis of variance 
% ------------------------------------------------
% ANAVAR1				 - One way analysis of variance on spectral data
% ANOVAN1                - N-way analysis of variance (ANOVA) on data matrices.
% BOXPLOT1		         - Creation of boxplot on a column of a saisir file
% CORMAP 			     - Assess the correlation between two tables
% COVMAP 			     - Assess the covariances between two tables
% CREATE_GROUP 		     - Create a vector of number indicating groups from identifiers 
% CREATE_GROUP1 		 - Use the identifiers to create groups
% DENDRO				 - Dendrogram using euclidian metric and Ward linkage
% DENDRO1				 - Dendrogram using euclidian metric and Ward linkage
% DISTANCE 			     - Assesse the usual Euclidian distances between the
% DISTANCE_STRESS        - Estimate the stress (default of the reconstruction of distances) 
% DURBIN_WATSON		 	 - Assess the durbin watson value on the column of a table1
% ELLIPSE_MAP            - Plot the ellipse confidence interval of groups
% FIND_MAX               - Give the indices of the max value of a MATLAB Matrix
% FIND_MIN               - Give the indices of the min value of a MATLAB Matrix
% GROUP_MEAN 		     - Give the means of group of rows		 
% LABELLED_HIST			 - Draw an histogram in which each name is considered as a label
% NAN_COR                - Matrix of covariance or correlation with missing data  
% SAISIR_MEAN 	         - Assess the mean of the columns, following the saisir format
% SAISIR_STD 			 - Assess the standard_deviations of the columns, following the saisir format
% SAISIR_SUM             - Calculate the sum of the columns
% SPLIT_AVERAGE 		 - Average observations according to the identifiers
% xdistance 			 - Assess the euclidian distances between two MATLAB matrices

%
% Principal Component Analysis  
% ----------------------------
% APPLYPCA               - Assess the scores of supplementary observations
% CHANGE_SIGN 			 - Change the sign of a component and of associated eigenvector
% CORRELATION_CIRCLE 	 - Assess and displays the correlation circle after PCA
% NORMED_PCA			 - PCA with normalisation of data
% PCA				     - Principal component analysis on raw data 
% PCA1				     - Assesses principal component analysis on raw data (case nrows>ncolumns) 
% PCA1				     - Assesses principal component analysis on raw data (case nrows>ncolumns) 
% PCARECONSTRUCT		 - reconstruct original x data from PCA and a file of score
% PCA				     - Principal component analysis on raw data 
% XPCA 			         -PCA on a matlab data matrix   

% Regression methods 
% -----------------
% APPLYLR1               - Apply basic latent root model on saisir data x
% APPLYLR2               - Apply Latent root model 2 on saisir data x
% APPLYPCR 		         - Assess a basic PCR on data  
% APPLYPLS		         - Apply a pls model on an unknown data set
% APPLYSPCR		         - Apply a stepwise PCR
% APPLY_RIDGE_REGRESSION - apply ridge regression on "unknown data"
% APPLY_STEPWISE_REGRESSION Apply stepwise_regression on "unknown" data
% BASIC_PLS              - Basic pls with keeping loadings and scores 
% BASIC_PLS              - Basic pls with keeping loadings and scores 
% BASIC_PLS2             - PLS2 on several variables, several dimensions
% CROSSVALPLS1			 - Crossvalidation of pls with ndim dimensions. 
% CROSSVALPLS1a			 - Crossvalidation of pls with ndim dimensions. 
% CROSS_RIDGE_REGRESSION - Ridge regression with crossvalidation 
% DIMCROSSLR1a 			 - Cross validation of latent root model LRR1 
% DIMCROSSLR2 			 - Crossvalidation of model LRR2 
% DIMCROSSPCR1			 - Crossvalidation of PCR (validation samples in sequence)
% DIMCROSSPCR1			 - Crossvalidation of pCR (samples in validation are selected) 
% DIMCROSSPCR2 			 - Assess a PCR with cross validation on randomly selected samples
% DIMCROSSPLS1 		     - Crossvalidation of PLS (changing the dimensions)
% DIMCROSSPLS1a 		 - Crossvalidation of PLS (changing the dimensions)
% DIMCROSS_STEPWISE_REGRESSION 		-Test models obtained from stepwise regression
% DIMPLS 			     - Apply PLS on saisir data
% LR1			         - Assess a Latent root 1 model  
% LR2	            	 - Assess a latent root 2 model (not very efficient) 
% PCA_CROSS_RIDGE_REGRESSION		- PCA ridge regression with crossvalidation 
% PCA_RIDGE_REGRESSION	 - Assess a basic ridge regression after PCA
% PCR 		             - Assess a basic model of PCR (components introduced in the order of eigenvalues
% PCR1		             - Assess a basic model of PCR (components introduced in the order of eigenvalues
% SAISIRPLS 			 - Apply PLS on saisir data
% RIDGE_REGRESSION		 - Assess a basic ridge regression
% SDIMCROSSPCR		     - Crossvalidation of stepwise PCR (changing dimensions) 
% SDIMCROSSPCR1			 - Crossvalidation of stepwisePCR 
% SPCR				     - Stepwise Principal component regression
% STEPWISE_REGRESSION	 - Stepwise regression 

% Discrimination methods
% ----------------------
% APPLYFDA1		        - Application of factorial discriminant analysis on PCA scores 
% APPLYPLSDA            - Apply pls discriminant analysis after model assessment using plsda
% BAG2GROUP   			- Use the identifiers in bag to create groups
% BMAHA		            - Assess a simple discriminant analysis . Only backward
% CREATE_GROUP 		    - Create a vector of number indicating groups from identifiers 
% CREATE_GROUP1 		- Use the identifiers to create groups
% CROSSFDA1		        - Cross-validation on discrimination according to fda1 (directly on data) 
% CROSSMAHA			    - Cross-validation on discrimination according to maha1 (directly on data) 
% CROSSMAHA1 		    - Cross-validation (random) of discriminant analysis applied after PCA 
% CROSSPLSDA            - Cross-validation on PLS discriminant analysis
% FDA1				    - Stepwise factorial discriminant analysis on PCA scores 
% FDA2				    - Stepwise factorial discriminant analysis on PCA scores with verification
% MAHA 	                - Simple discriminant analysis forward introducing variables no validation samples 
% MAHA1 			    - Forward discriminant analysis DIRECTLY ON DATA with validation samples
% MAHA3 	            - Simple discriminant analysis forward introducing variables no validation samples 
% MAHA4 	            - Simple discriminant analysis forward introducing variables no validation samples 
% MAHA5	                - Simple discriminant analysis forward introducing variables with validation samples 
% MAHA6 	            - Simple discriminant analysis forward introducing variables with validation samples 
% PLSDA				    - Assess pls discriminant analysis following the saisir format

%
% Miscellaneous statisical methods
% -------------------------------
% COMDIM			    - Finding common dimensions in multitable data (saisir format)
% D2_FACTORIAL_MAP      - Assess a factorial map from a table of squared distance
% INDIVIDUAL_DISTANCE_STRESS - Knowing a result of INDSCAL, assess the stress of an individual configuration        
% MDISTANCE 			- Assess the distances between the two tables using metric "metric"
% NUEE				    - Nuee dynamique (KCmeans)
% SAISIR_LINKAGE		- Assess a simple linkage vector from a matrix of distance
% STATIS                - Multiway method STATIS
% XCOMDIM				- Finding common dimensions in multitable data

% Miscellaneous
% =============
% ADDCODE               - Add a code before any string of a character array
% CHANGE_IDENTIFIER		- Reduce the characters string of identifiers as startpos:endpos  
% ADDCODE               - Add a code before any string of a character array
% CHECK_NAME		    - Control if some strings are strictly identical in a string array
% FIND_MAX              - Give the indices of the max value of a MATLAB Matrix
% FIND_MIN              - Give the indices of the min value of a MATLAB Matrix
% MIR_STYLE		        - Change the sign of the variables of MIR spectra
% SAISIR_CHECK          - Check if the data respect the saisir stucture
% SAISIR_SUM            - Calculate the sum of the columns
% SEEKSTRING		    - Returns a vector giving the indices of string in matrix of char x in which 'str' is present 
% RANDOM_SELECT         - Random selection of samples
