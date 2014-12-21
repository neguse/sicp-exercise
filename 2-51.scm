#lang racket
(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))

(define (my-below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom
           (transform-painter (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point))
          (paint-top
           (transform-painter split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
	  (lambda (frame)
		((paint-bottom painter1) frame)
		((paint-top painter2) frame)))))

(paint (my-below einstein einstein))

(define (my-below2 painter1 painter2)
  (rotate270 (beside (rotate90 painter2)
                     (rotate90 painter1))))
(paint (my-below2 einstein einstein))
; うーん、答えみてしまった。

