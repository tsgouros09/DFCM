# DFCM
Code for Directional Fuzzy C-Means and Directional Validation Framework

This MATLAB implementation is a new algorithm for counting and separating sources in an instantaneous sound mixture. It is the implementation of the methods described in the paper 
T. Sgouros, N. Mitianoudis, "A novel Directional Framework for source counting and source separation in Instantaneous Underdetermined audio mixtures", submitted to IEEE Trans. on Audio, Speech and Language Processing.


The proposed framework has the advantage of being efficient even when used on directional as well as multi-dimensional data. In order to do so the framework uses a novel clustering algorithm the 'Directional Fuzzy C-Means' based on the Fuzzy C-Means algorithm.

The core files include the following functions:

'directionalFuzzyCMeans.m' is the new DFCM clustering algorithm that can cluster directional data.

'directionalValidation.m' is the proposed framework that uses the DFCM algorithm to cluster the data and then validates the results in order to count the most probable number of clusters that are present.

The sample test files are:

'ValidationTest.m' tests both core files with the 'dev1_wdrums_inst_mix.wav' mixture of 3 sources recorded with 2 microphones. This file estimates the number of sources present in the mixture, the centres of each cluster and the membership value of each data point and finally separates the mixture. 

'ValidationTestND.m' tests both core files in a multi-dimensional case with the 'dev3_female4_inst_mix.wav' mixture of 4 sources recorded with 3 microphones. This file estimates the number of sources present in the mixture, the centres of each cluster and the membership value of each data point and finally separates the mixture. 


Thomas Sgouros
Nikolaos Mitianoudis
