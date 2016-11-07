(in-package #:cl-knowledge-base)

(defparameter +header-sigil+ "-----"
  "The sigil that separates the header from the markdown document.")

(defun parse-question (path)
  "Read question from file at `path'."
  (with-open-file (in path)
    (let ((title nil)
          (tags nil)
          (body))
      (unless (string= +header-sigil+ (read-line in))
        (restart-case (error "File ~A~% does not start with the proper sigil, ~A" path +header-sigil+)
          (skip-error () 'skipped)))

      (loop
        :for line := (read-line in)
        :until (string= +header-sigil+ line) ; Just error out if no body
        :collect (match (split-sequence:split-sequence #\: line)
                   ((list key value) (match key
                                       ("title" (setf title value))
                                       ("tags" (setf tags
                                                     (mapcar #'(lambda (string)
                                                                 (string-trim " " string))
                                                             (split-sequence:split-sequence #\, value))))))))

      (setf body (markdown.cl:parse (format nil
                                            "~{~A~^~%~}"
                                            (loop
                                              :for line := (read-line in nil nil)
                                              :until (null line)
                                              :collect line))))
      (make-instance 'entry :title title :tags tags :body body))))

(defun write-as-file (entry &optional (stream t))
  "Write to STREAM the ENTRY as it could be read."
  ;;; XXX: Add references/see also as a final header
  (format stream "~A~%" +header-sigil+)
  (format stream "title: ~A~%" (title entry))
  (format stream "tags: ~{~A~^, ~}~%" (tags-of entry))
  (format stream "~A~%" +header-sigil+)
  (format stream "~A" (source entry)))

(defun load-entries (root-path)
  "Load the questions from the `root-path' directory to image."
  (mapcar 'save-entry (mapcar 'parse-question
                              (uiop/filesystem:directory-files root-path))))
