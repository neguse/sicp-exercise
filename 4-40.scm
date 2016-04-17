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
  (let
	((miller (amb 1 2 3 4 5))
	 (cooper (amb 2 3 4 5)))
	(require (> miller cooper))
	(let
	  ((fletcher (amb 2 3 4)))
	  (require (not (= (abs (- fletcher cooper)) 1)))
	  (distinct? (list cooper fletcher miller))
	  (let ((smith (amb 1 2 3 4 5)))
		(require (not (= (abs (- smith fletcher)) 1)))
		(let ((baker (amb 1 2 3 4)))
		  (require (distinct? (list baker cooper fletcher miller smith)))
		  (list
			(list (list 'baker baker)
				  (list 'cooper cooper)
				  (list 'fletcher fletcher)
				  (list 'miller miller)
				  (list 'smith smith))))))))

(multiple-dwelling)
try-again
try-again
try-again
try-again
try-again
try-again

; とりあえず定数の条件は先にいれておく。
; あとは適当に。

