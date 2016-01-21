----
title: How do I process docstrings and declarations in macros that expand to defun or defmacro?
tags: macros
----

Take for example

```lisp
(deftag field (control attrs)
  `(:p ,@attrs ,@control))

;; One may want to document it

(deftag field (control attrs)
  "A field"
  `(:p ,@attrs ,@control))

;; or add declarations

(deftag field (control attrs)
  (declare (optimize (debug 3)))
  `(:p ,@attrs ,@control))

;; or both

(deftag field (control attrs)
  "A field"
  (declare (optimize (debug 3)))
  `(:p ,@attrs ,@control))
```


Alexandria's parse-body allows us to handle all cases, by extracting the documentation and the declarations from the body. For example:

```lisp
(alexandria:parse-body '("A field"
  (declare (optimize (debug 3)))
  `(:p ,@attrs ,@control)) :documentation t)

;; 1st value, The body
;; => (`(:P ,@ATTRS ,@CONTROL))
;; 2nd value, The declarations
;; => ((DECLARE (OPTIMIZE (DEBUG 3))))
;; 3rd value, The docstring
;; => "A field"
```

* talk about the nuance of docstring being nil before. Think of a simpler macro.

And one would use it in the macro like

```lisp
(defmacro deftag (name (body attrs-var &rest ll) &body tag)
  (multiple-value-bind (tag decls docstring)
      (parse-body tag :documentation t)
    `(defmacro ,name (&body ,body)
       ,@(and docstring (list docstring))
       (multiple-value-bind  (,body ,attrs-var)
           (parse-deftag-body ,body)
         ,@decls
         ;; Bind the keywords to the provided arguments.
         (destructuring-bind ,(allow-other-keys ll)
             ,attrs-var
           ;; Remove the keywords from the attributes.
           (let ((,attrs-var (remove-from-plist ,attrs-var ,@(extract-lambda-list-keywords ll))))
             (list 'with-html ,@tag)))))))
```

the `@,(and docstring (list docstrigs))` idiom is to handle the case of no docstring but having a declaration. Simply writing `,docstring` would insert nil before the declarations. Taking advantage that splicing a empty list would elide it altogether the idiom before handles fixes the issue.

The is also "com.informatimago.common-lisp.lisp-sexp" parse-body, that returns the docstring wrapped in a list so one can use `,@docstring` directly.

---

10:21:02	loke	PuercoPop: Because if docstring is "foo", then (and docstring) results in "foo", which (and dicstring (list docstring)) results in ("foo")
10:21:15	loke	in both cases, they become NIL when docstring is NIL
10:22:32	pjb	and you don't want to insert NIL before declarations for example…
10:23:09	pjb	Now, what I do is to use a docstrings variable instead of docstring, that is bound to a list of 0 or 1 string. Then I can write ,@docstrings
10:24:02	pjb	cf. com.informatimago.common-lisp.lisp-sexp.source-form:parse-body
10:31:08	PuercoPop	loke: Ah I hadn't considered the nil case. Although macroexpand-1 shows that the nil case is handled with the ,@ version I'm unclear as to why splicing nil would elide it altogether. Anyhow it seems a useful trick to know. pjb: Thanks I'll check it out
10:33:24	PuercoPop	another way could be to use (setf (documentation ...)) for the docstring and just leave the declarations in the defmacro form.
10:41:43	PuercoPop	pjb: Your design seems to be better suited than alexandria's for macro writing, I guess it alexandria doesn't incorporate it due to backwards compatibility?
10:45:04	mulk	** NICK mulk_
11:23:29	pjb	nil is () this is why ,@() is nop.
11:24:14	pjb	It's not a bad idea to use setf documentation (adding an eval-when).
11:25:42	pjb	At one time, you have to grep for your modified operators, but it's worth it. Of course, in the case of a public library that means that all users should be notified, or to use a new function name.
