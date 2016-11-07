-----
title: How do I slurp the contents of a file
tags: files, streams
-----

``
(defun slurp-file (file-path &optional (encoding :utf-8))
  (with-open-file (in file-path :external-format encoding)
    (format nil "~{~A~^~%~}"
            (loop
              :for line := (read-line in nil)
              :until (null line)
              :collect line))))
``
