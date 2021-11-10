# Environmental Model by Frequentist Inference
 
Here, we investigate a sampling of water quality data, which can be found at  https://www.kaggle.com/adityakadiwal/water-potability.

This dataset contains several metrics of water quality, measured from 3267 different bodies of water from around the world. 
Of particular interest to me is the concentration of dissolved solids. Certain minerals and salts are water soluble, resulting in poor taste and discolouration of the water.
Here, the total dissolved solids (TDS) metric is being investigated further, measured in parts per million.

The TDS data has a positive skew, similar to that of the gamma distribution. Maximum likelihood estimation is used to find the MLE (shape and scale parameters) in order to fit this data.

A contour plot of the log-likelihood is drawn, with the point estimate of the MLE.
A 95% confidence interval is also drawn around the MLE using the log-likelihood ratio test.

Histograms of the original data and  of simulated data given the estimated parameters are compared.
