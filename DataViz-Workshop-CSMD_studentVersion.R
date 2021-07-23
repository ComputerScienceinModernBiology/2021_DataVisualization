### DATA VISUALIZATION WORKSHOP
### COMPUTER SCIENCE IN MODERN BIOLOGY
### August 2-3, 2021
### Presenter:  Addison Zeisler
### TAs:  Karly Cazzato & Keaka Farleigh
### Content created by: Rachel Pilla


### DAY 1 ###


######################################
### Structure and design of graphs ###
######################################

### PPT:
# - components of a graph
# - understanding/perceiving a graph
# - common types of graphs for 1, 2, 3+ variables
# - keys to good graphs
# - examples of good/bad graphs


#################
### - BREAK - ### 
#################


#################################
### Creating Graphs in Base R ###
#################################

lake.temp <- read.csv(file.choose())


## start with one variable:  surface water temperature

hist(x = lake.temp$SurfaceWaterTemp)





plot(density(x = lake.temp$SurfaceWaterTemp))






## PRACTICE:  what is the distribution of bottom water temperatures?









## TWO variables:  boxplots and barplots

boxplot(SurfaceWaterTemp ~ Lake, data = lake.temp)







yearly.means <- aggregate(lake.temp$SurfaceWaterTemp,
                          by = list(lake.temp$Year),
                          FUN = mean)

barplot(yearly.means$x ~ yearly.means$Group.1)


yearly.stdev <- aggregate(lake.temp$SurfaceWaterTemp,
                          by = list(lake.temp$Year),
                          FUN = sd)

barplot(yearly.means$x ~ yearly.means$Group.1,
        xlab = "Year",
        ylab = "Average Surface Water Temperature (deg. C)",
        ylim = c(0, 28))
arrows(x0 = seq(0.7, by = 1.2, length.out = 32),
       y0 = yearly.means$x + yearly.stdev$x,
       y1 = yearly.means$x - yearly.stdev$x,
       code = 3,
       angle = 90,
       length = 0.05)


## PRACTICE:  what is the average +/- standard deviation
## of bottom water temperatures in both lakes?











## SCATTERPLOTS

plot(SurfaceWaterTemp ~ Year, data = lake.temp,
     xlab = "Year",
     ylab = "Surface Water Temperature (deg. C)")
abline(lm(SurfaceWaterTemp ~ Year, data = lake.temp))



help(points)
help(lines)









## add Lacawac to the same panel with its own trendline










## PRACTICE: Create a plot showing the trends in bottom water temperature for both lakes.
## Experiment with customizing colors, linetypes, shapes, etc.

















## PRACTICE EXERCISE:  Using the Georgia COVID-19 data set, create an improved and 
## intuitive plot showing the trends in total cases over time from the 5 counties combined.






















### DAY 2 ###


###############################
### Introduction to ggplot2 ###
###############################

### PPT:
# - grammar of graphics
# - layers of ggplot2
# - geometries, aesthetics, options/customizations


### LIVE CODING (remainder of Day 2)

install.packages(c("ggplot2", "ggpubr"))

library(ggplot2)
library(ggpubr)


# load lake water temperature data, same as yesterday

lake.temp <- read.csv(file.choose())



# Intro to ggplot
# "Grammar of Graphics" by Hadley Wickham
# - building and customizing plots in layers
# - order of the plot layers can be important!
# Recommend keeping the "ggplot()" statement BLANK
# and instead adding the specific data frame(s) in use for each layer

ggplot() +
  geom_***(data = , mapping = aes(*column names are used here*), 
           *generic/consistent arguments are used here*) +
  add_layers(*scaling, formatting, etc.*) +
  adjust_style(*theme, fonts, tick marks, etc.*) +
  

  
# histograms of lake surface water temperature
  
ggplot() +
  geom_histogram(data = lake.temp, mapping = aes(SurfaceWaterTemp))


# adjust binwidth, and add customizations (axes labels, color)








# boxplots

ggplot() +
  geom_boxplot(data = lake.temp, mapping = aes(x = Lake, y = SurfaceWaterTemp))


# customize (axes labels, color)









# PRACTICE
# create a boxplot of bottom water temperatures,
# add appropriate title and axis labels,
# color the boxes red and blue as above










# barplot of average surface water temperatures by year

yearly.means <- aggregate(lake.temp$SurfaceWaterTemp,
                          by = list(lake.temp$Year),
                          FUN = mean)

yearly.stdev <- aggregate(lake.temp$SurfaceWaterTemp,
                          by = list(lake.temp$Year),
                          FUN = sd)

yearly.data <- data.frame(yearly.means, yearly.stdev)
colnames(yearly.data) <- c("Year", "Mean", "Year2", "StDev")

ggplot() +
  geom_col(data = yearly.data, mapping = aes(x = Year, y = Mean))


# add error bars









## or can use geom_bar (though still have to calculate for errorbars)









# other customizations (color, labels, move legend, lines)

ggplot() +
  geom_col(data = lake.temp, mapping = aes(x = Year, y= SurfaceWaterTemp, fill = Lake))





  





# scatterplots
  
ggplot() +
  geom_point(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp))


# add lines to connect points (time series visual)






# recall there are TWO lakes, so each year has TWO data points -- separate by lake

ggplot() +
  geom_point(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                             group = Lake)) +
  geom_line(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                            group = Lake))









# add some general customizations (trend lines, colors, axes labels)

ggplot() +
  geom_point(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                             color = Lake, shape = Lake),
             size = 3) +
  geom_line(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                            color = Lake))




# PRACTICE
# plot of bottom water temperature over time
# appropriate title and axis labels,
# points connected by lines,
# choose appropriate colors, linetypes, shapes, etc.











###########################
### Customizing ggplot2 ###
###########################


# add an informative annotation/legend

summary(lm(SurfaceWaterTemp ~ Year,
           data = lake.temp[lake.temp$Lake == "Giles", ]))

ggplot() +
  geom_point(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                             color = Lake, shape = Lake),
             size = 3) +
  geom_line(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                            color = Lake)) +
  geom_smooth(data = lake.temp, mapping = aes(x = Year, y = SurfaceWaterTemp,
                                              color = Lake),
              se = F, method = "lm", linetype = 2) +
  scale_color_manual(values = c("blue", "black")) +
  scale_shape_manual(values = c(2, 19)) +
  labs(x = "Year", y = "Surface Water Temperature (deg. C)") +
  annotate(geom = "text", x = 2000, y = 21, color = "blue",
           label = "Giles:\nslope = 0.075 C/year\n R2 = 0.27 \n p = 0.001")


## PRACTICE: add summary for Lacawac on the same plot

















## what if we want to include bottom water temperature as well?
## need to REFORMAT the data to do automatic faceting

install.packages("tidyr")

library(tidyr)


lake.temp.long <- gather(lake.temp,
                         key = "Depth",
                         value = "Temperature",
                         SurfaceWaterTemp, BottomWaterTemp)


## FACETING to make multiple panels with long (gathered) data

ggplot() +
  geom_point(data = lake.temp.long, mapping = aes(x = Year, y = Temperature,
                                             color = Lake, shape = Lake),
             size = 3) +
  geom_line(data = lake.temp.long, mapping = aes(x = Year, y = Temperature,
                                            color = Lake)) +
  geom_smooth(data = lake.temp.long, mapping = aes(x = Year, y = Temperature,
                                              color = Lake),
              se = F, method = "lm", linetype = 2) +
  scale_color_manual(values = c("blue", "black")) +
  scale_shape_manual(values = c(2, 19))










## can also do multiple faceting











## PRACTICE:
# RE-CREATE AN IMPROVED PLOT OF THE GEORGIA COVID-19 CASE DATA FOR 5 COUNTIES
# HINT:  use ggplot2 grouping to show the patterns for each of the 5 individual counties

covid <- read.csv(file.choose())
head(covid)

covid$date <- as.POSIXct(covid$date)










## OR try a barplot to match the format more similar to the original:









## BUT there are too much data to see all the bars clearly; perhaps try
## an area plot to show changes in proportion of cases by county:











##########################################
### More plots and packages in ggplot2 ###
##########################################


## MAP example

usa.map <- map_data("state")

ggplot() +
  geom_polygon(data = usa.map, mapping = aes(x = long, y = lat))


ggplot() +
  geom_polygon(data = usa.map, mapping = aes(x = long, y = lat, group = group))


ggplot() +
  geom_polygon(data = usa.map, mapping = aes(x = long, y = lat, group = group, fill = region))


ggplot() +
  geom_polygon(data = usa.map, mapping = aes(x = long, y = lat, group = group, fill = region)) +
  geom_path(data = usa.map, mapping = aes(x = long, y = lat, group = group)) +

  geom_point(aes(x = -84.7345, y =  39.5087), size = 4, color = "black") +

  theme(legend.position = "none")


ggplot() +
  geom_polygon(data = usa.map, mapping = aes(x = long, y = lat, group = group, fill = region)) +
  geom_path(data = usa.map, mapping = aes(x = long, y = lat, group = group)) +
  coord_map() +
  theme(legend.position = "none")





library(dplyr)

head(USArrests)

arrest.map <- USArrests %>%
  mutate(region = tolower(rownames(.))) %>%
  right_join(usa.map)


ggplot() +
  geom_polygon(data = arrest.map, mapping = aes(x = long, y = lat, group = group, fill = UrbanPop)) +
  geom_path(data = arrest.map, mapping = aes(x = long, y = lat, group = group)) +
  coord_map()


ggplot() +
  geom_polygon(data = arrest.map, mapping = aes(x = long, y = lat, group = group, fill = UrbanPop)) +
  geom_path(data = arrest.map, mapping = aes(x = long, y = lat, group = group)) +
  
  geom_point(aes(x = -84.7345, y =  39.5087), size = 4, color = "red") +
  
  scale_fill_gradient(low = "grey90", high = "darkblue", trans = "log") +
  labs(title = "Urban Population by USA State") +
  coord_map()


## ggarrange for multiple panels

library(ggpubr)

urbanpop.map <- ggplot() +
  geom_polygon(data = arrest.map, mapping = aes(x = long, y = lat, group = group, fill = UrbanPop)) +
  geom_path(data = arrest.map, mapping = aes(x = long, y = lat, group = group)) +
  scale_fill_gradient(low = "grey90", high = "darkblue", trans = "log") +
  labs(title = "Urban Population by USA State") +
  coord_map()


murder.map <- ggplot() +
  geom_polygon(data = arrest.map, mapping = aes(x = long, y = lat, group = group, fill = Murder)) +
  geom_path(data = arrest.map, mapping = aes(x = long, y = lat, group = group)) +
  scale_fill_gradient(low = "grey90", high = "darkblue", trans = "log") +
  labs(title = "Murder Rate by USA State") +
  coord_map()



ggarrange(urbanpop.map, murder.map)

ggarrange(urbanpop.map, murder.map, nrow = 2, ncol = 1, labels = c("(A)", "(B)"))


## saving high resolution

ggsave(filename = "UrbanPopulationUSA.jpeg", plot = urbanpop.map,
       dpi = 1200, width = 6, height = 4, units = "in")


## OR saving any plot using base-R commands as a specific file type:

help(pdf)

pdf(file = "urbanPopulationMap.pdf",
    width = 4, height = 4)

urbanpop.map

dev.off()




jpeg(filename = "urbanPopulationMap.jpg",
    width = 6, height = 6,
    units = "in",
    res = 300)

murder.map

dev.off()




###########################################
### PRACTICE EXERCISES   (if time after ### 
### Q&A/resources, or practice at home) ###
###########################################


## built-in data set in from "ggplot2" package:
library(ggplot2)
library(dplyr)


head(msleep)
?msleep

# using these data, make three plots (can do first one together):
# 1) scatterplot of sleep cycle length vs. total amount of sleep
# 2) boxplot of rem sleep amount by vore (eating habits)
# 3) barplot of average brain weight *as a percentage of body weight* by mammilian order, with error bars
## (need package "dplyr" for #3)

# customize and modify appropriately for easy reading and good visual impact

# 1:









# 2:









# 3:
















