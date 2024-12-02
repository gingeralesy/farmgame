(in-package #:shipwreck-farm)

(define-asset (shipwreck-farm farmer) sprite-data
    #P"farmer.json")

(define-shader-entity farmer (animated-sprite transformed-entity)
  ((sprite-data :initform (asset 'shipwreck-farm 'farmer))
   (transform :initform (transform (vec3) (vec3 1)))
   (direction :initform :sw :accessor direction)
   (current-action :initform :idle :reader current-action)))

(defmethod (setf current-action) ((action symbol) (farmer farmer))
  (let ((frame (frame-idx farmer))
        (clock (clock farmer)))
    (ecase action
      (:idle
       (setf (animation farmer)
             (ecase (direction farmer)
               ((:sw :se) 'sw-idle)
               ((:nw :ne) 'nw-idle))))
      (:act
       (setf (animation farmer)
             (ecase (direction farmer)
               ((:sw :se) 'sw-act)
               ((:nw :ne) 'nw-act))))
      (:walk
       (setf (animation farmer)
             (ecase (direction farmer)
               ((:sw :se) 'sw-walk)
               ((:nw :ne) 'nw-walk)))))
    (when (eql action (current-action farmer))
      (setf (frame farmer) frame)
      (setf (clock farmer) clock)))
  (ecase (direction farmer)
    ((:sw :nw) (setf (orientation farmer) (qfrom-angle +vy+ 0)))
    ((:se :ne) (setf (orientation farmer) (qfrom-angle +vy+ pi))))
  (setf (slot-value farmer 'current-action) action))

(defmethod handle-input ((farmer farmer))
  (let ((movement (directional 'move)))
    (unless (and (eql (current-action farmer) :act)
                 (eql (animation farmer)
                      (find-animation
                       (ecase (direction farmer)
                         ((:sw :se) 'sw-act)
                         ((:nw :ne) 'nw-act))
                       farmer)))
      (cond
        ((retained 'interact)
         (clear-retained)
         (setf (current-action farmer) :act))
        ((and (= (vx movement) 0) (= (vy movement) 0))
         (setf (current-action farmer) :idle))
        (T
         (setf (direction farmer)
               (cond
                 ((and (< 0 (vy movement)) (< 0 (vx movement))) :ne)
                 ((< 0 (vy movement)) :nw)
                 ((< 0 (vx movement)) :se)
                 (T :sw)))
         (setf (current-action farmer) :walk))))))

(define-handler (farmer tick :before) (dt)
  (handle-input farmer)
  (when (and (eql (current-action farmer) :walk))
    (let ((speed 50)
          (movement (directional 'move)))
      (nv+ (location farmer)
           (vec3
            ;; TODO: Multiply movement input with some easing function to make it non-linear.
            (* (vx movement) speed dt)
            (* (vy movement) speed dt)
            0)))))
