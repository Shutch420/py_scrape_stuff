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
	       #-nil(list (tuple 0 (aref df.iloc -1))
			  (tuple 1 (aref df.iloc -2))))
	  (do0
	   (setf url (+ (string "https://www.techpowerup.com") row.url))
	   (time.sleep 3)
	   (print (dot (string "requesting {} [{}/{}]")
		       (format url idx (len df))))
	   "# https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/"
	   (setf r (requests.get url)
		 content (r.text.replace (string "&#8203") (string ""))
		 soup (BeautifulSoup content (string "html.parser"))
		 sections (soup.find_all (string "section")
					 (dict ((string "class")
						(string "details"))))
		 detail_list (+
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
	   (res.append ("dict" detail_list))
	   (setf df_out (pd.DataFrame res))
	   (df_out.to_csv )))

	 #+nil(for (database (list ;(string "cpudb")
			      (string "gpu-specs")))
	      (setf data (list))
	      (if (== database (string "cpudb"))
		  (setf mfgrs (list (string "Intel")
				    (string "AMD")))
		  (if (== database (string "gpu-specs"))
		   (setf mfgrs (list (string "NVIDIA")
				     (string "AMD")))))
	      (for (mfgr mfgrs)
	       (for (year (range 2006 (+ 1 2019)))
		    (do0
		     (setf url (gen_url :database database :mfgr mfgr :released (str year)))
		     (time.sleep 3)
		     (print (dot (string "requesting {}")
				 (format url)))
		     (setf r (requests.get url)
			   content (r.text.replace (string "&#8203") (string ""))
			   soup (BeautifulSoup content (string "html.parser"))
			   table (soup.find (string "table") (dict ((string "class")
								    (string "processors"))))
			   head (table.find (string "thead") (dict ((string "class")
								    (string "colheader"))))
			   columns ("list" (map (lambda (x) (x.text.strip)) (head.find_all (string "th"))))
			   rows (dot table
				     (find_all (string "tr")))
			   data (+ data ("list" (map (lambda (row)
						       ("dict" (+ (list (tuple (string "time") (time.time))
									(tuple (string "mfgr") mfgr)
									(tuple (string "year") year)
									(tuple (string "url") ;;(rows[12].find('td',{"class":"vendor-NVIDIA"})).a['href']

									       (or (and (== database (string "gpu-specs"))
											(dot (row.find (string "td")
												   (dict ((string "class")
													  (+ (string "vendor-") mfgr))))
											     (aref a (string "href"))))
										   (and (== database (string "cpudb"))
											(dot (row.find (string "td"))
											     (aref a (string "href")))
											))
									       ))
								  ("list"
								   (zip
								    columns
								    (map (lambda (td)
									   (td.text.strip))
									 (row.find_all (string "td"))))))))
						     (aref rows "2:") ;; top two rows are no data
 						     )))
					;data1 (functools.reduce operator.iconcat data (list))
			   df (pd.DataFrame data)
			   )
		     (df.to_csv (dot (string "techpowerup_{}.csv")
				     (format database)))
		     ))))
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_04_scrape_techpowerup_details" code))
