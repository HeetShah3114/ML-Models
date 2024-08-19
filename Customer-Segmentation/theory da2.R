# Load libraries
library(ggplot2)
library(cluster)
library(gridExtra)
library(grid)
library(NbClust)
library(factoextra)

# Load data
customer_data <- read.csv("C:\\Users\\heet\\Downloads\\Mall_Customers.csv")

# Check data structure and summary stats
str(customer_data)
head(customer_data)
summary(customer_data$Age)
sd(customer_data$Age)
summary(customer_data$Annual.Income..k..)
sd(customer_data$Annual.Income..k..)
summary(customer_data$Spending.Score..1.100.)
sd(customer_data$Spending.Score..1.100.)
print(paste("Number of null values:", sum(is.na(customer_data))))

# Visualization of Gender Distribution
a <- table(customer_data$Gender)
ggplot(customer_data, aes(x = Gender)) + 
  geom_bar(aes(fill = Gender), width = 0.5) +  
  geom_text(stat='count', aes(label=..count.., y=..count..), vjust=-0.5) +  
  scale_fill_manual(values = rainbow(2)) +  
  labs(title = "Counts of Male vs Female", x = "Gender", y = "Count") +
  theme_minimal()

# Age Distribution
ggplot(customer_data, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Age", x = "Age Class", y = "Frequency") +
  theme_minimal()

# Analysis of Annual Income
ggplot(customer_data, aes(x = Annual.Income..k..)) +
  geom_histogram(fill = "#660033", color = "white", binwidth = 5) +
  labs(title = "Histogram for Annual Income", x = "Annual Income Class", y = "Frequency") +
  theme_minimal()

ggplot(customer_data, aes(x = Annual.Income..k..)) +
  geom_density(fill = "#ccff66", color = "red") +
  labs(title = "Density Plot for Annual Income", x = "Annual Income Class", y = "Density") +
  theme_minimal()

# Spending Score Analysis
ggplot(customer_data, aes(x = Spending.Score..1.100.)) +
  geom_histogram(fill = "#6600cc", color = "white", binwidth = 10) +
  labs(title = "Histogram for Spending Score", x = "Spending Score Class", y = "Frequency") +
  theme_minimal()

# K-means Clustering
data_for_clustering_scaled <- scale(customer_data[,3:5])
max_clusters <- 10
sse <- numeric(max_clusters)
for (k in 1:max_clusters) {
  set.seed(123)  
  model <- kmeans(customer_data[,3:5], centers = k, nstart = 25)
  sse[k] <- model$tot.withinss
}

# Silhouette Method
silhouette_plots <- lapply(2:10, function(k) {
  model <- kmeans(customer_data[,3:5], k, iter.max = 100, nstart = 50, algorithm = "Lloyd")
  plot(silhouette(model$cluster, dist(customer_data[,3:5], "euclidean")))
})

# Gap Statistic Method
set.seed(125)
stat_gap <- clusGap(customer_data[,3:5], FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(stat_gap)

# Performing K-means clustering with the optimal number of clusters k=6
set.seed(123)
kmeans_result <- kmeans(data_for_clustering_scaled, centers=6, nstart=25)

# Attaching cluster results to the original data for visualization
customer_data$cluster <- as.factor(kmeans_result$cluster)

# Plotting clusters
ggplot(customer_data, aes(x = Annual.Income..k.., y = Spending.Score..1.100., color = cluster)) +
  geom_point(alpha = 0.6, size = 4) +
  labs(title = "Customer Segmentation", x = "Annual Income (k)", y = "Spending Score (1-100)") +
  theme_minimal()

# Calculate distance matrix
d <- dist(data_for_clustering_scaled, method = "euclidean")

# Perform hierarchical clustering
hc <- hclust(d, method = "ward.D2")

# Plot the dendrogram
plot(hc, main = "Hierarchical Clustering Dendrogram", xlab = "Samples", ylab = "Distance")
rect.hclust(hc, k = 6, border = "red")  # Assuming you choose 5 clusters

# Cut tree to create 5 clusters
clusters <- cutree(hc, k = 6)
customer_data$hclust_clusters <- as.factor(clusters)

# Plot clusters
ggplot(customer_data, aes(x = Annual.Income..k.., y = Spending.Score..1.100., color = hclust_clusters)) +
  geom_point(alpha = 0.6, size = 4) +
  labs(title = "Hierarchical Clustering of Customers", x = "Annual Income (k)", y = "Spending Score (1-100)") +
  theme_minimal()


k_values <- 1:max_clusters

# Plotting the Elbow Method
elbow_plot <- ggplot(data.frame(k = k_values, SSE = sse), aes(x = k, y = SSE)) +
  geom_line() +  # Line connecting the points
  geom_point() +  # Points for each SSE value
  scale_x_continuous(breaks = k_values) +  # Ensure all cluster numbers are shown
  labs(title = "Elbow Method for Determining Optimal Clusters",
       x = "Number of Clusters",
       y = "Total Within Sum of Squares") +
  theme_minimal()

# Print the plot
print(elbow_plot)
