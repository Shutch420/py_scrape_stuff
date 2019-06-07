(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

(in-package :cl-py-generator)
(let ((code
       `(do0
	 (imports (sys
		   (pd pandas)
		   pathlib
		   html
		   json
		   logging
		   requests
		   urllib
		   ))
	 "from bs4 import BeautifulSoup"
	 ,(let ((l `((keywords)
		     (categoryId )
		     (locationStr)
		     (locationId )
		     (radius )
		     (sortingField (string "SORTING_DATE"))
		     (adType)
		     (posterType)
		     (pageNum (string "1"))
		     (action (string "find"))
		     (maxPrice)
		     (minPrice))))

	    (string "# https://github.com/shlnz/kleinanzeigen_scraper/blob/master/provider/kleinanzeigen_ebay.py")
	    `(def gen_url (&key ,@(loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (if value
					      `(,name ,value)
					      `(,name (string ""))))))
	       (return (dot (string ,(with-output-to-string (s)
				   (format s "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?")
				   (loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (format s "&~a={}" name value)))))
			    (format ,@(loop for e in l collect
					   (destructuring-bind (name &optional value) e
					     `(urllib.parse.quote ,name))))))
	       ))
	 (do0
	  "# load the url"
	  (setf url (gen_url :keywords (string "vega 56")))
	  (setf r (requests.get url)
		content (r.text.replace (string "&#8203") (string ""))
		soup (BeautifulSoup content (string "html.parser"))
		articles (soup.find_all (string "article")
					(dict ((string "class") (string "aditem")))))
	  (if "articles is None"
	      (do0
	       (logging.info (string "No articles match."))
					;(return None)
	       )))
	 (do0
	  "# parse articles"
	  (setf res (list))
	  (for (article articles)
	       (setf details (article.find (string "section") (dict ((string "class")
								     (string "additem-details"))))
		     price (dot (details.find (string "strong"))
				text)
		     vb (in (string "VB") price)
					;(ntuple zip_code city owner_distance)
		     header (article.find (string "h2")
					  (dict ((string "class")
						 (string "text-module-begin"))))
		     href (aref (header.find (string "a")
					     :href True)
				(string "href"))
					;description
		     ignore False
		     )
	       ,@(let ((l `(details price vb header href ignore)))
		   `(res.append (dict ,@(loop for e in l collect
					     `((string ,e) ,e))))))
	  (setf df (pd.DataFrame res)))
	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_01_scrape" code))
