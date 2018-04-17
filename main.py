import matplotlib.pyplot as plt
import numpy as np
import scipy
import scipy.fftpack
from scipy.io import wavfile


fs_rate, signal = wavfile.read('signal-extra025.wav')
print('Freq sampling:', fs_rate)
l_audio = len(signal.shape)
print('Channels:', l_audio)

N = signal.shape[0]
secs = N / float(fs_rate)
print('secs:', secs)

Ts = 1.0/fs_rate # sampling interval in time
print('Timestep between samples Ts:', Ts)

t = scipy.arange(0, secs, Ts) # time vector as scipt arange field / numpy.ndarray
FFT = abs(scipy.fft(signal))
FFT_side = FFT[range(int(N/2))] # one side FFT range
freqs = scipy.fftpack.fftfreq(signal.size, t[1]-t[0])
fft_freqs = np.array(freqs)
freqs_side = freqs[range(int(N/2))]
fft_freqs_side = np.array(freqs_side)
plt.subplot(311)
p1 = plt.plot(t, signal, 'g') # plottingthe signal
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.subplot(312)
p2 = plt.plot(freqs, FFT, 'r') # plotting the complete fft spectrum
plt.xlabel('Frequence (Hz)')
plt.ylabel('Count dbl-sided')
plt.subplot(313)
p3 = plt.plot(freqs_side, abs(FFT_side), 'b') # plotting the posistive fft spectrum
plt.xlabel('Frequence (Hz)')
plt.ylabel('Count single-sided')
plt.show()



#plt.specgram(data, NFFT=1024, Fs=fs)
#plt.title('PSD of signal loaded from file')
#plt.xlabel('time')
#plt.ylabel('freq')
#plt.show()

#plt.psd(data, NFFT=1024, Fs=fs)
#plt.title('PSD of signal loaded from file')
#plt.show()

#fft_out = fft(data)

#plt.plot(fft_out)
#plt.grid()
#plt.show()
