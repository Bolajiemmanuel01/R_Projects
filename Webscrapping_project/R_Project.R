---
title: "R Notebook"
output: html_notebook
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code. 

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 

```{r}
get_wiki_covid19_page <- function() {
    
  # Our target COVID-19 wiki page URL is: https://en.wikipedia.org/w/index.php?title=Template:COVID-19_testing_by_country  
  # Which has two parts: 
    # 1) base URL `https://en.wikipedia.org/w/index.php  
    # 2) URL parameter: `title=Template:COVID-19_testing_by_country`, seperated by question mark ?
    
  # Wiki page base
  wiki_base_url <- "https://en.wikipedia.org/w/index.php"
  # You will need to create a List which has an element called `title` to specify which page you want to get from Wiki
  # in our case, it will be `Template:COVID-19_testing_by_country`
  url_parameter <- "title=Template:COVID-19_testing_by_country"
  covid19_url <- paste(wiki_base_url, url_parameter, sep = "?")
  # - Use the `GET` function in httr library with a `url` argument and a `query` arugment to get a HTTP response
  response <- GET(covid19_url)
  # Use the `return` function to return the response
return(response) 
}
```
```{r}
covid_page <- get_wiki_covid19_page()
covid_page
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.
```{r}
# Get the root html node from the http response in task 1 
root_node <- read_html(get_wiki_covid19_page())
root_node
```

```{r}
# Get the table node from the root html node
table_node <- html_nodes(root_node, "table")
table_node
```

```{r}
# Read the table node and convert it into a data frame, and print the data frame for review
covid_df <- as.data.frame(html_table(table_node[2]))
head(covid_df)
```

```{r}
# Print the summary of the data frame
summary(covid_df)
```
```{r}
preprocess_covid_data_frame <- function(data_frame) {
    
    shape <- dim(data_frame)

    # Remove the World row
    data_frame<-data_frame[!(data_frame$`Country.or.region`=="World"),]
    # Remove the last row
    data_frame <- data_frame[1:172, ]
    
    # We dont need the Units and Ref columns, so can be removed
    data_frame["Ref."] <- NULL
    data_frame["Units.b."] <- NULL
    
    # Renaming the columns
    names(data_frame) <- c("country", "date", "tested", "confirmed", "confirmed.tested.ratio", "tested.population.ratio", "confirmed.population.ratio")
    
    # Convert column data types
    data_frame$country <- as.factor(data_frame$country)
    data_frame$date <- as.factor(data_frame$date)
    data_frame$tested <- as.numeric(gsub(",","",data_frame$tested))
    data_frame$confirmed <- as.numeric(gsub(",","",data_frame$confirmed))
    data_frame$'confirmed.tested.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.tested.ratio`))
    data_frame$'tested.population.ratio' <- as.numeric(gsub(",","",data_frame$`tested.population.ratio`))
    data_frame$'confirmed.population.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.population.ratio`))
    
    return(data_frame)
}
```

```{r}
# call `preprocess_covid_data_frame` function and assign it to a new data frame
New_covid_df <- preprocess_covid_data_frame(covid_df)
head(New_covid_df)
```

```{r}
# Print the summary of the processed data frame again
summary(New_covid_df)
```

```{r}
# Export the data frame to a csv file
write.csv(x = New_covid_df, file = "C:/Users/a/Downloads/r_project/covid.csv")
```
```{r}
# Get working directory
wd <- getwd()
# Get exported 
file_path <- paste(wd, sep="", "/covid.csv")
# File path
print(file_path)
file.exists(file_path)
```

```{r}
# Read covid_data_frame_csv from the csv file
data_read <- read.csv("C:/Users/a/OneDrive/Documents/covid.csv")
data_read

# Get the 5th to 10th rows, with two "country" "confirmed" columns
viewed <- New_covid_df[5:10,c("country", "confirmed")]
viewed
```

```{r}
# Get the total confirmed cases worldwide
total_cases <-sum()

# Get the total tested cases worldwide

# Get the positive ratio (confirmed / tested)

```

```{r}
total <- sum(viewed[, c("confirmed")])
total
```

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Ctrl+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.
