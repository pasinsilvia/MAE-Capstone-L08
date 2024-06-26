# Utilities functions

This folder contains utilities for computing ERA, the preprocessing of the signals and the Energy Decay and Relief plot.

## Contents

- `EDR.m`: a function for the calculation of the EDR of a signal.
- `ERA.m`: a function for applying ERA. It takes as input the pre-processed RIR and outputs the 4 SSM matrices and the HSVs.
- `rir_preprocessing.m`: a function for preprocessing a RIR array. It returns the preprocessed array, the ground truth used for comparisons and the initial delay.
- `rir_preprocessing_MIMO.m`:  a function for preprocessing an LxM RIR matrix. It returns the preprocessed matrix, the ground truth matrix used for comparisons and the matrix of initial delays.
- `t30.m`: a function used to estimate the t30 cutoff sample. It allows also to plot the EDC of the signal.