from scipy.io import loadmat
import math

import matplotlib.pyplot as plt

from fooof import FOOOF
from fooof.plts.spectra import plot_spectrum
from fooof.plts.annotate import plot_annotated_model

from fooof.plts.periodic import plot_peak_fits, plot_peak_params

files = ['JM006/JM006-210512/JM006-210512-135556/PSD/psd2_variables.mat',
         'JM006/JM006-210512/JM006-210512-151259/PSD/psd10_variables.mat',
         'JM006/JM006-210512/JM006-210512-161457/PSD/psd10_variables.mat',
         'JM008/JM008-210602a/JM008-210602-102005/PSD/psd5_variables.mat',
         'NB162/NB162-211014/NB162-211014-162046/PSD/psd17_variables.mat']

for file in files:
    data = loadmat('/home/yhashim/Documents/Research/Oxford/intan_read/figures/'+file)
    
    file_name = file.split('/', 3)[2]

    # Access variables and flatten to 1D arrays
    f = data['f'].flatten()
    pxx = data['pxx'].flatten()

    ## Plots original spectrum
    # plot_spectrum(f, pxx, log_powers=True, color='black', label='Original Spectrum')
    # plt.savefig('psd_original.svg')

    # # Initialize a FOOOF object, and add some data to it
    # fm = FOOOF(max_n_peaks=2) # peak_width_limits=[0.5, 20] # what peak width limit is suitable for broadband low-gamma peaks?
    # f_range = [3, 10] 
    # fm.add_data(f, pxx, f_range)
    # fm.fit()
    # fm.report()

    # fm.save_report(file_name+'_theta')

    # # fm.plot(plot_peaks='shade')
    # # plt.savefig(file_name+'_thetaShaded.svg')

    # plot_peak_fits(fm.get_params('peak_params'))
    # plt.savefig(file_name+'_thetaPeaks.svg')

    # fm = FOOOF(max_n_peaks=1, peak_width_limits=[0.5,30])
    # f_range = [30, 100] 
    # fm.add_data(f, pxx, f_range)
    # fm.fit()
    # fm.report()

    # fm.save_report(file_name+'_gamma')

    # # fm.plot(plot_peaks='shade')
    # # plt.savefig(file_name+'_gammaShaded.svg')

    # plot_peak_fits(fm.get_params('peak_params'))
    # plt.savefig(file_name+'_gammaPeaks.svg')

    # Interpreting the report: 
        # CF: center frequency of the extracted peak
        # PW: power of the peak, over and above the aperiodic component
        # BW: bandwidth of the extracted peak

    fm = FOOOF(peak_width_limits=[0.5, 50], max_n_peaks=2, min_peak_height=0.1)
    f_range = [1, 100] 
    fm.add_data(f, pxx, f_range)
    fm.fit()
    fm.report()

    fm.save_report(file_name+'_all')
# Export  output