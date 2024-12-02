(in-package #:cl-user)
(defpackage #:shipwreck-farm
  (:use #:cl+trial)
  (:shadow #:main #:launch)
  (:local-nicknames
   (#:v #:org.shirakumo.verbose))
  (:export
   ;; game.lisp
   #:main
   #:launch))
