(directional move
  (stick :one-of ((:l-h :l-v)))
  (keys :one-of ((:w :a :s :d)
                 (:i :j :k :l)
                 (:up :left :down :right))))

(trigger interact
  (button :one-of (:a))
  (key :one-of (:e)))
