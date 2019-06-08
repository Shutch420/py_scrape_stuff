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
	 ,(let ((l `((mfgr (string "NVIDIA"))
		     (released (string "2008"))
		     (sort (string "name"))
		     
		     )))

	    `(def gen_url (&key (database (string "gpu-specs")) ;; or cpudb
				,@(loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (if value
					      `(,name ,value)
					      `(,name (string ""))))))
	       (return (dot (string ,(with-output-to-string (s)
				       (format s "https://www.techpowerup.com/{}/?")
				       (loop for e in l collect
					    (destructuring-bind (name &optional value) e
					      (format s "&~a={}" name value)))))
			    (format database
				    ,@(loop for e in l collect
					   (destructuring-bind (name &optional value) e
					     `(urllib.parse.quote ,name))))))
	       ))
	 
	 
	 (for (database (list ;(string "cpudb")
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
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_03_scrape_techpowerup" code))
