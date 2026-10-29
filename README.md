# Signals and Systems

MATLAB projects completed for the **Signals and Systems** course at the **University of Tehran**.

The six assignments explore how signals can be used to estimate distance and motion, recognize characters, transmit messages, and synthesize music. The repository includes MATLAB scripts and functions, sample data, and PDF assignment documents and reports.

## Projects

| Assignment | Topics | Main files |
| --- | --- | --- |
| [1. Signal modeling and radar ranging](1/) | MATLAB fundamentals, least-squares parameter estimation, cross-correlation, and the effect of noise on distance estimation | [`q2.m`](1/q2.m), [`p2_4.m`](1/p2_4.m), [`p3.m`](1/p3.m) |
| [2. Image processing and motion estimation](2/) | Grayscale conversion, thresholding, connected components, template matching for Latin and Persian license plates, plate localization, and frame differencing | [`p1.m`](2/p1/p1.m), [`p2.m`](2/p2/p2.m), [`p3.m`](2/p3/p3.m), [`p45.m`](2/p4/p45.m) |
| [3. Image steganography and video processing](3/) | Text encoding in image least-significant bits, textured-block selection, message recovery, and motion detection with manually selected exclusion regions | [`p1.m`](3/p1.m), [`coding.m`](3/coding.m), [`decoding.m`](3/decoding.m), [`p2.m`](3/p2.m) |
| [4. Amplitude-based communication and classification](4/) | Mapping text to bits, amplitude-level encoding and decoding, Gaussian-noise experiments, and evaluating a saved diabetes-classification model | [`part1/main.m`](4/codes/part1/main.m), [`part2/main.m`](4/codes/part2/main.m) |
| [5. Fourier analysis and frequency-based communication](5/) | Sampling, FFT magnitude and phase spectra, frequency-shift keying, message decoding, and comparisons under increasing noise | [`part1.m`](5/part1.m), [`part2.m`](5/part2.m), [`coding_freq.m`](5/coding_freq.m), [`decoding_freq.m`](5/decoding_freq.m) |
| [6. Doppler radar and audio processing](6/) | Frequency- and phase-based speed/range estimation, multiple-target simulation, melody synthesis, WAV export, and FFT-based musical-note estimation | [`1.m`](6/1.m), [`2-1.m`](6/2-1.m), [`2-2.m`](6/2-2.m), [`2-3.m`](6/2-3.m) |

## Selected implementations

### Radar estimation

Assignment 1 estimates the delay between a transmitted pulse and its reflected signal using cross-correlation, then converts the delay into a distance estimate. It repeats the experiment with increasing Gaussian noise and plots the average estimation error.

Assignment 6 uses a simplified Doppler model to estimate target speed and range from the received signal's FFT. It also examines noise sensitivity and the combined response of two targets.

### License-plate recognition

Assignment 2 builds a template-matching pipeline: preprocess an image, remove small components, segment characters, resize them, and compare them against the supplied templates using correlation. It includes custom preprocessing functions, Latin and Persian plate examples, and a plate-localization heuristic based on the blue strip of Iranian license plates.

### Text transmission

Assignments 4 and 5 implement two approaches to transmitting a message as a sampled signal:

- **Amplitude-based encoding:** represent groups of bits with different sinusoidal amplitudes and decode them using correlation and thresholds.
- **Frequency-based encoding:** represent groups of bits with different carrier frequencies and decode them from FFT peaks.

Both include experiments that compare recovered messages as the noise level changes.

### Audio synthesis and analysis

Assignment 6 generates melodies from sinusoidal notes, saves them as WAV files, and estimates note names and durations using short-window FFT analysis. Sample outputs are included: [`my_song.wav`](6/my_song.wav) and [`moon_song.wav`](6/moon_song.wav).

## Requirements

Use MATLAB with support for figures and interactive file selection. Toolbox requirements depend on the assignment:

| Toolbox | Used for |
| --- | --- |
| Image Processing Toolbox | Image resizing, thresholding, morphology, segmentation, region measurements, and image/video visualization in assignments 2 and 3 |
| Signal Processing Toolbox | Functions such as `xcorr` and `findpeaks` in the radar exercises |
| Statistics and Machine Learning Toolbox | The saved classification model in assignment 4, depending on the model's required functions |
| Curve Fitting Toolbox — optional | Opening the saved [`curve_fitter.sfit`](1/curve_fitter.sfit) session |

## Getting started

Clone the repository:

```bash
git clone https://github.com/mhieir/Signal-And-Systems.git
cd Signal-And-Systems
```

Open MATLAB and set its **Current Folder** to the cloned repository. A convenient starting point is assignment 5: its demonstrations generate their own signals and do not require external input files.

```matlab
cd('5')
part1    % Plot sampled signals and their FFT magnitude/phase spectra.
part2    % Encode and decode text, then compare results with added noise.
cd('..')
```

Figures appear in MATLAB, and decoded messages and noise-comparison results are printed in the Command Window. Noise is generated randomly, so results can vary between runs.

### Run other assignments

Set the Current Folder to the directory containing the script before running it. Many scripts load data or call helper functions using relative paths.

| Example | Working directory | Run in MATLAB |
| --- | --- | --- |
| Least-squares parameter estimation | `1/` | `q2` |
| Pulse-based radar ranging | `1/` | `p3` |
| License-plate character recognition | `2/p1/` or `2/p2/` | `p1` or `p2`; select a sample image when prompted |
| Plate localization and recognition | `2/p3/` | `p3`; select a sample car image when prompted |
| Image steganography | `3/` | `p1`; select an image compatible with the encoder's grayscale, two-dimensional image layout |
| Amplitude-based text transmission | `4/codes/part1/` | `main` |
| Saved-model evaluation | `4/codes/part2/` | `load('trainedModel.mat'); main` |
| Doppler radar simulation | `6/` | Open `1.m` and use **Run**, or enter `run('1.m')` |
| Melody synthesis | `6/` | Open `2-1.m` or `2-2.m` and use **Run** |

### Input and compatibility notes

- **Video inputs:** `2/p4/p45.m` expects `video.mp4`, and `3/p2.m` expects `1-1.mp4`. These videos are not included. Supply a suitable video in the corresponding working directory, or update the filename in the script. The second script writes an annotated video to `target_tracking.mp4`.
- **Template folders:** the OCR scripts refer to `Map Set`, while some folders are named `Map set`. They also use a Windows-style directory reference in `dir('Map Set\')`. On macOS or Linux, match the folder's exact capitalization and use a portable reference such as `dir(fullfile('Map set', '*'))` where appropriate.
- **Note-extraction script:** `6/2-3.m` contains `extract_notes` before its script statements. MATLAB releases that require local functions at the end of scripts need the function moved below the calling code, or placed in a separate `extract_notes.m` file.
- **Generated files:** some scripts write images, audio, text, or video into the working directory. Running them may replace existing outputs with the same names.

## Assignment documents and reports

The PDFs contain assignment material, explanations, plots, and recorded outputs. Most written material is in Persian.

| Assignment | Documents |
| --- | --- |
| 1 | [Assignment](1/ca1.pdf) · [Report](1/report.pdf) |
| 2 | [Project document and report](2/Signal%20-%20CA2.pdf) |
| 3 | [Project document](3/Signal%20-%20CA3.pdf) |
| 4 | [Assignment](4/ca4.pdf) · [Report](4/report.pdf) |
| 5 | [Project document and report](5/Signal%20-%20CA5.pdf) |
| 6 | [Project document and report](6/Signal%20-%20CA5-2.pdf) |

## Author

[Mahdis Mirzaei](https://github.com/mhieir) · Computer Engineering, University of Tehran
