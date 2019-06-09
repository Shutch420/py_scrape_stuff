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
		   random
		   )) 
	 "from bs4 import BeautifulSoup"

	 (setf df (pd.read_csv (string "techpowerup_gpu-specs.csv")))

	 ;(setf row (aref df.iloc -1))
	 (setf res (list))
	 (for ((ntuple idx row)
	       #-nil (df.iterrows)
	       #+nil(list ;(tuple 0 (aref df.iloc -1))
			  (tuple 1 (aref df.iloc 347))))
	  (do0
	   (setf url (+ (string "https://www.techpowerup.com") row.url))
	   (time.sleep (* .01 (random.randint 10 60)))
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
		 )
	   (do0
	    ;; find column names
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

	   (do0
	    ;; read values and create dict with name : value
	    (setf dres (dict ((string url) row.url)
			     ((string scrape_timestamp) (time.time))))
	    (try
	     (for (section sections)
		  (if section.div
		      (for ((ntuple col_name line) (zip columns (section.div.find_all (string "dl"))))
			   (setf (aref dres (+ col_name (string " ") (line.dt.text.strip)))
				 (line.dd.text.strip)))))
	     ("Exception as e"
	      (print (dot (string "warn {}")
			  (format e)))
	      pass))
	    (res.append dres)
	    )
	   
	   ;(print columns)
	   #+nil (res.append ("dict" detail_list))
	   (setf df_out (pd.DataFrame res))
	   (df_out.to_csv (dot (string "techpowerup_gpu-specs_details_{}.csv")
			       (format (string "intermediate"))))))
	 (df_out.to_csv (dot (string "techpowerup_gpu-specs_details_{}.csv")
			       (format (int (time.time)))))
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_04_scrape_techpowerup_details" code))
