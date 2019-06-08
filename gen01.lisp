(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))


;; from https://en.wikipedia.org/wiki/Haswell_(microarchitecture) (select 2 table rows in firefox with C-left mouse button)
(defparameter *intel*
  `((4 haswell
       ((i7 "Core i7 Extreme" 	(5960X 5930K 5820K))
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
    (5 broadwell
       ((i7 "Core i7 "	(5775C))
	(i5 "Core i5 "	(5675C))
	(i7 "Core i7 "	(6950X 6900K 6850K 6800K))
	(i7 "Core i7 "	(5775R))
	(i5 "Core i5 "	(5675R 5575R))
	(xeon "Xeon E3 "	(1284Lv4 1278Lv4 1258Lv4 ))
	(i7 "Core i7 "	(5950HQ 5850HQ 5750HQ 5700HQ 5650U 5600U 5557U 5550U 5500U))
	(i5 "Core i5 "	(5350H 5350U 5300U 5287U 5257U 5250U 5200U))
	(i3 "Core i3 "	(5157U 5020U 5015U 5010U 5005U))
	(pentium "Pentium "	(3825U 3805U))
	(celeron "Celeron "	(3755U 3205U))
	(intel "Core M (vPro) "	(5Y71 5Y70))
	(intel "Core M "	(5Y51 5Y31 5Y10c 5Y10a 5Y10))
	(xeon "Xeon D "	(D-1587 D-1577 D-1571 D-1567 D-1559 D-1557 D-1553N D-1548 D-1543N D-1541 D-1540 D-1539 D-1537 D-1533N D-1531 D-1529 D-1528 D-1527 D-1523N D-1521 D-1520 D-1518 D-1513N))
	(pentium "Pentium D "	(D1519 D1517 D1509 D1508 D1507))
	(xeon "Xeon E3 v4 "	(1285v4 1285Lv4 1265Lv4))
	(xeon "Xeon E5 v4 "	(2699v4 2698v4 2697v4 2697Av4 2695v4 2690v4 2689v4 2687Wv4 2683v4 2680v4 2667v4 2660v4 2658v4 2650v4 2650Lv4 2648Lv4 2643v4 2640v4 2637v4 2630v4 2630Lv4 2628Lv4 2623v4 2620v4 2618Lv4 2609v4 2608Lv4 2603v4 1680v4 1660v4 1650v4 1630v4 1620v4 ))))
    (7 skylake
       ((i7 "Core i7 "	(6700K 6785R 6700 6700T))
	(i5 "Core i5 "	(6600K 6685R 6600 6585R 6500 6600T 6500T 6402P 6400T 6400))
	(i3  "Core i3 "	(6320 6300 6100 6300T 6100T 6098P))
	(pentium "Pentium "	(G4520 G4500 G4500T G4400 G4400T G4400TE))
	(celeron "Celeron "	(G3920 G3900 G3900TE G3900T))
	(i9 "Core i9  "	(7980XE 7960X 7940X 7920X 7900X))
	(i7 "Core i7 "	(7820X 7800X))
	(i9 "Core i9  "	(9980XE 9960X 9940X 9920X 9900X 9820X))
	(i7 "Core i7 "	(9800X))
	(i7 "Core i7 "	(6970HQ 6920HQ 6870HQ 6820HQ 6820HK 6770HQ 6700HQ 6660U 6650U 6600U 6567U 6560U 6500U))
	(i5 "Core i5 "	(6440HQ 6360U 6350HQ 6300HQ 6300U 6287U 6267U 6260U 6200U))
	(i3 "Core i3 "	(6167U 6157U 6100H 6100U 6006U))
	(intel "Core m7 "	(6Y75))
	(intel "Core m5 "	(6Y57 6Y54))
	(intel "Core m3 "	(6Y30))
	(pentium "Pentium "	(4405U 4405Y))
	(celeron "Celeron "	(G3902E G3900E 3955U 3855U))
	(xeon "Xeon W "	(2102 2104 2123 2125 2133 2135 2140B 2145 2150B 2155 2170B 2175 2191B 2195))
	(xeon "Xeon E3 v5 "	(1280v5 1275v5 1270v5 1260Lv5 1245v5 1240v5 1240Lv5 1230v5 1235Lv5 1225v5 1220v5 1575Mv5 1545Mv5 1535Mv5 1505Mv5 1505Lv5))
	(xeon "Xeon Bronze"	(3104 3106))
	(xeon "Xeon Silver"	(4108 4109T 4110 4112 4114 4114T 4116 4116T))
	(xeon "Xeon Gold"   (5115 5117 5117F 5118 5119T 5120 5120T 5122 6126 6126F 6126T 6128 6130 6130F 6130T 6132 6134 6134M 6136 6138 6138F 6138T 6140 6140M 6142 6142F 6142M 6144 6145 6146 6148 6148F 6149 6150 6152 6154 6161))
	(xeon "Xeon Platinum"	(8153 8156 8158 8160 8160F 8160M 8160T 8163 8164 8167M 8168 8170 8170M 8173M 8176 8176F 8176M 8180 8180M))))
    (8 kaby_lake
       ((i7 "Core i7 "	(7740X 7700K 7700 7700T))
	(i5 "Core i5 "	(7640X 7600K 7600 7600T 7500 7500T 7400 7400T))
	(i3 "Core i3 "	(7350K 7320 7300 7300T 7100 7100T 7101E 7101TE))
	(pentium "Pentium "	(G4620 G4600 G4600T G4560 G4560T))
	(celeron "Celeron "	(G3950 G3930 G3930T))
	(i7 "Core i7 "	(7920HQ 7820HQ 7820HK 7700HQ))
	(i5 "Core i5 "	(7440HQ 7300HQ))
	(i3 "Core i3 "	(7100H))
	(i7 "Core i7 "	(7660U 7600U 7567U 7560U 7500U 7Y75))
	(i5 "Core i5 "	(7360U 7300U 7287U 7267U 7260U 7200U 7Y57 7Y54))
	(i3 "Core i3 "	(7167U 7130U 7100U 7020U))
	(intel "Core m3 "	(7Y32 7Y30))
	(pentium "Pentium "	(4415U 4410Y))
	(celeron "Celeron "	(3965U 3865U 3965Y))
	(xeon "Xeon E3 "	(1285v6 1280v6 1275v6 1270v6 1245v6 1240v6 1230v6 1225v6 1220v6 1535Mv6 1505Mv6 1505Lv6))
	(i3 "Core i3 "	(8130U))
	(i7 "Core i7 "	(8650U 8550U))
	(i5 "Core i5 "	(8350U 8250U))
	(i7 "Core i7 "	(8809G 8709G 8706G 8705G))
	(i5 "Core i5 "	(8305G))
	(i7 "Core i7 "	(8510Y 8500Y))
	(i5 "Core i5 "	(8310Y 8210Y 8200Y))
	(intel "Core m3 "	(8100Y) ))))))

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
	  (setf intel_processors (list ,@(loop for e in *intel* appending
					      (destructuring-bind (gen-id gen-name devices) e
					       (loop for dev in devices appending
						    (destructuring-bind (group-keyword group-name device-ids) dev
						      (loop for d in device-ids collect
							   `(tuple (string ,(format nil "~a ~a" group-keyword d)) ,gen-id))))))))
	  (setf res (list))
	  (for ((ntuple idx (tuple keywords gen_id)) (enumerate intel_processors))
	       (do0
		(time.sleep 3)
		(print (dot (string "searching for {} [{}/{}].")
			    (format keywords idx (len intel_processors))))
	    (setf url (gen_url :keywords keywords))
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
			      (search keywords)
			      (generation gen_id))))
		     `(do0
		       ,@(loop for e in l collect
			      (destructuring-bind (name code) e
				`(setf ,name ,code)))
		       (res.append (dict ,@(loop for e in l collect
						(destructuring-bind (name code) e
						  `((string ,name) ,name))))))))
	     (setf df (pd.DataFrame res))
	     (df.to_csv (string "output.csv"))))))
	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_01_scrape" code))
