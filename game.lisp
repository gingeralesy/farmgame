(in-package #:shipwreck-farm)

(progn
  (defmethod setup-scene ((main main) scene)
    (enter (make-instance 'farmer :name :farmer) scene)
    (enter (make-instance 'sidescroll-camera :zoom 4.0) scene)
    (enter (make-instance 'render-pass) scene))
  (maybe-reload-scene))

(defun launch (&rest args)
  (let ((*package* #.*package*)
        (ctx (getf args :context ())))
    (unless (getf ctx :title)
      (setf (getf ctx :title) "Shipwreck Farm")
      (setf (getf args :context) ctx))
    (load-keymap)
    (setf (active-p (action-set 'in-game)) T)
    (apply #'trial:launch 'main args)))

;; Uncomment and compile to reset the keymap.
;; (progn
;;   (let ((*package* #.*package*))
;;     (load-keymap :reset T)))
