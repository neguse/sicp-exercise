
(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (distinct? items)
  (cond ((null? items) true)
		((null? (cdr items)) true)
		((member (car items) (cdr items)) false)
		(else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
		(cooper (amb 1 2 3 4 5))
		(fletcher (amb 1 2 3 4 5))
		(miller (amb 1 2 3 4 5))
		(smith (amb 1 2 3 4 5)))
	(require
	  (distinct? (list baker cooper fletcher miller smith)))
	(require (not (= baker 5)))
	(require (not (= cooper 1)))
	(require (not (= fletcher 5)))
	(require (not (= fletcher 1)))
	(require (> miller cooper))
	(require (not (= (abs (- fletcher cooper)) 1)))
	(list (list 'baker baker)
		  (list 'cooper cooper)
		  (list 'fletcher fletcher)
		  (list 'miller miller)
		  (list 'smith smith))))

(multiple-dwelling)
try-again
try-again
try-again
try-again
try-again
try-again


; ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5))
; ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3))
; ((baker 1) (cooper 4) (fletcher 2) (miller 5) (smith 3))
; ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
; ((baker 3) (cooper 4) (fletcher 2) (miller 5) (smith 1))
; で5通りですね

