(in-package #:shipwreck-farm)

(setf +app-system+ "shipwreck-farm")

(define-action-set in-game)
(define-action move (directional-action in-game))
(define-action interact (in-game))

(define-pool shipwreck-farm)

(defclass main (trial:main) ())

(defmethod setup-rendering :after (display)
  (declare (ignore display))
  (disable-feature :cull-face))
