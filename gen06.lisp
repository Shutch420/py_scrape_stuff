(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

(in-package :cl-py-generator)
(let ((code
       `(do0
	 (imports (sys
		   (np numpy)
		   (pd
		    pandas)
		   pathlib
		   html
		   json
		   logging
		   ;requests
		   requests_html
		   urllib
		   time
		   ))
	 "from googletrans import Translator"
	 ;"from bs4 import BeautifulSoup"
	 "# pip3 install --user requests-html googletransx"
	 ;"# export PATH=$PATH:/home/martin/.local/bin"
	 "# pyppeteer-install"
		 
	 ,(let ((l `((keyword)
		     (star)
		     (page (string "1"))
		     (pageSize (string "30"))
		     (cid (string "0,1,3"))  ;; (string "0,1,4") 
		     (year (string "-1"))
		     (language (string "%E8%8B%B1%E8%AF%AD") t)
		     (region (string "-1"))
		     (status (string "-1"))
		     (orderBy (string "0"))
		     (desc (string "true")))))

	    `(def gen_url (&key ,@(loop for e in l collect
					(destructuring-bind (name &optional value dont-quote) e
					  (if value
					      `(,name ,value)
					      `(,name (string "")))))
				)
	       (with (as (open (string "/dev/shm/site")) f)
		     (setf site (dot (f.readline)
				     (strip))))
	       (return (dot (string ,(with-output-to-string (s)
				       (format s "https://www.{}/list?")
				       (loop for e in l collect
					    (destructuring-bind (name &optional value dont-quote) e
					      (format s "&~a={}" name value)))
				       ))
			    
			    (format
			     site
			     ,@(loop for e in l collect
					   (destructuring-bind (name &optional value dont-quote) e
					     (if dont-quote
						 name
						 `(urllib.parse.quote ,name)))))))
	       ))


	 
	 
	 
	 (setf url (gen_url))

	 (print (dot (string "get {}")
		     (format url)))

	 (setf session (requests_html.HTMLSession))
	 (setf r (session.get url)
	       ;content  ;(r.text.replace (string "&#8203") (string ""))
	       )
	 (r.html.render)
	 (setf elements (r.html.find (string "div[class=title-box]")))
	 (setf translator (Translator))

	 (setf res (list))
	 ,(let ((l `((喜剧 comedy) (惊悚 horror) (剧情 plot) (科幻 scifi) (动作 action) (犯罪 crime) (爱情 love)  (战争 war))))
	    `(def translate_type (str)
	       (setf lut (dict ,@(loop for (e f) in l collect
				      `((string ,e) (string ,f)))))
	       (try
		(return (aref lut str))
		("Exception as e"
		 (return (string "-"))))))
	 
	 (for (e (aref elements "3:6"))
	      (setf h (e.find (string "a") :first True
			      )
		    title h.text
		    s (e.find (string "span") :first True))
	      
	      
	      (res.append
	       (dict ((string "link") (aref h.attrs (string "href")))
		     ((string "title") title)
		     ((string "type") s.text)
		     
		     ((string "type_en") (translate_type s.text)))))
	 (setf df (pd.DataFrame res))

	 (setf rating_list (list))
	 (def get_rating (row)
	   (try
	    (do0
	     (setf rating_url (dot (string
				    "https://www.google.com/search?client=firefox-b-d&q={}+imdb+rating&gl=us")
				   (format (urllib.parse.quote row.title))))
	     (print (dot (string "get rating {}")
			 (format rating_url)))
	     
	     (setf rg (session.get rating_url))
	     (rg.html.render)
	     (setf rating (string "-"))
	     (setf rating (dot (rg.html.xpath (string "//g-review-stars/..") :first True)
			       text))
	     "global rating_list"
	     (rating_list.append rg)
	     (print (dot (string "rating {}")
			 (format rating)))
	     (time.sleep 3)
	     (return rating))
	    ("Exception as e"
	       (return (string "-")))))

	 (setf (aref df (string "rating")) (df.apply get_rating :axis 1))
	 
	 
	 #+nil
	 (do0
	  (setf english
		(translator.translate ("list" df.title)))
	  (setf (aref df (string "title_en")) ("list" (map (lambda (x) x.text) english))))

	 )))
  (write-source "/home/martin/stage/py_scrape_stuff/source/run_06" code))
