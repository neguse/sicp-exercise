#lang racket

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (random-in-range low high)
  (let ((range (- high low)))
	(+ low (random range))))

(define (rect-area x1 y1 x2 y2)
  (* (- x2 x1) (- y2 y1)))

(define (estimate-integral x1 y1 x2 y2 trials experiment)
  (*
	(rect-area x1 y1 x2 y2)
	(monte-carlo trials experiment)))

(define (center v1 v2)
  (/ (+ v1 v2) 2))

(define (problem-area x1 y1 x2 y2 radius)
  (estimate-integral
	x1 y1 x2 y2
	100000000
	(lambda () 
	  (let (
			(x (random-in-range x1 x2))
			(y (random-in-range y1 y2)))
		(<=
		  (+
			(expt (- x (center x1 x2)) 2)
			(expt (- y (center y1 y2)) 2))
		  (expt radius 2))))))

(problem-area 2 4 8 10 3)
; iter 1000   : 1323/50      -> 26.46
; iter 100000 : 676953/25000 -> 27.07812

; 半径3の円の面積は、3^2 * PI -> 28.2743338823 なので、
; だいたいあってますね。
