(in-package #:cl-knowledge-base)

(defvar *questions* nil
  "A list of questions")

(defclass question ()
    ((title :initarg :title :reader title)
     (tags :initarg :tags :initform nil :reader tags)
     (%body :initarg :%body :accessor %body
            :documentation "The body as unprocessed markdown. Useful for when
            serializing the question back to file.")
     (body :initarg :body :reader body)))

(defun list-tags ()
  (remove-duplicates
   (loop :for question :in *questions*
         :append (match question
                   ((class document :tags tags) tags)))
   :test #'string=))
