(in-package #:cl-knowledge-base)

(defpclass tag ()
  ((name :initarg :name
         :type text
         :initform nil
         :reader tag-name)))

(defpclass question ()
  ((title :initarg :title
          :type text
          :reader title)
   (source :initarg :source
           :type (or null text)
           :accessor source
           :documentation "The unprocessed source of the body. Used for
            serializing the question back to a file.")
   (body :initarg :body
         :type text
         :reader body)))

(defpassociation*
  ((:class question :slot tags :type (set tag))
   (:class tag :slot tagged-questions :type (set question))))

(defpassociation*
  ((:class question :slot references :type (set question) :reader references)
   (:class question :slot referenced-by :type(set question) :reader referenced-by)))


(defmethod print-object ((obj tag) stream)
  (print-unreadable-object (obj stream :type t)
    (princ (tag-name obj) stream)))

(defmethod print-object ((obj question) stream)
  (print-unreadable-object (obj stream :type t)
    (princ (title obj) stream)))

(defun get-tag-by-name (tag-name)
  (select-instance (tag tag)
    (where (equalp (tag-name tag) tag-name))))

(defun ensure-tag (name)
  (let ((tag (get-tag-by-name name)))
    (if tag
        tag
        (make-instance 'tag :name name))))

(defun list-tags ()
  "Return a list of all the tags used by the questions."
  (select-instances (tag tag)))

(defun get-question-by-id (oid)
  (select-instance (question question)
    (where (equalp (oid-of question) oid))))
