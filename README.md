# Decoding Dropout Rates: A Quantitative Analysis of High School Students’ Retention Rate based on Social Factors & Perception of Schooling #

## Introduction ##
High school dropout rates are influenced by a complex web of factors, and understanding these dynamics is crucial for addressing this persistent challenge. Let's dive a little deeper into the key elements at play!

One significant factor is the students' perceptions of their school environment and the relationships they form with their peers. Research has shown that students who feel unsafe at school or experience peer rejection and isolation are at a much higher risk of dropping out (Cueller et al., 2017). When students don't feel a sense of belonging or support within the school community, it can lead to disengagement and a higher likelihood of them leaving the education system prematurely. Closely tied to the issue of school climate is also the problem of chronic absenteeism. This is often linked to safety concerns and other challenges that students face, and it has been identified as a strong predictor of school dropout (School Dropouts — The Civil Rights Project at UCLA, n.d.). When students are frequently absent from school, they miss out on crucial learning opportunities and can quickly fall behind, further contributing to their decision to leave school.

Meanwhile, a hidden factor that can contribute to high school dropout rates is the potential disconnect between how schools define success and how students themselves define it. Schools often focus on metrics like test scores and graduation rates, while students may place more value on feeling supported, having a sense of belonging, and finding relevance in their education (DeLuca & Rosenbaum, 2000). When these definitions don't align, students can become disengaged and ultimately decide to leave school, as they may not see the value in the educational system as it is currently structured.

By understanding these multifaceted factors, we can work towards developing more holistic and student-centered approaches to addressing the high school dropout crisis!

## Data ##
Originally from the NCES’s National Longitudinal Study 2002-2012, the dataset used for this project were student-level survey responses administered in 2002 (when students in the study were enrolled in 9th grade) and a follow-up survey administered in 2004 (when these students, if remained on a typical high school track, would be entering 12th grade). The original dataset contained over 16,000 observations of 146 variables.

The packages used for this project are listed below:

```R
library(broom)
library(caret)
library(dplyr)
library(lmtest)
library(ggplot2)
library(DMwR2)
library(ROSE)
library(randomForest)
library(rpart)
library(rpart.plot)
library(partykit)
library(shiny)
library(shinydashboard)
```

## Data Dictionary ##

After selecting relevant variables and filtering data with valid drop out status, we have the new sample with 13,914 observations and 143 variables. We then filter out the sample with non-missing data. Below are the summary statistics of the 10 representative variables in the new sample.

Variable   |   Obs    |   Unique  |   Mean    |   Min  |   Max     | Label                                                                                                                       |
-----------|----------|-----------|-----------|--------|---------- |-----------------------------------------------------------------------------------------------------------------------------|
bys20k     |   4,936   |      4    |   2.616   |    1   |    4     | Disruptions get in way of learning (=1 if strongly agree, =2 if agree, =3 if disagree, =4 if strongly disagree)             |
bys21c     |   4,936   |      4    |   2.307   |    1   |    4     | Punishment same no matter who you are (=1 if strongly agree, =2 if agree, =3 if disagree, =4 if strongly disagree)          |
bys22a     |   4,936   |      3    |   1.417   |    1   |    3     | Had something stolen at school (=1 if never, =2 if once or twice, =3 more than twice)                                       |
bys23c     |   4,936   |      2    |   0.617   |    0   |    1     | Recognized for good grades (=1 if yes, =0 no)                                                                               |
bys35a     |   4,936   |      4    |   1.096   |    0   |    3     | Hours/week spent on math homework in school (=0 if 0 hour, =1 if 1-3 hours, =2 if 4-10 hours, =3 if 11+ hours)              |
bys37      |   4,936   |      4    |   3.491   |    1   |    4     | Importance of good grades to student (=1 if not important, =2 if somewhat important, =3 if important, =4 if very important) |
bys54f     |   4,936   |      3    |   2.319   |    1   |    3     | Importance of helping others in community (=1 if not important, =2 if somewhat important, =3 if important)                  |
bys54i     |   4,936   |      3    |   1.696   |    1   |    3     | Importance of getting away from this area (=1 if not important, =2 if somewhat important, =3 if important)                  |
bys56      |   4,936   |      5    |   5.627   |    3   |    7     | How far in school student think will get (=1 if less than high school, =2 if High school graduation/GED only, =3 if Attend/complete 2-year college/school, =4 if Attend college, 4-year degree incomplete, =5 if Graduate from college, =6 if Obtain Master's degree or equivalent, =7 if Obtain PhD, MD, or other advanced degree)                                                                                    |
f1doqflg   |   4936   |      2    |   0.019   |    0   |    1     | Dropout status (=1 if drop out, =0 otherwise)                                                                              |

## EDA ##
## 1. What is the proportion of students who dropped out by 12th grade?
```R
ggplot(df, aes(x = "", y = counts, fill = category)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  ggtitle("DIstribution of Student's status by first Follow-up") +
  theme_void() +
  theme(legend.position = "right") +
  labs(fill = "")
```

![Distribution of Student's status by first Follow-up](https://github.com/mandachan-727/Data400_Spring24/assets/94765975/2c00726d-9761-4693-a637-70437d972bcd)

Suprisingly, the proportion of dropouts within our sample is 6% less than the 10.3% rate recorded by NCES in 2004! We'll tackle this imbalance as we move forward with analysis.

## 2. How do 9th-grade students feel about different life values?
```R
labels <- c("Success in work", "Marry right person", "Having money", "Strong friendships", "Steady work", 
            "Helping community", "Children's opportunities", "Living close to relatives", "Getting away", 
            "Correct inequalities", "Having children", "Leisure time", "Expert in work", "Good education")

# Melt the dataframe to bring it to long format for visualization
baseyear_melt <- melt(baseyear, measure.vars = c("BYS54A", "BYS54B", "BYS54C", "BYS54D", "BYS54E", "BYS54F", 
                                                 "BYS54G", "BYS54H", "BYS54I", "BYS54J", "BYS54K", "BYS54L", 
                                                 "BYS54N", "BYS54O"))

# Change the variable levels to the shortened labels
levels(baseyear_melt$variable) <- labels

# Plot
ggplot(baseyear_melt, aes(x = variable, fill = factor(value))) +
  geom_bar(position = "stack", na.rm = TRUE) +
  scale_fill_discrete(labels = c("Not important", "Somewhat important", "Very important")) + # replace with your desired labels
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "", y = "Student Count", fill = "I find this...") +
  ggtitle("How much importance I placed on...")
```

![Life Values DIst](https://github.com/mandachan-727/Data400_Spring24/assets/85417121/fbd634c1-e093-4ef9-96e1-3852b570e573)

The variation in sentiments toward 14 life values among our student sample affirmed our assumption going into this project - that students' perceived life success vary and may not align with how high schools are measuring success!

## Analysis ##
### Logistic Regression: Identify students’ risk of dropping out ###
Using a logistic regression model to identify dropout risks in high school students can offer both precision and interpretability for our data estimates. By modeling dropout status as a binary outcome, this statistical technique efficiently predicts the likelihood of a student leaving school prematurely. The model's coefficients provide valuable insights into the impact of various factors on dropout risk, enabling counselors and administrators to prioritize interventions effectively. Moreover, logistic regression generates predicted probabilities of dropout for individual students, allowing for tailored support strategies. 

The model specification:

$`\
\text{{dropout\_out}}_i = \beta_0 + \beta_1 X_{1i} + \beta_2 X_{2i} + \ldots + \beta_{73} X_{73i} + \epsilon_i
`$

The results reveal significant associations between factors, such as importance of life aspects and involvement in extracurricular activities, and students' dropout rates. Students who faced suspension or probation at least once were found to be approximately 5 times more likely to drop out, signifying a significant correlation at the 1% level. Moreover, students who dedicated 5 hours per day to watching TV/DVD on weekdays were approximately 6 times more likely to drop out, indicating a notable relationship at the 5% level. Conversely, engagement in extracurricular activities, such as participation in other clubs besides regular school activities, was associated with a 31% lower likelihood of dropping out, a significant finding at the 5% level. Students who highly valued the importance of relocating from their area demonstrated a 33.4% lower probability of dropping out compared to those who did not prioritize this factor, a finding significant at the 10% level.

Below is the result table for significant factors in our model at 1% and 5% level.
				
![image](https://github.com/mandachan-727/Data400_Spring24/assets/94765975/7dcf1427-0168-4de4-a4f0-838aecb789d6)

### Decision Trees: Explore how students' perceptions of schooling shape life values ###
To support students in achieving their life goals, it's essential to understand how different aspects of their schooling and school environment can contribute to their overall success. By conducting decision trees on 14 variables representing the importance level of various life aspects, we aim to identify key areas within the school's capacity that can guide students toward fulfilling their aspirations. 
Variable | Label |
---------|--------|
bys54a   | Importance of being successful in line of work  |
bys54b   | Importance of marrying right person/having happy family  |
bys54c   | Importance of having lots of money  |
bys54d   | Importance of having strong friendships |
bys54e   | Importance of being able to find steady work |
bys54f   | Importance of helping others in community |
bys54g   | Importance of giving children better opportunities |   
bys54h   | Importance of living close to parents/relatives |
bys54i   | Importance of getting away from this area |
bys54j   | Importance of working to correct inequalities |
bys54k   | Importance of having children |   
bys54l   | Importance of having leisure time |
bys54n   | Importance of being expert in field of work | 
bys54o   | Importance of getting good education | 

These decision trees provide a structured framework for analyzing complex interactions between students' personal goals and the resources available to them within the school setting. Through this process, educators and counselors can gain valuable insights into which aspects of schooling and the school environment have the greatest impact on students' ability to pursue and achieve their life goals. This information can then inform targeted interventions and support strategies tailored to meet the diverse needs and aspirations of students. 

In order to construct these decision trees, we began with a preliminary test of plotting a decision tree for each of the 14 life values:

```R
# List of life values
vars <- c("bys54a", "bys54b", "bys54c", "bys54d", "bys54e", "bys54f", "bys54g", "bys54h", "bys54i", "bys54j", "bys54k", "bys54l", "bys54n", "bys54o")

# Iterate the building and plotting of decision trees over each life value variable
for (var in vars) {
  # Build decision tree
  tree <- rpart(as.formula(paste(var, "~ .")), data = baseyear)
  
  # Plot decision tree
  rpart.plot(tree, main = paste("Decision Tree for", var))
}
```
Out of the 14 life values, only the modelling of bys54c (Importance of having lots of money), bys54f (Importance of helping others in community), bys54k (Importance of having children), and bys54o (Importance of getting good education) produced trees with meaningful splits; in other words, the other life values are bound in perfect prediction "stumps" - or decision trees that cannot be split by other predictors. Further data exploration shows that most of these "stumps" cases owe themselves to an imbalance in differet responses (class imbalances) for the life values. Thus, two steps were taken to mitigate this.

First, the output of these 14 life values variables were modified into binary codings, where 1 would indicate when and only when a student strongly believes in a life value (response = 3 - "High Importance") and 0 would indicate cases otherwise. 

```R
for(var in vars) {
  baseyear[[var]] <- ifelse(baseyear[[var]] == 3, 1, 0)
}
```

Next, while building decision trees and training random forest models, we also add an additional step of Random Oversampling using the ROSE package. This oversampling is applied to the training set after the data subset, consisting of one life values and predictors, had been split into a training set and a test set.

```R
# Example with bys54a
# Perform ROSE on training data
train_rose_54a <- ROSE(bys54a ~ ., data = train_data_54a)
train_data_54a <- train_rose_54a$data
```

Below is the decision tree that reveals interesting trends in how students perceive friendships. Among the students surveyed who valued strong friendships, those who believed school fosters friendships further divided into subgroups. Male students who agreed with this statement and participated in extracurricular activities placed a higher value on strong friendships compared to their non-participating counterparts. This suggests a possible link between valuing friendships and involvement in extracurricular activities among male students, though it doesn't necessarily prove that participation directly causes a stronger emphasis on friendships.
![image](https://github.com/mandachan-727/Data400_Spring24/assets/94765975/21770b74-8ed4-48f4-aae8-3f1b31f9605b)

The next decision tree shows that students who perceive school as a place to make friends and participate in extracurricular activities are more likely to value strong friendships. Overall, 100% of the students surveyed stated that they value strong friendships. However, there were further distinctions within this group. Students were asked if they agreed with the statement, "School is a place to meet friends." Those who agreed (79%) were then asked about their extracurricular involvement. Students who participated in extracurricular activities and identified as male (28% of the total sample) were the most likely group to strongly agree that having strong friendships is important. This suggests a possible link between valuing friendships and involvement in extracurricular activities among male students, though it doesn't necessarily prove that participation directly causes a stronger emphasis on friendships.
![image](https://github.com/mandachan-727/Data400_Spring24/assets/94765975/18d3c40b-e48a-4075-a33a-11a54e175da7)

To see other tables, please access [this link.](https://dickinson0-my.sharepoint.com/:b:/g/personal/tranam_dickinson_edu/EYjIwxsabwlCtZnjsYrUAmoBmiJ1eJqTG0gUJGQT_b-Hnw?e=DGYaQJ)

## Conclusion ##
The retention rate of high school students is subject to the influence of a multitude of factors that extend beyond mere academic performance. While educational standards certainly play a role, other crucial determinants such as family background, social dynamics within the school community, and students' perceptions of their learning environment significantly impact their decision to remain enrolled. This comprehensive study underscores the critical role of educational institutions in actively fostering a safe and supportive atmosphere. By prioritizing initiatives aimed at preventing distractions and bullying, schools can create an environment conducive to learning, which ultimately contributes to improved retention rates. By addressing these fundamental concerns, schools can enhance not only the academic outcomes of their students but also their overall well-being and sense of belonging within the educational community.

The experiences of high school students are deeply intertwined with their perceptions of safety, social interactions, and the overall value they attribute to their education. Research indicates that students' feelings of security, the quality of their classroom environments, and their interactions with peers and educators profoundly influence their priorities and outlook on life. High school counselors play a pivotal role in leveraging these insights to guide meaningful conversations that connect students with the resources available to them within the school environment. By facilitating discussions that explore students' values, aspirations, and concerns, counselors can help students develop a clearer understanding of their goals and the pathways to achieving them. Through personalized support and guidance, counselors empower students to navigate challenges, make informed decisions, and pursue their aspirations with confidence and purpose.
