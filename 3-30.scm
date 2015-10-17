#lang racket
(require r5rs)

; 半加算器と全加算器はそのまま

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
	(or-gate a b d)
	(and-gate a b c)
	(inverter c e)
	(and-gate d e s)
	'ok))
; delayは、
; D(d) = max(D(a), D(b)) + D(or)
; D(c) = max(D(a), D(b)) + D(and)
; D(e) = D(c) + D(inv)
;      = max(D(a), D(b)) + D(and) + D(inv)
; D(s) = max(D(d), D(e)) + D(and)
       = max(D(a), D(b)) + max(D(and) + D(or), 2*D(and) + D(inv))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
		(c1 (make-wire))
		(c2 (make-wire)))
	(half-adder b c-in s c1)
	(half-adder a s sum c2)
	(or-gate c1 c2 c-out)
	'ok))
; delayは、
; D(s) = max(D(b), D(c-in)) + max(D(and) + D(or), 2*D(and) + D(inv))
; D(c1) = max(D(b), D(c-in)) + D(and)
; D(sum) = max(D(a), max(D(b), D(c-in)) + max(D(and) + D(or), 2*D(and) + D(inv))) + max(D(and) + D(or), 2*D(and) + D(inv))
; D(c2) = max(D(a), max(D(b), D(c-in)) + max(D(and) + D(or), 2*D(and) + D(inv))) + D(and)
; D(c-out) = max(c1, c2) + D(or)
;          = max(D(a), max(D(b), D(c-in)) + max(D(and) + D(or), 2*D(and) + D(inv))) + D(and) + D(or)

(define (ripple-carry-adder an bn sn c)
  (if
	(or (null? an) (null? bn) (null? sn))
	'ok
	(let ((cn (make-wire)))
	  (full-adder (car an) (car bn) c (car sn) cn)
	  (ripple-carry-adder (cdr an) (cdr bn) (cdr sn) cn))))

; delayは、Cの部分がfull-adderの時のn倍になる
; max(D(and) + D(or), 2*D(and) + D(inv)) + D(and) + D(or)
; max((2 * and+or), (3 * and + inv + or)) * n
; となりそうな気がする

