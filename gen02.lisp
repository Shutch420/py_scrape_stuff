(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

(let ((code
       `(do0
	 (imports (
		   (pd pandas)
		   pathlib
		   )) 
	 (setf df (pd.read_csv (string "output_20190608b.csv")))	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_02_load" code))
