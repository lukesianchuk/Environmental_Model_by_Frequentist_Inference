# Read in data, set vector of total disslved solids
temp = read.csv("water_potability.csv")
solids = temp$Solids
# Visualize data using a histogram
hist(solids, main="Total Dissolved Solids",xlab="TDS Value (ppm)", breaks=50)


# Function to calculate the log-likelihood value of a gamma distribution given a shape and scale
loglik.gam <- function(x = NULL, datax = NULL) {
  # x is a vector with shape, scale
  # datax is a vector of data
  val = sum(dgamma(datax, shape = x[1], scale = x[2], log = TRUE))
  return(val)
}

# Finding the maximum likelihood estimator of our data by optimizing the loglik function
MLE = optim(par = c(1, 1), loglik.gam, datax = solids,  control = list(fnscale = -1))
loglik.gam.mle = MLE$value
shape.mle = MLE$par[1]
scale.mle = MLE$par[2]


# Second version of the log-likelihood function
# Slower implementation, but used to calculate the loglik given a sequence of shape/scale values
loglik.gam2 <- function(shape = NULL, scale = NULL, x = NULL) {
  # shape is a vector 
  # scale is a vector 
  # x is a vector of data 
  # returns a matrix of loglik evaluated at each value of shape and scale.
  val = matrix(0, nrow = length(shape), ncol = length(scale))
  for (i in 1:length(shape)) {
    for (j in 1:length(scale)) {
      val[i, j] = sum(dgamma(x, shape = shape[i], scale = scale[j], log = TRUE))
    }
  }
  return(val)
}

# Generating a sequence of shape/scale input parameters for contour plotting
shape.seq = seq(4, 8, length.out = 100)
scale.seq = seq(1000, 8000, length.out = 100)
# Calculating array of loglik values
gam.loglik = loglik.gam2(shape = shape.seq, scale = scale.seq, x = solids)
# Finding the MLE
MLE = optim(par = c(1, 1), loglik.gam, datax = solids,  control = list(fnscale = -1))
loglik.gam.mle = MLE$value

# Plotting a contour map of the loglik around the MLE
contour(x = shape.seq, y = scale.seq, z = gam.loglik, nlevels = 15, xlab = "shape", 
        ylab = "scale",labcex=0.3,main="Log-Likelihood")
points(x = shape.mle, y = scale.mle, col = adjustcolor("firebrick", 1), pch = 19, cex = 0.5)


###

# Calculating a 95% confidence interval around the MLE using the loglik ratio test

# Geneare shape and scale input vectors for plotting
shape.seq = seq(5, 7, length.out = 100)
scale.seq = seq(3400, 4200, length.out = 101)

# Calculate a matrix of loglik values given the shape/scale input vectors
gam.loglik3 = loglik.gam2(shape = shape.seq, scale = scale.seq, x = solids)

# Create contour plot of 95% confidence interval
# uses log-likelihood ratio test, where z = -2 * (gam.loglik3 - loglik.gam.mle)
contour(x = shape.seq, y = scale.seq, 
        z = -2 * (gam.loglik3 - loglik.gam.mle),
        levels = qchisq((0.95), df = 2), 
        xlab = "shape", ylab = "scale", 
        main = "Likelilhood Ratio 95% CI")
points(x = shape.mle, y = scale.mle, col = adjustcolor("firebrick", 1), pch = 19, cex = 0.5)


# Generating data using the calculated MLE
# Creating a histogram of the modeled values to compare to the original data
par(mfrow=c(1,2))
test.data = rgamma(n=length(solids),shape=shape.mle,scale=scale.mle)
hist(solids, main="Total Dissolved Solids",xlab="TDS (ppm)", breaks=50, ylim=c(0,200),xlim=c(0,70000))
hist(test.data,main="Frequentist Model Data",xlim=c(0,70000),xlab="TDS (ppm)",breaks=50,ylim=c(0,200))



