#lang planet neil/sicp

(define (split f1 f2)
  (define (split-fn painter n)
	(if (= n 0)
	  painter
	  (let ((smaller (split-fn painter (- n 1))))
		(f1 painter (f2 smaller smaller)))))
  split-fn)

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

(paint (corner-split einstein 3))
; foldとか使ってもっと汎用に書けるかと思ったけど
; 安直な解答です
