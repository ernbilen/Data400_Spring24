# Project 3  Idea
##### _Thomas Sniezek_

### Research Question
What factors contribute significantly to the average salary of a new NBA contract? Can we predict what the new average salary will be?


### Implications and Why it is Interesting
This idea can help players expect what to receive from contracts before they have them. Also it could help them to determine what statistics are valued and what they should practice more if they want to get larger contracts. This could shape the NBA into a league full of the similar type of player, it may be easier to lose certain play types if money becomes the players main focus. When making this model, we must ensure that salary disparities are not driven by factors such as race, ethnicity, or other visibale characteristics. We must make sure  the privacy roghts of individuals and the teams is not violated when obtaining the information needed to create this model. Understanding the features that play into the salaries of professional sports could raise societal questions about income inequality and wealth distribution. This could impact how fans see the players of their favorite leagues. This could also impact player league negotiations and how players interact with both the teams they play for and the other players. It could cause the league to be more greedy if the model finds that less assists and more points leads to a larger average salary. 


### Data and Model Specifications
The data is collected from a data set on Kaggle. There is a little bit of cleaning that needs to be done including making all of the values averages per game instead of statistics for the whole season. This will be done by dividing the values such as points by the number of games played in that year by the player. The drawback from this data is that it has a limited number of values, only around 200 different values. The data is from the 2010/2011 season to the 2019/2020 season. To create this model, I will use a linear regression to determine relationships between the independent variables and the dependent variable of average salary per year. 


### Link and Features
[Current NBA Players Contracts History](https://www.kaggle.com/datasets/jarosawjaworski/current-nba-players-contracts-history/data)
There are 28 different variables to choose from when creating the model including points, games, assists, steals, blocks, average salary and FG%

