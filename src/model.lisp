(in-package #:cl-knowledge-base)

(defvar *questions* nil
  "A list of questions")

(defun create-tables ()
  #+(or)(do-query (:create-table))
  (with-query (nil (:table-create "questions"))))

(defclass question ()
  ((title :initarg :title
          :reader title)
   (tags :initarg :tags
         :initform nil
         :type list
         :reader tags)
   (source :initarg :source
           :accessor source
           :documentation "The unprocessed source of the body. Used for
            serializing the question back to a file.")
   (body :initarg :body
         :reader body)
   (refereces)))

(defmethod print-object ((obj question) stream)
  (print-unreadable-object (obj stream)
    (format stream "~A (~[~A~^,~])" (title obj) (tags obj))))

(defun list-tags ()
  "Return a list of all the tags used by the questions."
  (remove-duplicates
   (loop
      :for question :in *questions*
      :append (match question
                     ((class question :tags tags) tags)))
   :test #'string=))
