(in-package #:cl-knowledge-base)

(defparameter +header-sigil+ "----"
  "the sigil that separates the header from the markdown document.")

(defun parse-question (path)
  "Read question from file at `path'."
  (with-open-file (in path)
    (let ((title nil)
          (tags nil)
          (body))
      (unless (string= +header-sigil+ (read-line in))
        (error "File ~A does not start with ~A" path +header-sigil+))

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
      (make-instance 'document :title title :tags tags :body body))))

(defun write-as-file (question &optional stream)
  "Write to `stream' the `question' as it could be read."
  (format stream "~A~%" +header-sigil+)
  (format stream "title: ~A~%" (title question))
  (format stream "tags: ~{~A~^, ~}~%" (tags question))
  (format stream "~A~%" +header-sigil+)
  (format stream "~A" (%body question)))

(defun load-questions (root-path)
  "Load the questions from the `root-path' directory to image."
  (setf *questions*
        (mapcar #'parse-question (uiop/filesystem:directory-files root-path))))
