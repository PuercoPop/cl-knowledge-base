(in-package #:cl-knowledge-base)

(defun at-most (max-length string)
  "Return STRING trimmed to MAX-LENGTH."
  (if (> (length string) (1+ max-length))
      (concatenate 'string (subseq string 0 (1- max-length)) "…")
      string))

(defun slots-of (instance)
  "Return a list of slots of an instance."
  (let ((class (class-of instance)))
    (c2mop:ensure-finalized class)
    (c2mop:class-slots class)))

(defmacro do-slots ((varsym instance &optional ret) &body body)
  "Iterate over the slots of an instance"
  `(dolist (,varsym (slots-of ,instance) ,@(when ret (list ret)))
     ,@body))

(defun digest-slot (instance slot)
  (let ((slot-name (c2mop:slot-definition-name slot)))
    (when (slot-boundp instance slot-name)
      (let ((slot-value (slot-value instance slot-name)))
        (if (listp slot-value)
            (apply 'concatenate-strings-to-octets :utf-8 slot-value)
            (string-to-octets slot-value :encoding :utf-8))))))

(defun digest-for-entry (entry)
  (let ((digest (crypto:make-digest :sha256)))
    (do-slots (slot entry) ;; Or do-slot-values?
      (when-let (slot-digest (digest-slot entry slot))
        (crypto:digest-sequence digest slot-digest)))
    (crypto:byte-array-to-hex-string (crypto:produce-digest digest))))
