(in-package #:cl-knowledge-base)


(defclass entry ()
  ((title :initarg :title
          :type text
          :reader title)
   (tags :initarg :tags
         :initform ()
         :reader tags-of
         :documentation "A List of tags.")
   (source :initarg :source
           :type (or null text)
           :accessor source
           :documentation "The unprocessed source of the body. Used for
            serializing the question back to a file.")
   (body :initarg :body
         :type text
         :reader body)))


(defmethod print-object ((obj entry) stream)
  (print-unreadable-object (obj stream :type t)
    (princ (title obj) stream)))

(defun entry-plist (entry)
  "Return a plist with each bound slot of ENTRY"
  (let ((result ()))
    (do-slots (slot entry)
      (let ((slot-name (c2mop:slot-definition-name slot)))
        (when (slot-boundp entry slot-name)
          (push (slot-value entry slot-name) result)
          (push slot-name result))))
    result))

(defun plist-entry (plist)
  "Take a plist, return an Entry."
  (let ((entry (make-instance 'entry)))
    (doplist (slot-name value plist entry)
      (setf (slot-value entry slot-name)
            value))))

(defun save-entry (entry)
  (let ((*print-readably* t))
    (with-open-file (out (merge-pathnames (digest-for-entry entry) +db-root+) :direction :output :external-format :utf-8)
      (write (entry-plist entry) :stream out))))

(defun load-entry (digest)
  (with-open-file (in (merge-pathnames digest +db-root+) :direction :input :external-format :utf-8)
    (let ((*package* (find-package "CL-KNOWLEDGE-BASE")))
      (plist-entry (read in)))))

(defun list-entries ()
  (mapcar 'load-entry
          (mapcar 'pathname-name (uiop/filesystem:directory-files +db-root+))))

(defun list-tags ()
  "Return a list of all the tags used by the questions."
  (when-let (questions (list-entries))
    (remove-duplicates (mappend 'tags-of questions)
                       :test 'string-equal)))

(defun find-entry-by-title (title)
  (find title (list-entries) :test #'string-equal :key #'title))

(defun tagged-with-p (entry tag)
  "Does the ENTRY have the TAG?"
  (member tag (tags-of entry) :test 'string-equal))

(defun questions-tagged-with (tag)
  (remove-if-not (lambda (entry)
                   (tagged-with-p entry tag))
                 (list-entries)))
