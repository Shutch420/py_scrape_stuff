(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

(let ((code
       `(do0
	 #-nil(do0
                          (imports (matplotlib))
                                        ;(matplotlib.use (string "Agg"))
                          (imports ((plt matplotlib.pyplot)))
                          (plt.ion))

	 (imports (
		   (pd pandas)
		   pathlib
		   html
		   ))
	 "from bs4 import BeautifulSoup"
	 (setf df (pd.read_csv (string ;"output_20190608b.csv"
				"output_kempen_pc.csv"
				
				;"output_germany_pc_a.csv"
				)))

	 (def parse_price (row)
	   (try
	    (do0
	     (setf p (dot (aref row (string "price"))
			  (strip)))
	     (if (== (string "VB") p)
		 (return 0d0))
	     (return 
	       (float (dot p
			   (aref (split (string "\\u20ac")) 0)
			   ))))
	    ("Exception as e"
	     (return 0d0)))) 

	 (def parse_distance (row)
	   (try
	    (do0
	     (setf soup (BeautifulSoup (aref row (string content)) (string "html.parser"))
		   details (soup.find (string "div") (dict ((string "class")
							    (string "aditem-details"))))
		   distance (float (dot (aref (details.text.split (string "\\n")) -1) ;; last line
					(strip)
					(aref (split (string " ")) 0) ;; cut km away
					)))
	     (return distance))
	    ("Exception as e"
	     (return -1d0))))
	 
	 (setf (aref df (string "price_eur"))
	       (df.apply parse_price :axis 1)
	       (aref df (string "distance_km"))
	       (df.apply parse_distance :axis 1)
	       (aref df (string "link_name"))
	       (df.apply (lambda (row)
			   (dot (string "/")
				(join
				 (dot (aref row (string "href"))
				      (aref (split (string "/"))
					    "2:-1")
				      ))
				))
			 :axis 1))
	 (setf df1 (dot (df.set_index (string "price_eur"))
			(sort_index))
	       laptop (|\|| ,@ (loop for e in `(probook notebook laptop thinkpad ideapad lifebook yoga latitude) collect
				    `(df1.link_name.str.contains (string ,e))))
	       nvidia (|\|| ,@ (loop for e in `(gtx nvidia) collect
				    `(df1.link_name.str.contains (string ,e))))
	       amd (|\|| ,@ (loop for e in `(hd amd radeon) collect
				 `(df1.link_name.str.contains (string ,e))))
	       cpu (|\|| ,@ (loop for e in `(processor prozessor) collect
				 `(df1.link_name.str.contains (string ,e))))
	       desktop (|\|| ,@ (loop for e in `(thinkcentre lenovo hp fujitsu medion dell optiplex prodesk esprimo workstation elitedesk) collect
				     `(df1.link_name.str.contains (string ,e))))
	       older_than_haskell (|\|| ,@ (loop for e in `(i3-2 i3-3 i5-2 i5-3 i5-2 i5-3) collect
				     `(df1.link_name.str.contains (string ,e))))
	       df2 (aref df1 (& (< 20 df1.index)
				;(< df1.index 220)
					;(< 4 df1.generation)
				~laptop
				~cpu
				~older_than_haskell
				#+nil (|\|| nvidia
					    amd)
				
				desktop
				))
	       
	       )
	 
	 ;; float(details.text.split('\n')[-1].strip().split(' ')[0])
	 #+nil
	 ,@(loop for e in `(xeon i5 i7 i3) collect
		 `(setf ,(format nil "df2_~a" e) (aref df2 (df2.link_name.str.contains (string ,e)))))
	    
	    (def tbl (df2)
	     (with (pd.option_context (string "display.max_rows") None
                                      (string "display.max_columns") None

				      (string "display.max_colwidth") 1000
				      (string "display.width") 1000)
		   (print (aref df2 (list (string "link_name")
					  (string "gen_id")
					  (string "group_keyword")
					  (string "device_id")
					  (string "distance_km"))))))
	    (tbl df2)

	    ,@(loop for e in `(xeon i5 i7 i3) collect
		   `(plt.hist (dot (aref ,(format nil "df2_~a" e)
					 (< 0 (dot ,(format nil "df2_~a" e)
						   index)))
				   index)
			      :bins 120
			      :label (string ,e)))
	#+nil (do0 (plt.hist (dot (aref df1 (< 0 df1.index))
			    index) :bins 120)
	     
	     (plt.hist (dot (aref df1 (& (< 0 df1.index)
					 ~laptop))
			    index) :bins 120))
	(plt.legend)
	 (plt.grid)
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_02_load" code))
