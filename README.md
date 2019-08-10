# Noisy-Mutual-Inhibition
This is the code to implement the Circuit Model in "A neural circuit model for human sensorimotor timing" https://www.biorxiv.org/content/10.1101/712141v1.abstract

- The MPM is implemented in MPM_simulations.ipynb; supplemental analysis of saved output can be ran in MATLAB using productionModule.
- The SAM, 1-2-Go and 1-2-3-Go simulations are implemented in SAM_simulations.ipynb
- The full circuit model optimation of alpha and analysis of response to ISI perturbations is implemented in K_alpha_perturbations.ipynb; supplemental analyses of saved output is implemented in MATLAB using alphaOptimization.m, PeriodStepResponse.m, PhaseShiftResponse.m, and StimulusJitterResponse.m
- The full circuit model, and simulations of the synchronization-continuation task are implemented in SynchronizationContinuation.ipynb

System requirements: Python 3.5.4; JupyterLab 4.3.0; MATLAB R2017a

Code has been tested with Python v3.5.4 and MATLAB R2017a.

