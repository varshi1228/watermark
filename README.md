# DWM [![View Digital Watermarking – Comparison of DCT and DWT methods on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/78790-digital-watermarking-comparison-of-dct-and-dwt-methods) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/etfovac/watermark/blob/master/LICENSE) [![GitHub (pre-)release](https://img.shields.io/badge/releases--yellow.svg)](https://github.com/etfovac/watermark/releases) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5279679.svg)](https://doi.org/10.5281/zenodo.5279679)  

### Keywords:

> DWM,	Digital Watermarking, Digital Watermark

> DWT,	Discrete Wavelet Transform

> DCT,	Discrete Cosine Transform

> Digital Image processing


## Basic Overview  
Digital Watermarking (DWM) is a technique of protecting digital data. This code base implements 2 methods for marking digital images based on Discrete Cosine Transform (DCT) and Discrete Wavelet Transform (DWT).  
Several attacks (signal degradations such as noise, dithering, filtering, cropping, lossy JPEG compression) on marked image were conducted. Attacked images are saved and the watermark is extracted.  
Robustness of DWT vs DCT is graded based on the quality of extracted watermark. The measure used is the Correlation coefficient (0-100% or 0-1). 

### Flowchart  
<img src="./graphics/Flowchart_ENG.png" alt="Flowchart" width="430" height="450">  

### Discrete Wavelet Transform Breakdown  
<img src="./graphics/DWT_Breakdown.png" alt="DWT_Breakdown" width="427" height="412"> <img src="./graphics/DWT_Breakdown0.png" alt="DWT_Breakdown0" width="437" height="199">  
<img src="./graphics/DWT_Breakdown1.png" alt="DWT_Breakdown1" width="429" height="214"> <img src="./graphics/DWT_Breakdown2.png" alt="DWT_Breakdown2" width="434" height="213">  

### Using the App  
<img src="./graphics/Main.png" alt="Main"> >> <img src="./graphics/MethodSelection.png" alt="MethodSelection"> >> <img src="./graphics/AttackSelection.png" alt="AttackSelection">  

### Example Log  
#### Case: No watermark, no attak, no detection
```
Not marked. Watermark method: None.
Attack: None
C:\Users\dzoni\Documents\GitHub\watermark\output\marked\Marked_image_None.tif
Not detected. Watermark method: None.

 Correlation Coefficient of the watermarks   NaN
 Normalized Correlation of the watermarks   0.000000
 Correlation Coefficient of the images   1.000000
 Normalized Correlation of the images   1.000000  

 Num of bit errors in detected watermark 2635   
 BER [%] for detected watermark 64.331055  
*******************************************************
```
#### Case: Watermarked, no attak, detection comparison
```
Method: DCT
Attack: None
C:\Users\dzoni\Documents\GitHub\watermark\output\marked\Marked_image_DCT.tif

 Correlation Coefficient of the watermarks   0.995758
 Normalized Correlation of the watermarks   0.996964
 Correlation Coefficient of the images   0.999543
 Normalized Correlation of the images   0.999996  

 Num of bit errors in detected watermark 8   
 BER [%] for detected watermark 0.195313  
*******************************************************
Method: DWT
Attack: None
C:\Users\dzoni\Documents\GitHub\watermark\output\marked\Marked_image_DWT.tif

 Correlation Coefficient of the watermarks   1.000000
 Normalized Correlation of the watermarks   1.000000
 Correlation Coefficient of the images   0.998351
 Normalized Correlation of the images   1.000107  

 Num of bit errors in detected watermark 0   
 BER [%] for detected watermark 0.000000  
*******************************************************
```

## References:  
<a href="https://www.researchgate.net/profile/Nikola_Jovanovic9">Nikola Jovanovic on ResearchGate</a>  
<a href="https://www.researchgate.net/publication/343385316_Digital_Watermarking_-_Comparison_of_DCT_and_DWT_methods">Digital Watermarking – Comparison of DCT and DWT methods, ResearchGate</a>  
<a href="https://www.researchgate.net/publication/343385676_Digital_Watermarking_in_Wavelet_domain_-_Comparison_of_different_types_of_wavelets">Digital Watermarking in Wavelet domain – Comparison of different types of wavelets, ResearchGate</a>

## Download
Download the latest [release here][0].

[0]: https://github.com/etfovac/watermark/releases
