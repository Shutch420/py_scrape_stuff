(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

(let ((code
       `(do0
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
			(sort_index)))
	 (with (pd.option_context (string "display.max_rows") None
                                  (string "display.max_columns") None)
               (print (aref df1 (list (string "link_name")))))

	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_02_load" code))
