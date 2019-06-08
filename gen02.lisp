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
		   )) 
	 (setf df (pd.read_csv (string "output_20190608b.csv")))

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
	 (setf (aref df (string "price_eur"))
	       (df.apply parse_price :axis 1)
	       (aref df (string "link_name"))
	       (df.apply (lambda (row)
			   (dot (string "/")
				(join
				 (dot (aref row (string "href"))
				      (aref (split (string "/"))
					    "2:")
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
	       df2 (aref df1 (& (< 20 df1.index)
				(< df1.index 220)
					;(< 4 df1.generation)
				~laptop
				#+nil (|\|| nvidia
				      amd)
				(|\|| ,@ (loop for e in `(thinkcentre lenovo hp fujitsu medion dell optiplex prodesk esprimo) collect
					      `(df1.link_name.str.contains (string ,e))))
				)))
	 (with (pd.option_context (string "display.max_rows") None
                                  (string "display.max_columns") None)
               (print (aref df2 (list (string "link_name")
				      (string "generation")))))
	 (plt.hist (dot (aref df1 (< 0 df1.index))
			index) :bins 120)
	 (plt.hist (dot (aref df1 (& (< 0 df1.index)
				     ~laptop))
			index) :bins 120)
	 (plt.grid)
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_02_load" code))
