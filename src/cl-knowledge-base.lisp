(defpackage #:cl-knowledge-base
  (:use #:cl #:trivia #:trivia.ppcre)
  (:documentation "A Q&A site.

/: The top level shows all the tags.
/<tag>/: The list of all the questions tagged with <tag>.
/<tag>/id: The question.")
  (:export
   #:start))

(in-package #:cl-knowledge-base)

(defvar *questions* nil
  "A list of questions")

;; So that we can pattern match on this class in the file
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass document ()
    ((title :initarg :title :reader title)
     (tags :initarg :tags :initform nil :reader tags)
     (body :initarg :body :reader body))))

(defparameter +header-sigil+ "----"
  "the sigil that separates the header from the markdown document.")

(defun parse-question (path)
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

(defun load-questions (root-path)
  (setf *questions*
        (mapcar #'parse-question (uiop/filesystem:directory-files root-path))))

(defun list-tags ()
  (remove-duplicates
   (loop :for question :in *questions*
         :append (match question
                   ((class document :tags tags) tags)))
   :test #'string=))

;; 'Base template'
(defmacro with-page ((&key title) &body body)
   `(spinneret:with-html-string
      (:html
        (:head
         (:title ,title))
        (:body ,@body))))


;; Controllers

(defun top-level ()
  `(200 (:content-type "text/html")
        ,(babel:string-to-octets
          (with-page (:title "Cl Q&A")
            (:ul (loop :for tag :in (list-tags)
                       :collect (:li (:a :href (format nil "/tag/~A/" tag)
                                         tag))))))))

(defun tag-page (tag-name)
  "Lists the questions tagged `tag-name'"
  `(200 (:content-type "text/html")
        ,(babel:string-to-octets
          (with-page (:title tag-name)
            (loop
              :for question :in *questions*
              :when (member tag-name (tags question) :test #'string=)
                :collect (:h2 (title question))
              :when (member tag-name (tags question) :test #'string=)
                :collect (:raw (body question)))))))


;; Routing
(defvar *app*
  (lambda (env)
    (match env
      ((plist :request-method :get
              :request-uri uri)
       (match uri
         ("/" (top-level))
         ((ppcre "/tag/(\\w+)/$" name) (tag-page name)))))))

(defvar *handler* nil
  "Clack handler")

(defun start ()
  (load-questions
   (asdf:system-relative-pathname :cl-knowledge-base "knowledge-base/"))
  (setf *handler* (clack:clackup *app*)))
