#lang racket

; integer > rational > real > complex

(define (raise x) (apply-generic 'raise x))


(define (install-integer-coercion-package)
  (put 'raise '(integer)
	   (lambda (x) (attach-tag 'rational (make-rat x 1))))
  'done)

(define (install-rational-coercion-package)
  (define (numer x) (car x))
  (define (denom x) (cdr x))

  (put 'raise '(rational)
	   (lambda (x) (attach-tag 'real (/ (numer x) (denom x)))))
  'done)

(define (install-real-coercion-package)
  (put 'raise '(real)
	   (lambda (x) (attach-tag 'complex (make-complex-from-real-imag x 0))))
  'done)

; こんなもんじゃないでしょうか。動かしてないけど。
