import requests
import json
import sys

ARTICLE_SEARCH_URL = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

if __name__=='__main__':
   if len(sys.argv) != 4:
      sys.stderr.write('usage: %s <api_key><section_name><num_article>\n' % sys.argv[0])
      sys.exit(1)

   api_key = sys.argv[1]
   section_name = sys.argv[2]
   num_artical = sys.argv[3]
   
   heading = ['section_name', 'web_url', 'pub_date', 'snippet']

   f = open('nyt_article.tsv', 'w')
   f.write('\t', join(heading))

   for i in range(int(num_article)/10+1):
       params = {'api-key': api_key,
       'fq': 'section_name:' + section_name,
       'page': i,
       'sort':'newest'}
       r = requests.get(ARTICLE_SEARCH_URL, params)
       data = json.loads(r.content)
       
       for doc in data['response']['docs']:
           f.write('\t'.join(section_name, doc['web_url'], doc['pub_date'], doc['snippet'].strip('\n')))
           print(doc['web_url'])
