----
title: How do I processing a String One Character at a Time
tags: strings
----

Use the MAP function to process a string one character at a time.

``
(defparameter *my-string* (string "Groucho Marx"))
;; => *MY-STRING*

(map 'string #'(lambda (c) (print c)) *my-string*)
#\G 
#\r 
#\o 
#\u 
#\c 
#\h 
#\o 
#\Space 
#\M 
#\a 
#\r 
#\x 
;; => "Groucho Marx"
``

Or do it with LOOP.

``
(loop for char across "Zeppo"
    collect char)
;; => (#\Z #\e #\p #\p #\o)
``
