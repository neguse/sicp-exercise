#lang racket

; 久々にふつうのScheme書ける…

(define (distinct? l)
  (define (include? a l)
	(cond
	  ((null? l) #f)
	  ((= a (car l)) #t)
	  (else (include? a (cdr l)))))
  (cond
	((null? l) #t)
	((null? (cdr l)) #t)
	(else (and (not (include? (car l) (cdr l))) (distinct? (cdr l))))))

(define (index n l)
  (if (= n 0)
	(car l)
	(index (- n 1) (cdr l))))

(define (ok? pattern)
  (let ((baker (index 0 pattern))
		(cooper (index 1 pattern))
		(fletcher (index 2 pattern))
		(miller (index 3 pattern))
		(smith (index 4 pattern)))
	(and
	  (distinct? pattern)
	  (not (= baker 5))
	  (not (= cooper 1))
	  (not (= fletcher 1))
	  (not (= fletcher 5))
	  (> miller cooper)
	  (not (= (abs (- smith fletcher)) 1))
	  (not (= (abs (- fletcher cooper)) 1)))))

(define (pattern-mul x l)
  (cond
	((null? x) '())
	((null? l) (map list x))
	(else
	  (append (map (lambda (i) (cons (car x) i)) l) (pattern-mul (cdr x) l)))))

(define (seq n)
  (if (= n 0)
	'()
	(cons n (seq (- n 1)))))

(define (patterns n)
  (if (= n 0)
	'()
	(pattern-mul (seq 5) (patterns (- n 1)))))

(define (display-pattern pattern)
  (list
	(list 'baker (index 0 pattern))
	(list 'cooper (index 1 pattern))
	(list 'fletcher (index 2 pattern))
	(list 'miller (index 3 pattern))
	(list 'smith (index 4 pattern))))

(map display-pattern (filter ok? (patterns 5)))

; はい。

