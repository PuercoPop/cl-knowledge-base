(in-package #:cl-knowledge-base)

(defpclass tag ()
  ((name :initarg :name
         :type text
         :initform nil
         :reader tag-name)))

(defpclass document ()
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

;; The value #S(HU.DWIM.PEREC::UNBOUND-SLOT-MARKER)
;; in slot SOURCE of instance #< What is the diff between ()> is not of type
;; TEXT.

(defpassociation*
  ((:class document :slot tags :type (set tag))
   (:class tag :slot tagged-documents :type (set document))))

(defpassociation*
  ((:class document :slot references :type (set document) :reader references)
   (:class document :slot referenced-by :type(set document) :reader referenced-by)))


(defmethod print-tag ((obj tag) stream)
  (print-unreadable-object (obj stream :type t)
    (princ (tag-name obj))))

(defmethod print-object ((obj document) stream)
  (print-unreadable-object (obj stream :type t)
    (princ (title obj))
    #+(or)(format stream "~A (~[~A~^,~])" (title obj) (tags obj))))

(defun ensure-tag (name)
  (let ((tag (select-instance (tag tag)
               (where (equalp (tag-name tag) name)))))
    (if tag
        tag
        (make-instance 'tag :name name))))

(defun list-tags ()
  "Return a list of all the tags used by the questions."
  (select-instances (tag tag)))
