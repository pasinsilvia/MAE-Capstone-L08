# Compression Of Room Impulse Responses Using Eigensystem Realization Algorithm

## About

Matlab implementation of the application of Eigensystem Realization Algorithm (ERA) to Room Impulse Responses (RIRs).

## Abstract
Room Impulse Response (RIR) compression is a growing necessity in the audio field. Capturing the acoustic response of large spaces, such as cathedral halls, requires a large amount of stored data. For this reason we explore the use of Eigensystem Realization Algorithm (ERA) in the context of RIR compression. ERA extrapolates a state-space linear model from the original signal, which can be compressed using the Singular Value Decomposition. Choosing how many Hankel Singular Values will be used in the creation of the state-space model we can parametrically adjust the amount of information to discard. We analyzed the efficiency and quality of this compression for SISO and MIMO cases with an higher order microphone and a MIMO case with a uniform linear array. The results, measured through the Signal to Distortion Ratio and with a listening test show a poor performance in the quality of the compression.


## Contents

```
.
├── README.md
├── code
│   ├── lib
│   ├── savedData
│   ├── SISO_eval.m
│   ├── SISO_testEra.m
│   ├── MIMO_eval.m
│   ├── MIMO_testEra.m
│   ├── ULA_eval.m
│   ├── ULA_testEra.m
│   ├── plot_script.m
│   ├── plot_EDR.m
│   ├── plot_EDC.m(????)
│   ├── test_speech.m
├── data
```

- `code`: folder with the source code.
    - `lib`: folder with utilities for computing ERA, preprocessing, EDR.
    - `savedData`: folder with data of MSE and SDR saved for plot.
    - `SISO_eval.m`: RIR (SISO) is preprocessed and compress through ERA with a range of values of 'r'. For each level of compression, MSE ans SDR are saved.
    - `SISO_testEra.m`: RIR (SISO) is preprocessed and compressed through ERA with set values of 'r' and for each level of compression the resulting compressed RIR is saved.
    - `MIMO_eval.m`: RIR matrix (MIMO) is preprocessed and compress through ERA with a range of values of 'r'. For each level of compression, MSE ans SDR are saved.
    - `MIMO_testEra.m`: RIR matrix (MIMO) is preprocessed and compressed through ERA with set values of 'r' and for each level of compression the resulting compressed RIR is saved. 
    - `ULA_eval.m`: RIR matrix (MIMO ULA) is preprocessed and compress through ERA with a range of values of 'r'. For each level of compression, MSE ans SDR are saved.
    - `ULA_testEra.m`: RIR matrix (MIMO ULA) is preprocessed and compressed through ERA with set values of 'r' and for each level of compression the resulting compressed RIR is saved. 
    - `plot_script`: script for plotting MSE and SDR.
    - `plot_EDR.m`: script for plotting the EDR of the original RIR and each saved compressed RIR.
    - `plot_EDC.m`: script for ???
    - `test_speech.m`: script for applying the saved RIRs to some speech signals.
- `data`: folder with audio data and output images.
