(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))


;; from https://en.wikipedia.org/wiki/Haswell_(microarchitecture) (select 2 table rows in firefox with C-left mouse button)
(defparameter *intel4*
  `((i7 "Core i7 Extreme" 	(5960X 5930K 5820K))
  (i7 "Core i7" 	(4790K 4790 4790S 4790T 4785T 4771 4770K 4770 4770S 4770R 4770T 4770TE 4765T))
  (i5 "Core i5"	(4690K 4690 4690S 4690T 4670K 4670 4670S 4670R 4670T 4590 4590S 4590T 4570 4570S 4570R 4570T 4570TE 4460 4460S 4460T 4440 4440S 4430 4430S))
  (i3 "Core i3" 	(4370 4360 4350 4340 4330 4370T 4360T 4350T 4330T 4340TE 4330TE 4170 4160 4150 4130 4170T 4160T 4150T 4130T))
  (pentium "Pentium" 	(G3470 G3460 G3450 G3440 G3430 G3420 G3460T G3450T G3440T G3420T G3320TE G3260 G3258 G3250 G3240 G3220 G3260T G3250T G3240T G3220T))
  (celeron "Celeron" 	(G1850 G1840 G1830 G1820 G1840T G1820T G1820TE))
  (xeon "Xeon E7 v3" 	(E7-8893v3 E7-8891v3 E7-8890v3 E7-8880v3 E7-8880Lv3 E7-8870v3 E7-8867v3 E7-8860v3 E7-4850v3 E7-4830v3 E7-4820v3 E7-4809v3))
  (xeon "Xeon E5 v3" 	(2699v3 2698v3 2698Av3 2697v3 2695v3 2690v3 2683v3 2680v3 2673v3 2670v3 2667v3 2660v3 2650Lv3 2658v3 2650v3 2648Lv3 2643v3 2640v3 2637v3 2630v3 2630Lv3 2628Lv3 2623v3 2620v3 2618Lv3 2609v3 2608Lv3 2603v3 2687Wv3 1680v3 1660v3 1650v3 1630v3 1620v3 1607v3 1603v3))
  (xeon "Xeon E3 v3" 	(1286v3 1286Lv3 1285v3 1285Lv3 1284Lv3 1281v3 1280v3 1276v3 1275v3 1275Lv3 1271v3 1270v3 1268Lv3 1265Lv3 1246v3 1245v3 1241v3 1240v3 1240Lv3 1231v3 1230v3 1230Lv3 1226v3 1225v3 1220v3 1220Lv3))
  (i7 "Core i7" 	(4940MX 4930MX 4980HQ 4960HQ 4950HQ 4910MQ 4900MQ 4870HQ 4860EQ 4860HQ 4850EQ 4850HQ 4810MQ 4800MQ 4770HQ 4760HQ 4750HQ 4720HQ 4712MQ 4712HQ 4710MQ 4710HQ 4702MQ 4702HQ 4700MQ 4700HQ 4701EQ 4700EQ 4702EC 4700EC 4650U 4610Y 4610M 4600M 4600U 4578U 4558U 4550U 4510U 4500U))
  (i5 "Core i5" 	(4402EC 4422E 4410E 4402E 4400E 4360U 4350U 4340M 4330M 4310M 4310U 4302Y 4300Y 4300M 4300U 4288U 4258U 4308U 4260U 4250U 4210H 4210M 4210U 4220Y 4210Y 4202Y 4200Y 4200U 4200H 4200M))
  (i3 "Core i3" 	(4158U 4120U 4112E 4110E 4102E 4100E 4110M 4100M 4100U 4030Y 4020Y 4012Y 4010Y 4030U 4025U 4010U 4005U 4000M))
  (pentium "Pentium" 	(3561Y 3560Y 3558U 3556U 3560M 3550M))
  (celeron "Celeron" 	(2981U 2980U 2957U 2955U 2970M 2950M 2961Y ))))


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
	  #+nil
	  (setf url (gen_url :keywords (string "vega 56")
			     :maxPrice (string "350")
			     :minPrice (string "120")))
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
			   (search_url url))))
		   `(do0
		     ,@(loop for e in l collect
			    (destructuring-bind (name code) e
			      `(setf ,name ,code)))
		     (res.append (dict ,@(loop for e in l collect
					      (destructuring-bind (name code) e
					       `((string ,name) ,name))))))))
	  (setf df (pd.DataFrame res))
	  (df.to_csv (string "output.csv")))
	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_01_scrape" code))
