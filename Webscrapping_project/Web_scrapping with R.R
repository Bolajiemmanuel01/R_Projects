get_wiki_covid19_page <- function() {
  
  # Our target COVID-19 wiki page URL is: https://en.wikipedia.org/w/index.php?title=Template:COVID-19_testing_by_country  
  # Which has two parts: 
  # 1) base URL `https://en.wikipedia.org/w/index.php  
  # 2) URL parameter: `title=Template:COVID-19_testing_by_country`, seperated by question mark ?
  
  # Wiki page base
  wiki_base_url <- "https://en.wikipedia.org/w/index.php"
  # You will need to create a List which has an element called `title` to specify which page you want to get from Wiki
  wiki_parameters <- list(title="Template:COVID-19_testing_by_country")
  # in our case, it will be `Template:COVID-19_testing_by_country`
  
  # - Use the `GET` function in httr library with a `url` argument and a `query` arugment to get a HTTP response
  response <- GET(wiki_base_url, query=wiki_parameters)
  # Use the `return` function to return the response
  return (response)
  
}

covid_page <- get_wiki_covid19_page()
print(covid_page)

root_node <- read_html(covid_page)
root_node
body_node <- html_node(root_node, "body")
body_node
table_node <- html_node(root_node, "table")
table_node
color_data_frame <- html_table(table_node)
head(color_data_frame)
spar_node <- html_node(body_node, "table")
spar_node
df <- html_table(spar_node)
df
