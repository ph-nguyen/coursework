import requests
import json
import sys
import time
import os
import codecs

ARTICLE_SEARCH_URL = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

#Your code should take an API key, section name, and number of articles as command line arguments
#write out a tab-delimited file where each article is in a separate row, with section_name, web_url, pub_date, and snippet as columns
if __name__=='__main__':
    if len(sys.argv) != 3:
        sys.stderr.write('usage: %s <section> <number of article>\n' % sys.argv[0])
        sys.exit(1)
    
    #THis is to replace command line
    api_key = '48963ca014a045bfb79f57923cfd767d'
    #section_name = 'world'
    #num_article = '1000'

    section_name = sys.argv[1]    
    num_article = sys.argv[2]
    total_page = 0
    if int(num_article) >=10:
        if int(num_article) % 10 == 0:
            total_page = int(int(num_article)/10)
        else:
            total_page = int(int(num_article)/10) + 1

    #header ofthe file
    heading = ['section_name', 'web_url', 'pub_date', 'snippet']
    filename = 'nyt_article_' + section_name + '.tsv'
    fileDir = r'C:\Users\Phuong Nguyen\Documents\ds3\coursework\week4'
    fullfilename = os.path.join(fileDir, filename)
    
    f = codecs.open(fullfilename, 'w', encoding='utf-8')
    f.write('\t'.join(heading) + '\n')

    for i in range(0,total_page):
        params = {'api-key': api_key,
        'fq': 'section_name:' + section_name,
        'page': i,
        'sort':'newest'}
        r = requests.get(ARTICLE_SEARCH_URL, params)
        data = json.loads(r.content)
        
        for doc in data['response']['docs']:
            dataList = [section_name, doc['web_url'], doc['pub_date'], doc['snippet'].strip('\n')]
            f.write('\t'.join(dataList)+'\n') 
        time.sleep(1)
        print('page' + str(i))
        
    f.close()

