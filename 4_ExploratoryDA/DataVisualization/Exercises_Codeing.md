---
title: "R Notebook"
output: html_notebook
---

```{r}
require(ggplot2)
require(dplyr)
require(ggmap)
require(leaflet)
require(caret)
```

```{r}
require(MASS)
data("mammals")

# Loading the dataset
head(mammals)

ggplot(mammals, aes(body, brain)) + 
  geom_point() + 
  geom_smooth(method = "lm", color = "red", se = F)
```
```{r}
library(scales)
ggplot(mammals, aes(body, brain)) + 
  geom_point(alpha = 0.6) + 
  annotation_logticks() + 
  coord_fixed(xlim = c(10^-3, 10^4), ylim = c(10^-1, 10^4)) + 
  scale_x_log10("Body weight",
                breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) + 
  scale_y_log10("Brain weight") + 
  geom_smooth(color = "red", method = "lm", se = F)
```

```{r}
ggplot(iris, aes(Sepal.Length, Sepal.Width, col = Species)) + 
  geom_point() + 
  scale_x_continuous( "Length (cm)") + 
  scale_y_continuous( "Width (cm)")
```

```{r}
ggplot(mtcars, aes(factor(cyl), mpg)) + 
  geom_point()
```

```{r}
ggplot(mtcars, aes(wt, mpg, col = disp)) + 
  geom_point()
```

```{r}
ggplot(mtcars, aes(wt, mpg, size = disp)) + 
  geom_point()
```

```{r}
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  scale_x_continuous("Sepal Length (cm)") + 
  scale_y_continuous("Sepal Width (cm)") + 
  geom_point() + 
  facet_grid(. ~ Species) + 
  geom_smooth(method = "lm", col = "red", se = F)
```

```{r}
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_itter(position = position_itter( width = 0.2), alpha = 0.5) + 
  geom_smooth(method = "lm", col = "red", se = F) + 
  facet_grid( . ~ Species) + 
  scale_x_continuous("Sepal Length (cm)", 
                     limits = c(4,8)) + 
  scale_y_continuous("Sepal Width (cm)", 
                     limits = c(2,5)) + 
  theme( panel.background  = element_blank(), 
         legend.background = element_blank(),
         strip.background = element_blank(),
         axis.text = element_text( color = "black", size = 8 ),
         axis.ticks = element_line( color = "black"),
         axis.line = element_line(colour = "black"))
```

```{r}
ggplot(diamonds, aes(carat, price)) + 
  geom_itter() + 
  geom_smooth(color = "red", se = T)
```

```{r}
ggplot(diamonds, aes(carat, price, col= clarity)) + 
  geom_smooth()
```

```{r}
ggplot(diamonds, aes(carat, price, col = clarity)) + 
  geom_itter(alpha = 0.15, width = 0.1)
```

```{r}
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_point( position = position_itter(width = 0.2))
```

```{r}
ggplot(mtcars, aes(wt, mpg, col = factor(cyl))) + 
  geom_point() + 
  geom_smooth( method = "lm", se = F) + 
  geom_smooth( method = "lm", se = F, aes(group = 1), lty = 2)
```

```{r}
require(tidyr)
head(iris)
```
```{r}
iris$Flower <- 1:nrow(iris)

# iris.wide <-
iris %>% 
  gather(key, value, -Species, -Flower)

# Create dataset
iris.wide <- iris %>% gather(key, value, -Species, -Flower) %>% 
  separate(key,c("Part", "Measure"), "\\.") %>% 
  spread(Measure, value)

names(iris.wide)

# Taking apart the relation of Width by Lengt for parys by Species
ggplot(iris.wide, aes(Length, Width, col = Part)) + 
  geom_point( position = position_itter(width = 0.2)) + 
  facet_grid(. ~ Species)
  
# 
ggplot(iris.wide, aes(Width, Length, col = Species)) + 
  geom_point( position = position_itter(width = 0.3), alpha = 0.5, 
              size = 1.5) + 
  facet_grid( . ~ Part)
```

```{r}
ggplot(mtcars, aes(factor(cyl), fill = factor(am))) + 
  geom_bar(stat = "count", position = "stack")
```
```{r}
ggplot(mtcars, aes(factor(cyl), fill = factor(am))) + 
  geom_bar(stat = "count", position = "fill")
```


```{r}
ggplot(mtcars, aes(factor(cyl), fill = factor(am))) + 
  geom_bar(stat = "count", position = "dodge")
```
```{r}
ggplot(mtcars, aes(factor(cyl), fill = factor(am))) + 
  geom_bar(position = position_dodge(width = 0.3), alpha = 0.5)
```


```{r}
ggplot(mtcars, aes(factor(cyl), fill = factor(am))) + 
  geom_bar(stat = "count", position = "dodge") + 
  scale_x_discrete("Cylinders") + 
  scale_y_continuous("Number") + 
  scale_fill_manual("Transmission", labels = c("Manual", "Automatic"), 
                    values = c("#E41A1C", "#377EB8"))
```


```{r}
ggplot(mtcars, aes(mpg, y = 0)) + 
  geom_jitter() + 
  scale_y_continuous( limits = c(-2,2))
```

```{r}
ggplot(iris, aes(Species, Sepal.Width, col = Sepal.Length)) + 
  geom_point()
```

```{r}
ggplot(iris, aes(Species, Sepal.Width, col = Sepal.Length)) + 
  geom_point( position = position_jitter(width =0.3))
```

```{r}
ggplot(diamonds, aes(clarity, carat, col = price)) + 
  geom_point( position = position_jitter( width = 1))
```

```{r}
ggplot(iris.wide, aes(Width, Length, col = Part)) + 
  geom_point( position = position_jitter(width = 0.3), alpha = 0.3) + 
  facet_grid(. ~ Species) + 
  geom_smooth(method = "lm") + 
  geom_vline(xintercept = mean(iris.wide$Width))
```

```{r}
ggplot(iris.wide, aes(Width, Length, col = Part)) + 
  geom_boxplot(outlier.color = "black")
```

```{r}
str(diamonds)
ggplot(diamonds, aes(cut, price, col = color)) + 
  geom_boxplot() + 
  facet_grid(color ~ .)
```

```{r}
# Drawing a density function
ggplot(iris.wide, aes(Length, fill = Species)) + 
  geom_density(position = "dodge", alpha = 0.5)
```

```{r}
# Drawing a histogram
ggplot(iris.wide, aes(Length, fill = Species)) + 
  geom_dotplot(dotsize = 0.7)
```

```{r}
ggplot(iris.wide, aes(Length, fill = Species)) + 
  geom_histogram(position = position_dodge(width = 0.3), binwidth = 0.4, col = "black") + theme_classic()
```

