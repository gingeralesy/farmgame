(in-package #:shipwreck-farm)

(define-asset (shipwreck-farm farmer) sprite-data
    #P"farmer.json")

(define-shader-entity farmer (animated-sprite transformed-entity)
  ((sprite-data :initform (asset 'shipwreck-farm 'farmer))
   (transform :initform (transform (vec3) (vec3 1)))
   (direction :initform (nvunit (vec3 -1 -1 0)) :accessor direction)
   (current-action :initform :idle :reader current-action)))

(defmethod (setf current-action) ((action symbol) (farmer farmer))
  (let ((frame (frame-idx farmer))
        (clock (clock farmer)))
    (ecase action
      (:idle (setf (animation farmer) (if (< 0 (vy (direction farmer))) 'nw-idle 'sw-idle)))
      (:walk (setf (animation farmer) (if (< 0 (vy (direction farmer))) 'nw-walk 'sw-walk)))
      (:act (setf (animation farmer) (if (< 0 (vy (direction farmer))) 'nw-act 'sw-act))))
    (when (eql action (current-action farmer))
      (setf (frame farmer) frame)
      (setf (clock farmer) clock)))
  (if (< 0 (vx (direction farmer)))
      (setf (orientation farmer) (qfrom-angle +vy+ pi))
      (setf (orientation farmer) (qfrom-angle +vy+ 0)))
  (setf (slot-value farmer 'current-action) action))

(defmethod handle-input ((farmer farmer))
  (let ((movement (directional 'move)))
    (unless (and (eql (current-action farmer) :act)
                 (eql (animation farmer)
                      (find-animation (if (< 0 (vy (direction farmer))) 'nw-act 'sw-act) farmer)))
      (cond
        ((retained 'interact)
         (clear-retained)
         (setf (current-action farmer) :act))
        ((and (= (vx movement) 0) (= (vy movement) 0))
         (setf (current-action farmer) :idle))
        (T
         ;; Direction changes only while moving
         (when (/= 0 (vx movement))
           (setf (vx (direction farmer)) (vx movement)))
         (when (/= 0 (vy movement))
           (setf (vy (direction farmer)) (vy movement)))
         (nvunit (direction farmer))
         (setf (current-action farmer) :walk))))))

(define-handler (farmer tick :before) (dt)
  (handle-input farmer)
  (when (and (eql (current-action farmer) :walk))
    (let* ((speed 60)
           (movement (directional 'move))
           (total (vlength movement))
           (dx (if (/= total 0) (/ (vx movement) total) 0))
           (dy (if (/= total 0) (/ (vy movement) total) 0)))
      ;; TODO: Multiply movement input with some easing function to make it non-linear.
      (nv+ (location farmer) (vec3 (* dx speed dt) (* dy speed dt) 0)))))
