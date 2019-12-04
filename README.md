# cpsc312-proj2
CPSC312 Project 2

Contributors:

SAMANTHA CHO: 16236168

SRIJON SAHA: 21287157

Description:

Natural language processor that takes user input querying on restaurant recommendations in Vancouver, translates the ask using the Bing Translate API, parses the requirements using NLP and passes the parsed parameters to the Yelp API to output resulting restaurants in a user friendly format.

To run:
Clone repo and navigate to folder
swipl

:- [main].

?- q.

You will see a screen that prompts user input:

?- Let's find some food! Ask me:

Example queries:

What is an expensive chinese restaurant

------------------------------------------------------------------------------------------------------

Name: Bao Bei Chinese Brasserie
URL: https://www.yelp.com/biz/bao-bei-chinese-brasserie-vancouver?adjust_creative=Mzfv4d28quTDzD83TMFB7Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=Mzfv4d28quTDzD83TMFB7Q
Rating: 4.0
Price: $$$
Location: 163 Keefer Street
Phone: +1 604-688-0876

true.

------------------------------------------------------------------------------------------------------

What is an excellent expensive restaurant

------------------------------------------------------------------------------------------------------
Name: AnnaLena
URL: https://www.yelp.com/biz/annalena-vancouver?adjust_creative=Mzfv4d28quTDzD83TMFB7Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=Mzfv4d28quTDzD83TMFB7Q
Rating: 4.5
Price: $$$
Location: 1809 W 1st Avenue
Phone: +1 778-379-4052

true.
------------------------------------------------------------------------------------------------------

find me some good german restaurants

знайти деякі хороші німецькі ресторани
(Find me some good german restaurants)

ce qui est un restaurant chinois cher
(What is an expensive chinese restaurant)

Tìm cho tôi một số nhà hàng Trung Quốc giá rẻ tốt
(Find me some good cheap Chinese restaurants)

что такое один хороший французский ресторан
(What is one good French restaurant)

