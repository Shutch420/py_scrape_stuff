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
		   time
		   functools
		   operator
		   )) 
	 "from bs4 import BeautifulSoup"

	 (setf df (pd.read_csv (string "techpowerup_gpu-specs.csv")))

	 ;(setf row (aref df.iloc -1))
	 (setf res (list))
	 (for ((ntuple idx row)
	       #+nil (df.iterrows)
	       #-nil(list ;(tuple 0 (aref df.iloc -1))
			  (tuple 1 (aref df.iloc 347))))
	  (do0
	   (setf url (+ (string "https://www.techpowerup.com") row.url))
	   (time.sleep .2)
	   (print (dot (string "requesting {} [{}/{}]")
		       (format url idx (len df))))
	   "# https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/"
	   (setf r (requests.get url)
		 content (r.text.replace (string "&#8203") (string ""))
		 soup (BeautifulSoup content (string "html.parser"))
		 sections (soup.find_all (lambda (tag)
					   (and (== tag.name (string "section"))
						(== (tag.get (string "class"))
						    (list (string "details"))))))
		 
		 
		 detail_list_ (+
			      (list (tuple (string url) row.url)
				    (tuple (string time) (time.time)))
			      (functools.reduce operator.iconcat 
			       ("list"
				(map (lambda (section) ("list" (map (lambda (row)
								      
								      (tuple (+ (dot (section.find (string "h2"))
										     text
										     (strip))
										(string " ")
										(row.dt.text.strip)) (row.dd.text.strip)))
								    (or
								     (and (section.find (string "div"))
									  (dot (section.find (string "div"))
									       (find_all (string "dl"))))
								     (list)))))
				     sections))
			       (list))))
	   (do0
	    (setf columns (list))
	    (for (section sections)
		 (setf col_orig (section.h2.text.strip)
		       col col_orig
		       count 2)
		 ;; append number if col occured already
		 (while (in col columns)
		   (setf col (+ col_orig (string "_") (str count))
			 count (+ 1 count)))
		 (columns.append col)))
	   (print columns)
	   #+nil (res.append ("dict" detail_list))
	   (setf df_out (pd.DataFrame res))
	   (df_out.to_csv (dot (string "techpowerup_gpu-specs_details_{}.csv")
			       (format (int (time.time))))))))))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_04_scrape_techpowerup_details" code))
