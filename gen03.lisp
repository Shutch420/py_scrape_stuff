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
		   )) 
	 "from bs4 import BeautifulSoup"
	 ,(let ((l `((mfgr (string "NVIDIA"))
		     (released (string "2008"))
		     (sort (string "name"))
		     )))

	    `(def gen_url (&key ,@(loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (if value
					      `(,name ,value)
					      `(,name (string ""))))))
	       (return (dot (string ,(with-output-to-string (s)
				   (format s "https://www.techpowerup.com/gpu-specs/?")
				   (loop for e in l collect
					(destructuring-bind (name &optional value) e
					  (format s "&~a={}" name value)))))
			    (format ,@(loop for e in l collect
					   (destructuring-bind (name &optional value) e
					     `(urllib.parse.quote ,name))))))
	       ))
	 (do0
	  (setf url (gen_url))

	  (print (dot (string "requesting {}")
		      (format url)))
	  (setf r (requests.get url)
		content (r.text.replace (string "&#8203") (string ""))
		soup (BeautifulSoup content (string "html.parser"))
		table (soup.find (string "table") (dict ((string "class")
							 (string "processors"))))
		head (table.find (string "thead") (dict ((string "class")
							 (string "colheader"))))
		columns ("list" (map (lambda (x) x.text) (head.find_all (string "th"))))
		rows (rows.find_all (string "tr"))
		)
	  )
	 
	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_03_scrape_techpowerup" code))
