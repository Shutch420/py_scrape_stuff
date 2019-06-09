(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

;; https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?keywords=&categoryId=225&locationStr=&locationId=&radius=0&sortingField=SORTING_DATE&adType=&posterType=&pageNum=1&action=find&maxPrice=&minPrice=&attributeMap[pc_zubehoer_software.art_s]=grafikkarten

(in-package :cl-py-generator)
(let ((code
       `(do0
	 #-nil(do0
                          (imports (matplotlib))
                                        ;(matplotlib.use (string "Agg"))
                          (imports ((plt matplotlib.pyplot)))
                          (plt.ion))
	 (imports (sys
		   (np numpy)
		   (pd
		    pandas)
		   pathlib
		   html
		   json
		   logging
		   requests
		   urllib
		   time
		   )) 
	 "from bs4 import BeautifulSoup"
	 ,(let ((l `((keywords)
		     (categoryId (string "225"))
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

	    `(def gen_url (&key ,@(loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (if value
					      `(,name ,value)
					      `(,name (string "")))))
				(extra (string "")))
	       (return (dot (+ (string ,(with-output-to-string (s)
					(format s "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?")
					(loop for e in l collect
					     (destructuring-bind (name &optional value) e
					       (format s "&~a={}" name value)))
					))
			       extra)
			    (format ,@(loop for e in l collect
					   (destructuring-bind (name &optional value) e
					     `(urllib.parse.quote ,name))))))
	       ))

	 (setf df (pd.read_csv (string ;"techpowerup_gpu-specs_details_1560084187.csv"
				       "techpowerup_gpu-specs_details_1560089059.csv"
				       ;"techpowerup_gpu-specs_details.csv"
				       )))



	 (def parse_entry (row &key column value_p)
	   
	   (try
	    (do0
	     (setf entry (aref row column))
	     (if (or (pd.isnull entry)
		     (== entry (string "unknown")))
		 (setf value np.nan
		       unit (string ""))
		 (do0
		  (setf
		   entry_stripped (entry.strip)
		   entry_parts (entry_stripped.split (string " "))
		   value_string (dot (aref entry_parts 0)
				     (replace (string ",") (string "")))
		   value (or
			  (and (== value_string (string "System"))
			       np.nan ; -1d0
			       )
			  (float value_string))
		   unit (dot (string " ")
			     (join (aref entry_parts "1:"))))

		  ,@(let ((l `((GFLOPS TFLOPS 1000)
			       (MPixel GPixel 1000)
			       (MTexel GTexel 1000)
			       (MVertices GVertices 1000))))
		      (loop for e in l collect
			   (destructuring-bind (small big factor) e
			     `(if (in (string ,small) unit)
				  (setf unit (unit.replace (string ,small)
							   (string ,big)
							   )
					value (/ value ,factor)))))))))
	    ("Exception as e"
	     (print (dot (string "warn {}")
			 (format e)))
	     (return np.nan ;-2d0
		     )))
	   (if value_p
	       (return value)
	       (return unit)))

	 (def parse_date (row &key column value_p)
	   (setf str (aref row column))
	   (try
	    (return (pd.to_datetime str))
	    ("Exception as e" 
	     (return np.nan))))
	 
	 ,(let ((l `((tflops16 "Theoretical Performance FP16 (half) performance")
		     (tflops32 "Theoretical Performance FP32 (float) performance")
		     (tflops64 "Theoretical Performance FP64 (double) performance")
		     (pixel_rate "Theoretical Performance Pixel Rate")
		     (tex_rate "Theoretical Performance Texture Rate")
		     (vertex_rate "Theoretical Performance Vertex Rate")
		     (transistors "Graphics Processor Transistors")
		     (mem_bandwidth "Memory Bandwidth")
		     (die_size "Graphics Processor Die Size") 
		     (tdp "Board Design TDP")
		     (release_date "Graphics Card Release Date" :parser parse_date :unit nil)
		     (launch_price "Graphics Card Launch Price")
		     (process_size "Graphics Processor Process Size")
		     )))
	   `(do0
	     ,@(loop for e in l collect
		    (destructuring-bind (name colname &key (parser 'parse_entry) (unit t)) e
		      `(do0
			(setf (aref df (string ,name))
			      (df.apply (lambda (row) (,parser row
								   :column (string ,colname) :value_p True))
					:axis 1))
			,(if unit
			     `(setf (aref df (string ,(format nil "~a_unit" name)))
			       (df.apply (lambda (row) (,parser row
								:column (string ,colname) :value_p False))
					 :axis 1))
			     "# no unit")
		       #+nil
		       (print (dot (string ,(format nil "~a:  : value={} unit={}" name))
				   (format 
				    (parse_entry (aref df.iloc 1503)
						 :column (string ,colname) :value_p True)
				    (parse_entry (aref df.iloc 1503)
						 :column (string ,colname) :value_p False)))))))))

	 (setf url (gen_url :keywords (string "")
			    :categoryId (string "225")
			    :maxPrice (string "350")
			    :minPrice (string "120")
			    :locationStr (string "Kempen+-+Nordrhein-Westfalen")
			    :locationId (string "1139")
			    :radius (string "4000")
			    :extra (string "&attributeMap[pc_zubehoer_software.art_s]=grafikkarten")
			    ))

	 (print (dot (string "get {}")
		     (format url)))

	 (setf r (requests.get url)
	       content (r.text.replace (string "&#8203") (string ""))
	       soup (BeautifulSoup content (string "html.parser"))
	       articles (soup.find_all (string "article")
				       (dict ((string "class") (string "aditem")))))

	 (if "articles is None"
		     (do0
		      (logging.info (string "No graphics cards."))))

	 (do0
		  "# parse articles"
		  (print (dot (string "found {} articles.")
			      (format  (len articles))))
		  (setf res (list))
		  (for (article articles)
		       (try
			 (do0
			  ,(let ((l `((details (article.find (string "div") (dict ((string "class")
										   (string "aditem-details")))))
				      (price (and details
						  (dot (details.find (string "strong"))
						       text)))
				      (vb (and price
					       (in (string "VB") price)))
				      (header (article.find (string "h2")
							    (dict ((string "class")
								   (string "text-module-begin")))))
				      (href (and header
						 (aref (header.find (string "a")
								    :href True)
						       (string "href"))))
				      (date (dot (article.find (string "div")
							       (dict ((string "class")
								      (string "aditem-addon"))))
						 text
						 (strip)))
				      (ignore False)
				      (timestamp (time.time))
				      ;(article)
				      
				      )))
			     `(do0
			       ,@(loop for e in l collect
				      (destructuring-bind (name &optional code) e
					(if code
					    `(setf ,name ,code)
					    "# no code")))
			       (res.append (dict ,@(loop for e in l collect
							(destructuring-bind (name &optional code) e
							  `((string ,name) ,name))))))))
			 ("Exception as e"
			  (print (dot (string "WARNING problem {} in article {}")
				      (format e article)))
			  pass)))
		  (setf df_articles (pd.DataFrame res))
		  (df_articles.to_csv (string "output_germany_gpu_distance_to_kempen.csv")))
	 
	 #+nil
	 (do0
	  "# load the url"
	  
	  
	  (setf res (list))
	  (for ((ntuple idx (tuple keywords gen_id group_keyword device_id)) (enumerate intel_processors))
	       (try
		(do0
		 (time.sleep 3)
		 
		 
		 
		 (setf url (gen_url :keywords keywords
				    :categoryId (string "228")  ;; PCs
				    ;:radius (string "30") ;; km
				    ))
		 (setf r (requests.get url)
		       content (r.text.replace (string "&#8203") (string ""))
		       soup (BeautifulSoup content (string "html.parser"))
		       articles (soup.find_all (string "article")
					       (dict ((string "class") (string "aditem")))))
		 (if "articles is None"
		     (do0
		      (logging.info (dot (string "No articles match {}.")
					 (format keywords)))
					;(return None)
		      ))
		 (do0
		  "# parse articles"
		  (print (dot (string "searching for {} [{}/{}] {} articles.")
			     (format keywords idx (len intel_processors) (len articles))))
		  (for (article articles)
		       (try
			 (do0
			  ,(let ((l `((details (article.find (string "div") (dict ((string "class")
										   (string "aditem-details")))))
				      (price (and details
						  (dot (details.find (string "strong"))
						       text)))
				      (vb (and price
					       (in (string "VB") price)))
				      (header (article.find (string "h2")
							    (dict ((string "class")
								   (string "text-module-begin")))))
				      (href (and header
						 (aref (header.find (string "a")
								    :href True)
						       (string "href"))))
				      (date (dot (article.find (string "div")
							       (dict ((string "class")
								      (string "aditem-addon"))))
						 text
						 (strip)))
				      (ignore False)
				      (timestamp (time.time))
				      (content article)
				      (search keywords)
				      (group_keyword)
				      (device_id)
				      (gen_id))))
			     `(do0
			       ,@(loop for e in l collect
				      (destructuring-bind (name &optional code) e
					(if code
					    `(setf ,name ,code)
					    "# no code")))
			       (res.append (dict ,@(loop for e in l collect
							(destructuring-bind (name &optional code) e
							  `((string ,name) ,name))))))))
			 ("Exception as e"
			  (print (dot (string "WARNING problem {} in article {}")
				      (format e article)))
			  pass)))
		  (setf df (pd.DataFrame res))
		  (df.to_csv (string "output_germany_pc_distance_to_kempen.csv"))))
		("Exception as e"
		 (print (dot (string "WARNING problem {} in keyword {}")
			     (format e keywords)))
		 pass))))
	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_05_scrape_gpu" code))
