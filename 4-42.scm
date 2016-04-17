
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

(define (xor a b)
  (or (and a (not b)) (and (not a) b)))

(define (ranking)
  (let ((betty (amb 1 2 3 4 5))
		(ethel (amb 1 2 3 4 5))
		(joan (amb 1 2 3 4 5))
		(kitty (amb 1 2 3 4 5))
		(mary (amb 1 2 3 4 5)))
	(require
	  (distinct? (list betty ethel joan kitty mary)))
	(require (xor (= kitty 2) (= betty 3)))
	(require (xor (= ethel 1) (= joan 2)))
	(require (xor (= joan 3) (= ethel 5)))
	(require (xor (= kitty 2) (= mary 4)))
	(require (xor (= mary 4) (= betty 1)))
	(list (list 'betty betty)
		  (list 'ethel ethel)
		  (list 'joan joan)
		  (list 'kitty kitty)
		  (list 'mary mary))))

(ranking)
try-again
try-again
try-again
try-again
try-again
try-again

; ((betty 3) (ethel 5) (joan 2) (kitty 1) (mary 4))
; これが答えっぽい。

