# Day 1

## Trees, forests, boosting
  * See the [slides](tree-boost-forest.pdf) from Rob's lecture on Decision trees, boosting, and random forests
  * Also see these interactive tutorials on [decision trees](http://www.r2d3.us/visual-intro-to-machine-learning-part-1/) and [bias and variance](http://www.r2d3.us/visual-intro-to-machine-learning-part-2/)
  * Go through Lab 8.3.1 from [Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/index.html)
  * Then do the exercise at the bottom of this [notebook](https://rpubs.com/dvorakt/248300) on predicting who survived on the Titanic
    * The notebook uses the C50 library, which may be difficult to install, so feel free to use `tree` instead <!-- or rpart -->
  * References:
    * This [notebook](https://rpubs.com/ryankelly/dtrees) has more on regression and classification trees
	* A [cheatsheet](https://www.statmethods.net/advstats/cart.html) on the `rpart` implementation of CART and the `randomForest` package
	* [Documentation](http://www.milbo.org/rpart-plot/prp.pdf) for `rpart.plot` for better decision tree plots
<!--    * Try [rpart.plot](https://stackoverflow.com/a/48881163/76259) as an alternative to the native `plot()` function for trees -->

## Intro to Python
  * See [intro.py](intro.py) for in-class Python examples
  * Install the [Anaconda Python Distribution](https://docs.anaconda.com/anaconda/install/windows) on your machine
  * References:
    * [Codecademy's Python tutorial](https://www.codecademy.com/learn/python)
    * [Learnpython's advanced tutorials](http://www.learnpython.org) on generators and list comprehensions

# Day 2

## APIs, scraping, etc.
  * See the [example](nyt_api.py) we worked on in class for the [NYTimes API](https://developer.nytimes.com/), using the [requests](http://docs.python-requests.org/en/master/user/quickstart/) module for easy http functionality
  * References:
    * [Zapier's Introduction to APIs](https://zapier.com/learn/apis/) 
    * An [overview of JSON](http://code.tutsplus.com/tutorials/understanding-json--active-8817)
    * [Python's json module](http://pymotw.com/2/json/)
  <!-- * Complete [Codecademy's API tutorial](https://www.codecademy.com/courses/50e5bc94ce7f5e4945001d31/) -->

## NYT Article search API
  * Write Python code to download the 1000 most recent articles from the New York Times (NYT) API by section of the newspaper:
      * [Register](https://developer.nytimes.com/signup) for an API key for the [Article Search API](https://developer.nytimes.com/article_search_v2.json)
      * Use the [API console](https://developer.nytimes.com/article_search_v2.json#/Console/GET/articlesearch.json) to figure out how to query the API by section (hint: set the ``fq`` parameter to ``section_name:business`` to get articles from the Business section, for instance), sorted from newest to oldest articles (more [here](https://developer.nytimes.com/article_search_v2.json#/README))
      * Once you've figured out the query you want to run, translate this to working python code
      * Your code should take an API key, section name, and number of articles as command line arguments, and write out a tab-delimited file where each article is in a separate row, with ``section_name``, ``web_url``, ``pub_date``, and ``snippet`` as columns (hint: use the [codecs](https://pymotw.com/2/codecs/#working-with-files) package to deal with unicode issues if you run into them)
      * You'll have to loop over pages of API results until you have enough articles, and you'll want to remove any newlines from article snippets to keep each article on one line
      * Use your code to downloaded the 1000 most recent articles from the Business and World sections of the New york Times.

## Article classification

* After you have 1000 articles for each section, use the code in [classify_nyt_articles.R](classify_nyt_articles.R) to read the data into R and fit a logistic regression to prediction which section an article belongs to based on the words in its snippets
    * The provided code reads in each file and uses tools from the ``tm`` package---specifically ``VectorSource``, ``Corpus``, and ``DocumentTermMatrix``---to parse the article collection into a ``sparseMatrix``, where each row corresponds to one article and each column to one word, and a non-zero entry indicates that an article contains that word (note: this assumes that there's a column named ``snippet`` in your tsv files!)
    * Create an 80% train / 20% test split of the data and use ``cv.glmnet`` to find a best-fit logistic regression model to predict ``section_name`` from ``snippet``
    * Plot of the cross-validation curve from ``cv.glmnet``
    * Quote the accuracy and AUC on the test data and use the ``ROCR`` package to provide a plot of the ROC curve for the test data
    * Look at the most informative words for each section by examining the words with the top 10 largest and smallest weights from the fitted model

<!--

  * We had a guest lecture from [Hal Daume]() on natural language processing
    * Slides on [word sense disambiguation](http://www.cs.umd.edu/class/fall2016/cmsc723/slides/slides_05.pdf), [expectation maximization](http://www.cs.umd.edu/class/fall2016/cmsc723/slides/slides_06.pdf), and [word alignment](http://www.cs.umd.edu/class/fall2016/cmsc723/slides/slides_18.pdf)
    * The [Yarowsky algorithm](https://en.wikipedia.org/wiki/Yarowsky_algorithm) for word sense disambiguation 
    * [A statistical approach to machine translation](http://dl.acm.org/citation.cfm?id=92860)
    * See these interactive demos on [k-means](https://www.naftaliharris.com/blog/visualizing-k-means-clustering/) and [mixture models](http://davpinto.com/ml-simulations/#gaussian-mixture-density)
-->

